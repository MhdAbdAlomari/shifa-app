import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/surgery_types_list/surgery_types_list_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/l10n/message_code.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/surgery_type.dart';
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
      MessageCode.surgeryTypeDeleted => l10n.messageSurgeryTypeDeleted,
      MessageCode.surgeryTypeAdded => l10n.messageSurgeryTypeAdded,
      MessageCode.surgeryTypeUpdated => l10n.messageSurgeryTypeUpdated,
      _ => localizedErrorMessage(l10n, code: errorCode, fallback: error ?? ''),
    };
  }
  return localizedErrorMessage(l10n, code: errorCode, fallback: error ?? '');
}

class SurgeryTypesListScreen extends StatelessWidget {
  const SurgeryTypesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurgeryTypesListBloc(
        surgeryTypeService: context.read<AppContainer>().surgeryTypeService,
        roomService: context.read<AppContainer>().roomService,
      )..add(const SurgeryTypesListRequested()),
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
        currentRouteName: AppRoutes.surgeryTypes,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<SurgeryTypesListBloc, SurgeryTypesListState>(
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
              SurgeryTypesListStatus.initial ||
              SurgeryTypesListStatus.loading =>
                state.surgeryTypes.isEmpty
                    ? const LoadingView()
                    : _Body(state: state),
              SurgeryTypesListStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback:
                        state.errorMessage ?? l10n.surgeryTypesFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<SurgeryTypesListBloc>()
                      .add(const SurgeryTypesListRequested()),
                ),
              SurgeryTypesListStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final SurgeryTypesListState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final types = state.surgeryTypes;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            AppSpacing.screenEdge,
            AppSpacing.xs,
          ),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.surgeryTypesTitle,
                        style: AppTextStyles.headlineMd
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.softHover,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => context
                .read<SurgeryTypesListBloc>()
                .add(const SurgeryTypesListRefreshRequested()),
            child: types.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.medical_services_outlined,
                        title: l10n.surgeryTypesNoneTitle,
                        subtitle: l10n.surgeryTypesNoneSubtitle,
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screenEdge),
                    itemCount: types.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => _SurgeryTypeRow(
                      type: types[i],
                      rooms: state.rooms,
                      isDeleting: state.deletingId == types[i].id,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: PrimaryButton(
            label: l10n.surgeryTypesAdd,
            icon: Icons.add,
            isLoading: state.saving,
            onPressed: () => _openAddSheet(context),
          ),
        ),
      ],
    );
  }

  Future<void> _openAddSheet(BuildContext context) async {
    final bloc = context.read<SurgeryTypesListBloc>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const _SurgeryTypeFormSheet(),
      ),
    );
  }
}

class _SurgeryTypeRow extends StatelessWidget {
  const _SurgeryTypeRow({
    required this.type,
    required this.rooms,
    required this.isDeleting,
  });

  final SurgeryType type;
  final List<OperatingRoom> rooms;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String? roomName;
    if (type.defaultRoomId != null) {
      for (final r in rooms) {
        if (r.id == type.defaultRoomId) {
          roomName = r.name;
          break;
        }
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      onTap: () => _openEditSheet(context),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.statusFreeBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.statusFreeBorder),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.medical_services_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.name, style: AppTextStyles.titleLg),
                  Row(
                    children: [
                      Text(
                        l10n.surgeryTypesDurationMinutes(
                          type.averageDurationMin,
                        ),
                        style: AppTextStyles.bodySm,
                      ),
                      if (type.requiredSpecialty != null) ...[
                        Text(' · ', style: AppTextStyles.bodySm),
                        Text(
                          type.requiredSpecialty!,
                          style: AppTextStyles.bodySm,
                        ),
                      ],
                    ],
                  ),
                  if (roomName != null)
                    Text(
                      l10n.surgeryTypesDefaultRoomValue(roomName),
                      style: AppTextStyles.labelSm
                          .copyWith(color: AppColors.textSecondary),
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
      ),
    );
  }

  Future<void> _openEditSheet(BuildContext context) async {
    final bloc = context.read<SurgeryTypesListBloc>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _SurgeryTypeFormSheet(existing: type),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.surgeryTypesDeleteTitle(type.name)),
        content: Text(l10n.surgeryTypesDeleteBody),
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
      context
          .read<SurgeryTypesListBloc>()
          .add(SurgeryTypesListDeleteRequested(type.id));
    }
  }
}

class _SurgeryTypeFormSheet extends StatefulWidget {
  const _SurgeryTypeFormSheet({this.existing});

  final SurgeryType? existing;

  @override
  State<_SurgeryTypeFormSheet> createState() => _SurgeryTypeFormSheetState();
}

class _SurgeryTypeFormSheetState extends State<_SurgeryTypeFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;
  late final TextEditingController _specialtyController;
  int? _defaultRoomId;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _durationController = TextEditingController(
      text: existing == null ? '' : existing.averageDurationMin.toString(),
    );
    _specialtyController =
        TextEditingController(text: existing?.requiredSpecialty ?? '');
    _defaultRoomId = existing?.defaultRoomId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final duration = int.parse(_durationController.text.trim());
    final specialty = _specialtyController.text.trim();
    final bloc = context.read<SurgeryTypesListBloc>();
    if (_isEdit) {
      bloc.add(SurgeryTypesListUpdateRequested(
        id: widget.existing!.id,
        name: name,
        averageDurationMin: duration,
        requiredSpecialty: specialty.isEmpty ? null : specialty,
        defaultRoomId: _defaultRoomId,
      ));
    } else {
      bloc.add(SurgeryTypesListCreateRequested(
        name: name,
        averageDurationMin: duration,
        requiredSpecialty: specialty.isEmpty ? null : specialty,
        defaultRoomId: _defaultRoomId,
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SurgeryTypesListBloc, SurgeryTypesListState>(
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
                  _isEdit
                      ? l10n.surgeryTypesEditSheetTitle
                      : l10n.surgeryTypesAddSheetTitle,
                  style: AppTextStyles.headlineMd,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: l10n.surgeryTypesNameLabel),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.surgeryTypesNameRequired
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
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.surgeryTypesDurationLabel,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.surgeryTypesDurationRequired;
                    }
                    final parsed = int.tryParse(v.trim());
                    if (parsed == null || parsed < 5) {
                      return l10n.surgeryTypesDurationInvalid;
                    }
                    return null;
                  },
                ),
                if (state.formErrors['average_duration_min'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      state.formErrors['average_duration_min']!.first,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _specialtyController,
                  decoration: InputDecoration(
                    labelText: l10n.surgeryTypesSpecialtyLabel,
                  ),
                ),
                if (state.formErrors['required_specialty'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      state.formErrors['required_specialty']!.first,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<int?>(
                  initialValue: _defaultRoomId,
                  decoration: InputDecoration(
                    labelText: l10n.surgeryTypesDefaultRoomLabel,
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(l10n.surgeryTypesNoDefaultRoom),
                    ),
                    for (final room in state.rooms)
                      DropdownMenuItem<int?>(
                        value: room.id,
                        child: Text(room.name),
                      ),
                  ],
                  onChanged: (v) => setState(() => _defaultRoomId = v),
                ),
                if (state.formErrors['default_room_id'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      state.formErrors['default_room_id']!.first,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: _isEdit
                      ? l10n.surgeryTypesEditSheetTitle
                      : l10n.surgeryTypesAddSheetTitle,
                  isLoading: state.saving,
                  onPressed: () => _submit(context),
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
