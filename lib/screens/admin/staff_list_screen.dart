import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/staff_list/staff_list_bloc.dart';
import '../../core/di.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/user.dart';
import '../../data/models/user_role.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/filter_pills.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';

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

    return Scaffold(
      appBar: const AppHeader(subtitle: 'Or Schedule'),
      bottomNavigationBar: AppBottomNavBar(
        role: user.role,
        currentRouteName: AppRoutes.adminStaff,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<StaffListBloc, StaffListState>(
          listenWhen: (p, c) =>
              p.actionMessage != c.actionMessage && c.actionMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          },
          builder: (context, state) {
            return switch (state.status) {
              StaffListStatus.initial ||
              StaffListStatus.loading =>
                state.users.isEmpty ? const LoadingView() : _Body(state: state),
              StaffListStatus.error => ErrorView(
                  message: state.errorMessage ?? 'Failed to load staff',
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
                    Text('Staff Directory', style: AppTextStyles.headlineMd),
                    Text(
                      'Surgical suites & clinical personnel overview',
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
                  '${state.users.length} Active',
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
            decoration: const InputDecoration(
              hintText: 'Filter by name, email or specialty…',
              prefixIcon:
                  Icon(Icons.search, color: AppColors.textSecondary),
            ),
            onChanged: (v) =>
                context.read<StaffListBloc>().add(StaffListSearchChanged(v)),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        FilterPills<StaffListFilter>(
          options: [
            FilterOption(
              label: 'All (${state.countOf(StaffListFilter.all)})',
              value: StaffListFilter.all,
            ),
            FilterOption(
              label: 'Surgeons (${state.countOf(StaffListFilter.surgeon)})',
              value: StaffListFilter.surgeon,
            ),
            FilterOption(
              label:
                  'Coordinators (${state.countOf(StaffListFilter.coordinator)})',
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
                    children: const [
                      SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.people_outline,
                        title: 'No matching staff',
                        subtitle: 'Try a different filter or search term.',
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
            label: 'Add Staff',
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
        password: draft.password,
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

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remove ${user.name}?'),
        content: const Text(
          'If this user has scheduled surgeries, the removal will fail.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Remove'),
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
    final (label, bg, fg, border) = switch (role) {
      UserRole.admin => (
          'Admin',
          AppColors.softHover,
          AppColors.textSecondary,
          AppColors.divider,
        ),
      UserRole.coordinator => (
          'Coordinator',
          AppColors.statusPreparingBg,
          AppColors.accentText,
          AppColors.statusPreparingBorder,
        ),
      UserRole.surgeon => (
          'Surgeon',
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
    required this.password,
    required this.role,
    required this.specialty,
  });
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? specialty;
}

class _AddStaffSheet extends StatefulWidget {
  const _AddStaffSheet();

  @override
  State<_AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<_AddStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specialtyController = TextEditingController();
  UserRole _role = UserRole.coordinator;

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
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenEdge,
        right: AppSpacing.screenEdge,
        top: AppSpacing.xs,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add Staff', style: AppTextStyles.headlineMd),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'At least 8 characters',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 8) return 'Minimum 8 characters';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<UserRole>(
              initialValue: _role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: const [
                DropdownMenuItem(
                  value: UserRole.coordinator,
                  child: Text('Coordinator'),
                ),
                DropdownMenuItem(
                  value: UserRole.surgeon,
                  child: Text('Surgeon'),
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
                    const InputDecoration(labelText: 'Specialty'),
                validator: (v) => _role == UserRole.surgeon &&
                        (v == null || v.trim().isEmpty)
                    ? 'Specialty is required for surgeons'
                    : null,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Add staff',
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                final specialty = _specialtyController.text.trim();
                Navigator.of(context).pop(_StaffDraft(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                  role: _role,
                  specialty: specialty.isEmpty ? null : specialty,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
