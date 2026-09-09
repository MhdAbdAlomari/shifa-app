import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/staff_list/staff_list_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/l10n/message_code.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/user.dart';
import '../../data/models/user_role.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/filter_pills.dart';
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
      MessageCode.roomDeleted => l10n.messageRoomDeleted,
      MessageCode.roomAdded => l10n.messageRoomAdded,
      MessageCode.staffDeleted => l10n.messageStaffDeleted,
      MessageCode.staffAdded => l10n.messageStaffAdded,
      MessageCode.staffUpdated => l10n.messageStaffUpdated,
      MessageCode.surgeryStarted => l10n.messageSurgeryStarted,
      MessageCode.surgeryCancelled => l10n.messageSurgeryCancelled,
      _ => localizedErrorMessage(l10n, code: errorCode, fallback: error ?? ''),
    };
  }
  return localizedErrorMessage(l10n, code: errorCode, fallback: error ?? '');
}

class StaffListScreen extends StatelessWidget {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaffListBloc(
        staffService: context.read<AppContainer>().staffService,
      )..add(const StaffListRequested()),
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
        currentRouteName: AppRoutes.adminStaff,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<StaffListBloc, StaffListState>(
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
              StaffListStatus.initial ||
              StaffListStatus.loading =>
                state.users.isEmpty ? const LoadingView() : _Body(state: state),
              StaffListStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback: state.errorMessage ?? l10n.staffListFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<StaffListBloc>()
                      .add(const StaffListRequested()),
                ),
              StaffListStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final StaffListState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visible = state.visibleUsers;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            AppSpacing.screenEdge,
            AppSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.staffListTitle, style: AppTextStyles.headlineMd),
                    Text(
                      l10n.staffListSubtitle,
                      style: AppTextStyles.bodySm,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs + 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.statusFreeBg,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(color: AppColors.statusFreeBorder),
                ),
                child: Text(
                  l10n.staffListActiveCount(state.users.length),
                  style: AppTextStyles.labelSm
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.staffListSearchHint,
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textSecondary),
            ),
            onChanged: (v) =>
                context.read<StaffListBloc>().add(StaffListSearchChanged(v)),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        FilterPills<StaffListFilter>(
          options: [
            FilterOption(
              label: l10n.staffListFilterAll(
                state.countOf(StaffListFilter.all),
              ),
              value: StaffListFilter.all,
            ),
            FilterOption(
              label: l10n.staffListFilterSurgeons(
                state.countOf(StaffListFilter.surgeon),
              ),
              value: StaffListFilter.surgeon,
            ),
            FilterOption(
              label: l10n.staffListFilterCoordinators(
                state.countOf(StaffListFilter.coordinator),
              ),
              value: StaffListFilter.coordinator,
            ),
          ],
          selected: state.filter,
          onChanged: (v) =>
              context.read<StaffListBloc>().add(StaffListFilterChanged(v)),
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => context
                .read<StaffListBloc>()
                .add(const StaffListRefreshRequested()),
            child: visible.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.people_outline,
                        title: l10n.staffListNoMatchTitle,
                        subtitle: l10n.staffListNoMatchSubtitle,
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screenEdge),
                    itemCount: visible.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => _StaffRow(
                      user: visible[i],
                      isDeleting: state.deletingId == visible[i].id,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: PrimaryButton(
            label: l10n.staffListAddStaff,
            icon: Icons.person_add_alt_1,
            isLoading: state.creating,
            onPressed: () => _openAddSheet(context),
          ),
        ),
      ],
    );
  }

  Future<void> _openAddSheet(BuildContext context) async {
    final bloc = context.read<StaffListBloc>();
    final draft = await showModalBottomSheet<_StaffDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AddStaffSheet(),
    );
    if (draft != null) {
      bloc.add(StaffListCreateRequested(
        name: draft.name,
        email: draft.email,
        // Non-null: add-mode's form validator requires a password.
        password: draft.password!,
        role: draft.role,
        specialty: draft.specialty,
      ));
    }
  }
}

class _StaffRow extends StatelessWidget {
  const _StaffRow({required this.user, required this.isDeleting});

  final User user;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => _openEditSheet(context),
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
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(user.name),
              style: AppTextStyles.titleLg
                  .copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.titleLg),
                Text(
                  user.specialty ?? user.email,
                  style: AppTextStyles.bodySm.copyWith(
                    color: user.specialty == null
                        ? AppColors.textSecondary
                        : AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          _RolePill(role: user.role),
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

  Future<void> _openEditSheet(BuildContext context) async {
    final bloc = context.read<StaffListBloc>();
    final draft = await showModalBottomSheet<_StaffDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _AddStaffSheet(existing: user),
    );
    if (draft != null) {
      bloc.add(StaffListUpdateRequested(
        id: user.id,
        name: draft.name,
        email: draft.email,
        password: draft.password,
        role: draft.role,
        specialty: draft.specialty,
      ));
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.staffListRemoveTitle(user.name)),
        content: Text(l10n.staffListRemoveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l10n.commonRemove),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<StaffListBloc>().add(StaffListDeleteRequested(user.id));
    }
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, bg, fg, border) = switch (role) {
      UserRole.admin => (
          l10n.staffListRoleAdmin,
          AppColors.softHover,
          AppColors.textSecondary,
          AppColors.divider,
        ),
      UserRole.coordinator => (
          l10n.staffListRoleCoordinator,
          AppColors.statusPreparingBg,
          AppColors.accentText,
          AppColors.statusPreparingBorder,
        ),
      UserRole.surgeon => (
          l10n.staffListRoleSurgeon,
          AppColors.statusFreeBg,
          AppColors.primary,
          AppColors.statusFreeBorder,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(color: fg),
      ),
    );
  }
}

class _StaffDraft {
  const _StaffDraft({
    required this.name,
    required this.email,
    required this.role,
    this.password,
    this.specialty,
  });
  final String name;
  final String email;
  final UserRole role;
  final String? password;
  final String? specialty;
}

/// Add/Edit Staff form. Pass [existing] to pre-fill and switch to edit
/// mode (password becomes optional — leave blank to keep it unchanged).
class _AddStaffSheet extends StatefulWidget {
  const _AddStaffSheet({this.existing});

  final User? existing;

  @override
  State<_AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<_AddStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _emailController =
      TextEditingController(text: widget.existing?.email ?? '');
  final _passwordController = TextEditingController();
  late final _specialtyController =
      TextEditingController(text: widget.existing?.specialty ?? '');
  late UserRole _role = widget.existing?.role ?? UserRole.coordinator;

  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              _isEditing
                  ? l10n.patientsEditSheetTitle
                  : l10n.staffListAddSheetTitle,
              style: AppTextStyles.headlineMd,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.staffListNameLabel),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.staffListNameRequired
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.staffListEmailLabel),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return l10n.staffListEmailRequired;
                }
                if (!v.contains('@')) return l10n.staffListEmailInvalid;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.staffListPasswordLabel,
                hintText: l10n.staffListPasswordHint,
              ),
              validator: (v) {
                if (!_isEditing && (v == null || v.isEmpty)) {
                  return l10n.staffListPasswordRequired;
                }
                if (v != null && v.isNotEmpty && v.length < 8) {
                  return l10n.staffListPasswordTooShort;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<UserRole>(
              initialValue: _role,
              decoration: InputDecoration(labelText: l10n.staffListRoleLabel),
              items: [
                DropdownMenuItem(
                  value: UserRole.coordinator,
                  child: Text(l10n.staffListRoleCoordinator),
                ),
                DropdownMenuItem(
                  value: UserRole.surgeon,
                  child: Text(l10n.staffListRoleSurgeon),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _role = v);
              },
            ),
            if (_role == UserRole.surgeon) ...[
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _specialtyController,
                decoration:
                    InputDecoration(labelText: l10n.staffListSpecialtyLabel),
                validator: (v) => _role == UserRole.surgeon &&
                        (v == null || v.trim().isEmpty)
                    ? l10n.staffListSpecialtyRequired
                    : null,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: _isEditing ? l10n.commonSave : l10n.staffListAddStaff,
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                final specialty = _specialtyController.text.trim();
                final password = _passwordController.text;
                Navigator.of(context).pop(_StaffDraft(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: password.isEmpty ? null : password,
                  role: _role,
                  specialty: specialty.isEmpty ? null : specialty,
                ));
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
