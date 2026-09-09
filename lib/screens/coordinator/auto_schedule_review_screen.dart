import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auto_schedule_review/auto_schedule_review_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/schedule_proposal.dart';
import '../../data/models/surgery_draft.dart';
import '../../data/models/surgery_priority.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_snack_bar.dart';

/// Auto-Schedule Review screen.
///
/// Two entry points:
///
///   - **From the timeline's Suggestions tab** with no seed — starts in
///     the compose phase, letting the coordinator build a batch of
///     pending requests.
///   - **From the Schedule Surgery form** with a [SurgeryDraft] seed —
///     skips compose and shows proposals for that single draft directly.
class AutoScheduleReviewScreen extends StatelessWidget {
  const AutoScheduleReviewScreen({super.key, this.seedDraft});

  final SurgeryDraft? seedDraft;

  @override
  Widget build(BuildContext context) {
    final container = context.read<AppContainer>();
    return BlocProvider(
      create: (_) => AutoScheduleReviewBloc(
        patientService: container.patientService,
        staffService: container.staffService,
        roomService: container.roomService,
        surgeryTypeService: container.surgeryTypeService,
        surgeryService: container.surgeryService,
        seedDraft: seedDraft,
      )..add(const AutoScheduleReviewOptionsRequested()),
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
        currentRouteName: AppRoutes.coordinatorSuggestions,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<AutoScheduleReviewBloc, AutoScheduleReviewState>(
          listenWhen: (p, c) =>
              p.submitErrorMessage != c.submitErrorMessage &&
              c.submitErrorMessage != null,
          listener: (context, state) {
            showErrorSnackBar(
              context,
              localizedErrorMessage(
                l10n,
                code: state.submitErrorCode,
                fallback: state.submitErrorMessage!,
              ),
            );
          },
          builder: (context, state) {
            return switch (state.loadStatus) {
              AutoScheduleLoadStatus.initial ||
              AutoScheduleLoadStatus.loading =>
                const LoadingView(),
              AutoScheduleLoadStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback: state.errorMessage ?? l10n.autoScheduleFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<AutoScheduleReviewBloc>()
                      .add(const AutoScheduleReviewOptionsRequested()),
                ),
              AutoScheduleLoadStatus.loaded => switch (state.phase) {
                  AutoSchedulePhase.compose => _ComposePhase(state: state),
                  AutoSchedulePhase.review => _ReviewPhase(state: state),
                },
            };
          },
        ),
      ),
    );
  }
}

class _ComposePhase extends StatelessWidget {
  const _ComposePhase({required this.state});

  final AutoScheduleReviewState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            AppSpacing.screenEdge,
            AppSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.autoScheduleTitle,
                style: AppTextStyles.headlineMd,
              ),
              Text(
                l10n.autoScheduleSubtitle,
                style: AppTextStyles.bodySm,
              ),
            ],
          ),
        ),
        Expanded(
          child: state.pending.isEmpty
              ? EmptyView(
                  icon: Icons.playlist_add_outlined,
                  title: l10n.autoScheduleNoPendingTitle,
                  subtitle: l10n.autoScheduleNoPendingSubtitle,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.screenEdge),
                  itemCount: state.pending.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final r = state.pending[i];
                    final patient = state.patients
                        .firstWhere((p) => p.id == r.patientId);
                    final surgeon = state.surgeons
                        .firstWhere((s) => s.id == r.surgeonId);
                    final type = state.surgeryTypes
                        .firstWhere((t) => t.id == r.surgeryTypeId);
                    return AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(patient.name,
                                    style: AppTextStyles.titleLg),
                                Text('${type.name} · ${surgeon.name}',
                                    style: AppTextStyles.bodySm),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => context
                                .read<AutoScheduleReviewBloc>()
                                .add(AutoScheduleReviewPendingRemoved(i)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: Column(
            children: [
              PrimaryButton(
                label: l10n.autoScheduleAddRequest,
                icon: Icons.add,
                variant: PrimaryButtonVariant.subdued,
                onPressed: () => _openAddSheet(context, state),
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: state.pending.isEmpty
                    ? l10n.autoScheduleAddRequestFirst
                    : l10n.autoScheduleGenerateProposals(state.pending.length),
                icon: Icons.auto_awesome,
                isLoading:
                    state.submitStatus == AutoScheduleSubmitStatus.submitting,
                onPressed: state.pending.isEmpty
                    ? null
                    : () => context
                        .read<AutoScheduleReviewBloc>()
                        .add(const AutoScheduleReviewProposalsRequested()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openAddSheet(
    BuildContext context,
    AutoScheduleReviewState state,
  ) async {
    final bloc = context.read<AutoScheduleReviewBloc>();
    final request = await showModalBottomSheet<PendingSurgeryRequest>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _AddRequestSheet(state: state),
    );
    if (request != null) bloc.add(AutoScheduleReviewPendingAdded(request));
  }
}

class _AddRequestSheet extends StatefulWidget {
  const _AddRequestSheet({required this.state});

  final AutoScheduleReviewState state;

  @override
  State<_AddRequestSheet> createState() => _AddRequestSheetState();
}

class _AddRequestSheetState extends State<_AddRequestSheet> {
  int? _patientId;
  int? _surgeonId;
  int? _typeId;
  SurgeryPriority _priority = SurgeryPriority.normal;

  bool get _isValid =>
      _patientId != null && _surgeonId != null && _typeId != null;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.autoScheduleAddSheetTitle, style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<int>(
            initialValue: _patientId,
            decoration: InputDecoration(labelText: l10n.scheduleSurgeryPatientLabel),
            items: [
              for (final p in widget.state.patients)
                DropdownMenuItem(value: p.id, child: Text(p.name)),
            ],
            onChanged: (v) => setState(() => _patientId = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<int>(
            initialValue: _surgeonId,
            decoration: InputDecoration(labelText: l10n.scheduleSurgerySurgeonLabel),
            items: [
              for (final s in widget.state.surgeons)
                DropdownMenuItem(value: s.id, child: Text(s.name)),
            ],
            onChanged: (v) => setState(() => _surgeonId = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<int>(
            initialValue: _typeId,
            decoration: InputDecoration(labelText: l10n.scheduleSurgeryTypeLabel),
            items: [
              for (final t in widget.state.surgeryTypes)
                DropdownMenuItem(value: t.id, child: Text(t.name)),
            ],
            onChanged: (v) => setState(() => _typeId = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<SurgeryPriority>(
            segments: [
              ButtonSegment(
                value: SurgeryPriority.normal,
                label: Text(l10n.scheduleSurgeryPriorityNormal),
              ),
              ButtonSegment(
                value: SurgeryPriority.emergency,
                label: Text(l10n.scheduleSurgeryPriorityEmergency),
              ),
            ],
            selected: {_priority},
            onSelectionChanged: (s) => setState(() => _priority = s.first),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: l10n.autoScheduleAddToBatch,
            onPressed: _isValid
                ? () => Navigator.of(context).pop(PendingSurgeryRequest(
                      patientId: _patientId!,
                      surgeonId: _surgeonId!,
                      surgeryTypeId: _typeId!,
                      priority: _priority,
                    ))
                : null,
          ),
        ],
      ),
    );
  }
}

class _ReviewPhase extends StatelessWidget {
  const _ReviewPhase({required this.state});

  final AutoScheduleReviewState state;

  static final _timeFmt = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.openProposalIndexes.isEmpty && state.proposals.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: EmptyView(
              icon: Icons.check_circle_outline,
              title: l10n.autoScheduleAllActionedTitle,
              subtitle: l10n.autoScheduleAllActionedSubtitle(
                state.acceptedCount,
                state.proposals.length - state.acceptedCount,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenEdge),
            child: PrimaryButton(
              label: l10n.autoScheduleStartNewBatch,
              onPressed: () => context
                  .read<AutoScheduleReviewBloc>()
                  .add(const AutoScheduleReviewReset()),
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            AppSpacing.screenEdge,
            AppSpacing.xs,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.autoScheduleTitle,
                  style: AppTextStyles.headlineMd,
                  textAlign: TextAlign.center,
                ),
                Text(
                  l10n.autoScheduleSubtitle,
                  style: AppTextStyles.bodySm,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          sliver: SliverList.separated(
            itemCount: state.proposals.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) {
              final open = state.openProposalIndexes.contains(i);
              if (!open) return const SizedBox.shrink();
              return _ProposalCard(
                index: i,
                proposal: state.proposals[i],
                state: state,
                timeFmt: _timeFmt,
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
      ],
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.index,
    required this.proposal,
    required this.state,
    required this.timeFmt,
  });

  final int index;
  final ScheduleProposal proposal;
  final AutoScheduleReviewState state;
  final DateFormat timeFmt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final patient =
        state.patients.firstWhere((p) => p.id == proposal.patientId);
    final room = state.rooms.firstWhere((r) => r.id == proposal.roomId);
    final start = proposal.scheduledStart.toLocal();
    final end = start.add(Duration(minutes: proposal.estimatedDurationMin));
    final isAccepting = state.acceptingIndex == index;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(patient.name, style: AppTextStyles.titleLg)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.statusFreeBg,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSmall),
                  border: Border.all(color: AppColors.statusFreeBorder),
                ),
                child: Text(
                  room.name,
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.schedule,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${_dayLabel(context, start)}, ${timeFmt.format(start)} – ${timeFmt.format(end)}',
                style: AppTextStyles.bodySm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: l10n.autoScheduleAccept,
                  icon: Icons.check,
                  isLoading: isAccepting,
                  onPressed: () => context
                      .read<AutoScheduleReviewBloc>()
                      .add(AutoScheduleReviewProposalAccepted(index)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: l10n.autoScheduleReject,
                  icon: Icons.close,
                  variant: PrimaryButtonVariant.subdued,
                  onPressed: isAccepting
                      ? null
                      : () => context
                          .read<AutoScheduleReviewBloc>()
                          .add(AutoScheduleReviewProposalRejected(index)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _dayLabel(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(dt.year, dt.month, dt.day);
    final delta = that.difference(today).inDays;
    if (delta == 0) return l10n.autoScheduleToday;
    if (delta == 1) return l10n.autoScheduleTomorrow;
    return DateFormat('EEE, MMM d').format(dt);
  }
}
