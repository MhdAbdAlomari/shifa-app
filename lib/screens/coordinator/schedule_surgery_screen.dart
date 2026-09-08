import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/schedule_surgery/schedule_surgery_bloc.dart';
import '../../core/di.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surgery_draft.dart';
import '../../data/models/surgery_priority.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';

/// Stage 1 of the two-stage scheduling flow. Collects the case's
/// clinical inputs (patient, surgeon, type, priority) and hands off to
/// either the auto-scheduler or the manual room/time picker.
class ScheduleSurgeryScreen extends StatelessWidget {
  const ScheduleSurgeryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final container = context.read<AppContainer>();
    return BlocProvider(
      create: (_) => ScheduleSurgeryBloc(
        patientService: container.patientService,
        staffService: container.staffService,
        surgeryTypeService: container.surgeryTypeService,
      )..add(const ScheduleSurgeryOptionsRequested()),
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
        currentRouteName: AppRoutes.coordinatorSchedule,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<ScheduleSurgeryBloc, ScheduleSurgeryState>(
          builder: (context, state) {
            return switch (state.loadStatus) {
              ScheduleSurgeryLoadStatus.initial ||
              ScheduleSurgeryLoadStatus.loading =>
                const LoadingView(),
              ScheduleSurgeryLoadStatus.error => ErrorView(
                  message: state.errorMessage ?? 'Failed to load form',
                  onRetry: () => context
                      .read<ScheduleSurgeryBloc>()
                      .add(const ScheduleSurgeryOptionsRequested()),
                ),
              ScheduleSurgeryLoadStatus.loaded => _canRenderForm(state)
                  ? _Form(state: state)
                  : const EmptyView(
                      icon: Icons.info_outline,
                      title: 'Missing setup data',
                      subtitle:
                          'Ask an admin to add patients, surgeons, and surgery types before scheduling.',
                    ),
            };
          },
        ),
      ),
    );
  }

  bool _canRenderForm(ScheduleSurgeryState s) =>
      s.patients.isNotEmpty &&
      s.surgeons.isNotEmpty &&
      s.surgeryTypes.isNotEmpty;
}

class _Form extends StatelessWidget {
  const _Form({required this.state});

  final ScheduleSurgeryState state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            AppSpacing.screenEdge,
            AppSpacing.md,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.goNamed(AppRoutes.coordinatorTimeline),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Surgery', style: AppTextStyles.headlineMd),
                      Text(
                        'Case Scheduling & OR Assignment',
                        style: AppTextStyles.bodySm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          sliver: SliverList.list(
            children: [
              _FieldSection(
                icon: Icons.person_outline,
                label: 'Patient',
                child: DropdownButtonFormField<int>(
                  initialValue: state.patientId,
                  decoration:
                      const InputDecoration(hintText: 'Select a patient'),
                  items: [
                    for (final p in state.patients)
                      DropdownMenuItem(value: p.id, child: Text(p.name)),
                  ],
                  onChanged: (v) => context
                      .read<ScheduleSurgeryBloc>()
                      .add(ScheduleSurgeryFieldChanged(patientId: v)),
                ),
              ),
              _FieldSection(
                icon: Icons.badge_outlined,
                label: 'Surgeon',
                child: DropdownButtonFormField<int>(
                  initialValue: state.surgeonId,
                  decoration:
                      const InputDecoration(hintText: 'Select a surgeon'),
                  items: [
                    for (final s in state.surgeons)
                      DropdownMenuItem(
                        value: s.id,
                        child: Text(
                          s.specialty == null
                              ? s.name
                              : '${s.name} (${s.specialty})',
                        ),
                      ),
                  ],
                  onChanged: (v) => context
                      .read<ScheduleSurgeryBloc>()
                      .add(ScheduleSurgeryFieldChanged(surgeonId: v)),
                ),
              ),
              _FieldSection(
                icon: Icons.medical_services_outlined,
                label: 'Surgery Type',
                child: DropdownButtonFormField<int>(
                  initialValue: state.surgeryTypeId,
                  decoration:
                      const InputDecoration(hintText: 'Select a type'),
                  items: [
                    for (final t in state.surgeryTypes)
                      DropdownMenuItem(
                        value: t.id,
                        child:
                            Text('${t.name} (${t.averageDurationMin}m)'),
                      ),
                  ],
                  onChanged: (v) => context
                      .read<ScheduleSurgeryBloc>()
                      .add(ScheduleSurgeryFieldChanged(surgeryTypeId: v)),
                ),
              ),
              _FieldSection(
                icon: Icons.flag_outlined,
                label: 'Priority Level',
                child: SegmentedButton<SurgeryPriority>(
                  segments: const [
                    ButtonSegment(
                      value: SurgeryPriority.normal,
                      label: Text('Normal'),
                      icon: Icon(Icons.check_circle_outline),
                    ),
                    ButtonSegment(
                      value: SurgeryPriority.emergency,
                      label: Text('Emergency'),
                      icon: Icon(Icons.warning_amber_outlined),
                    ),
                  ],
                  selected:
                      state.priority == null ? {} : {state.priority!},
                  emptySelectionAllowed: true,
                  onSelectionChanged: (sel) {
                    if (sel.isEmpty) return;
                    context
                        .read<ScheduleSurgeryBloc>()
                        .add(ScheduleSurgeryFieldChanged(
                          priority: sel.first,
                        ));
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Auto-schedule',
                icon: Icons.auto_awesome,
                onPressed: state.isReady
                    ? () => _goAuto(context, state)
                    : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: 'Pick manually',
                icon: Icons.tune,
                variant: PrimaryButtonVariant.subdued,
                onPressed: state.isReady
                    ? () => _goManual(context, state)
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }

  void _goManual(BuildContext context, ScheduleSurgeryState s) {
    final draft = SurgeryDraft(
      patientId: s.patientId!,
      surgeonId: s.surgeonId!,
      surgeryTypeId: s.surgeryTypeId!,
      priority: s.priority!,
    );
    context.pushNamed(AppRoutes.coordinatorPickManually, extra: draft);
  }

  void _goAuto(BuildContext context, ScheduleSurgeryState s) {
    final draft = SurgeryDraft(
      patientId: s.patientId!,
      surgeonId: s.surgeonId!,
      surgeryTypeId: s.surgeryTypeId!,
      priority: s.priority!,
    );
    context.pushNamed(
      AppRoutes.coordinatorAutoScheduleReview,
      extra: draft,
    );
  }
}

class _FieldSection extends StatelessWidget {
  const _FieldSection({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xxs),
              Text(label, style: AppTextStyles.labelLg),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}
