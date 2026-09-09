import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/patients_list/patients_list_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/l10n/message_code.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/patient.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_snack_bar.dart';

String _messageText(
  AppLocalizations l10n,
  MessageCode? code,
  String? error, [
  String? errorCode,
]) {
  if (code != null) {
    return switch (code) {
      MessageCode.patientDeleted => l10n.messagePatientDeleted,
      MessageCode.patientAdded => l10n.messagePatientAdded,
      MessageCode.patientUpdated => l10n.messagePatientUpdated,
      _ => localizedErrorMessage(l10n, code: errorCode, fallback: error ?? ''),
    };
  }
  return localizedErrorMessage(l10n, code: errorCode, fallback: error ?? '');
}

class PatientsListScreen extends StatelessWidget {
  const PatientsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientsListBloc(
        patientService: context.read<AppContainer>().patientService,
      )..add(const PatientsListRequested()),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(subtitle: l10n.subtitleOrSchedule),
      bottomNavigationBar: AppBottomNavBar(
        role: user.role,
        currentRouteName: AppRoutes.patients,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<PatientsListBloc, PatientsListState>(
          listenWhen: (p, c) =>
              (p.actionMessageCode != c.actionMessageCode ||
                  p.actionErrorMessage != c.actionErrorMessage) &&
              (c.actionMessageCode != null || c.actionErrorMessage != null),
          listener: (context, state) {
            final message = _messageText(
              l10n,
              state.actionMessageCode,
              state.actionErrorMessage,
              state.actionErrorCode,
            );
            if (state.actionErrorMessage != null) {
              showErrorSnackBar(context, message);
            } else {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          },
          builder: (context, state) {
            return switch (state.status) {
              PatientsListStatus.initial ||
              PatientsListStatus.loading =>
                state.patients.isEmpty
                    ? const LoadingView()
                    : _Body(state: state),
              PatientsListStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback: state.errorMessage ?? l10n.patientsFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<PatientsListBloc>()
                      .add(const PatientsListRequested()),
                ),
              PatientsListStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final PatientsListState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final patients = state.patients;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            AppSpacing.screenEdge,
            AppSpacing.xs,
          ),
          child: Text(l10n.patientsTitle, style: AppTextStyles.headlineMd),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.patientsSearchHint,
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textSecondary),
            ),
            onChanged: (v) => context
                .read<PatientsListBloc>()
                .add(PatientsListSearchChanged(v)),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => context
                .read<PatientsListBloc>()
                .add(const PatientsListRefreshRequested()),
            child: patients.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.personal_injury_outlined,
                        title: l10n.patientsNoneTitle,
                        subtitle: l10n.patientsNoneSubtitle,
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screenEdge),
                    itemCount: patients.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => _PatientRow(
                      patient: patients[i],
                      isDeleting: state.deletingId == patients[i].id,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: PrimaryButton(
            label: l10n.patientsAddPatient,
            icon: Icons.person_add_alt_1,
            isLoading: state.saving,
            onPressed: () => _openPatientFormSheet(context),
          ),
        ),
      ],
    );
  }
}

Future<void> _openPatientFormSheet(
  BuildContext context, {
  Patient? existing,
}) async {
  final bloc = context.read<PatientsListBloc>();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: _PatientFormSheet(existing: existing),
    ),
  );
}

class _PatientRow extends StatelessWidget {
  const _PatientRow({required this.patient, required this.isDeleting});

  final Patient patient;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => _openPatientFormSheet(context, existing: patient),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.statusFreeBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(patient.name),
              style: AppTextStyles.titleLg
                  .copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.name, style: AppTextStyles.titleLg),
                Text(
                  patient.mrn,
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.textSecondary),
                ),
                if (patient.medicalNotes != null &&
                    patient.medicalNotes!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      patient.medicalNotes!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.secondary),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: isDeleting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.delete_outline),
            onPressed: isDeleting ? null : () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<PatientsListBloc>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.patientsDeleteTitle(patient.name)),
        content: Text(l10n.patientsDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      bloc.add(PatientsListDeleteRequested(patient.id));
    }
  }
}

class _PatientFormSheet extends StatefulWidget {
  const _PatientFormSheet({this.existing});

  final Patient? existing;

  @override
  State<_PatientFormSheet> createState() => _PatientFormSheetState();
}

class _PatientFormSheetState extends State<_PatientFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mrnController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _mrnController = TextEditingController(text: existing?.mrn ?? '');
    _notesController =
        TextEditingController(text: existing?.medicalNotes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mrnController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.existing != null;

    return BlocConsumer<PatientsListBloc, PatientsListState>(
      listenWhen: (p, c) =>
          p.saving != c.saving &&
          !c.saving &&
          c.actionMessageCode != null &&
          c.formErrors.isEmpty,
      listener: (context, state) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.screenEdge,
            right: AppSpacing.screenEdge,
            top: AppSpacing.xs,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
          ),
          child: SingleChildScrollView(
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEdit
                      ? l10n.patientsEditSheetTitle
                      : l10n.patientsAddSheetTitle,
                  style: AppTextStyles.headlineMd,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: l10n.patientsNameLabel),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.patientsNameRequired
                      : null,
                ),
                if (state.formErrors['name'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      state.formErrors['name']!.first,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _mrnController,
                  decoration:
                      InputDecoration(labelText: l10n.patientsMrnLabel),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.patientsMrnRequired
                      : null,
                ),
                if (state.formErrors['mrn'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      state.formErrors['mrn']!.first,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 6,
                  decoration:
                      InputDecoration(labelText: l10n.patientsNotesLabel),
                ),
                if (state.formErrors['medical_notes'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      state.formErrors['medical_notes']!.first,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: l10n.commonSave,
                  isLoading: state.saving,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final notes = _notesController.text.trim();
                    final name = _nameController.text.trim();
                    final mrn = _mrnController.text.trim();
                    final bloc = context.read<PatientsListBloc>();
                    if (isEdit) {
                      bloc.add(PatientsListUpdateRequested(
                        id: widget.existing!.id,
                        name: name,
                        mrn: mrn,
                        medicalNotes: notes.isEmpty ? null : notes,
                      ));
                    } else {
                      bloc.add(PatientsListCreateRequested(
                        name: name,
                        mrn: mrn,
                        medicalNotes: notes.isEmpty ? null : notes,
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }
}
