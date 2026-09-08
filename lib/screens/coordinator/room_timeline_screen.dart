import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/room_timeline/room_timeline_bloc.dart';
import '../../core/di.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/room_status.dart';
import '../../data/models/surgery.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

/// Coordinator's Room Timeline — the app's home screen for the
/// coordinator role. Shows a snapshot of every OR right now.
class RoomTimelineScreen extends StatelessWidget {
  const RoomTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final container = context.read<AppContainer>();
    return BlocProvider(
      create: (_) => RoomTimelineBloc(
        roomService: container.roomService,
        surgeryService: container.surgeryService,
      )..add(const RoomTimelineRequested()),
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
        currentRouteName: AppRoutes.coordinatorTimeline,
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<RoomTimelineBloc, RoomTimelineState>(
          builder: (context, state) {
            return switch (state.status) {
              RoomTimelineStatus.initial ||
              RoomTimelineStatus.loading =>
                state.snapshots.isEmpty
                    ? const LoadingView()
                    : _Body(state: state),
              RoomTimelineStatus.error => ErrorView(
                  message: state.errorMessage ?? 'Failed to load timeline',
                  onRetry: () => context
                      .read<RoomTimelineBloc>()
                      .add(const RoomTimelineRequested()),
                ),
              RoomTimelineStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final RoomTimelineState state;

  static final _dateFmt = DateFormat('EEEE, MMM d');

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context
          .read<RoomTimelineBloc>()
          .add(const RoomTimelineRefreshRequested()),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room Timeline', style: AppTextStyles.headlineMd),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              _dateFmt.format(DateTime.now()),
                              style: AppTextStyles.bodySm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _MonitoredPill(count: state.snapshots.length),
                ],
              ),
            ),
          ),
          if (state.snapshots.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                icon: Icons.meeting_room_outlined,
                title: 'No operating rooms',
                subtitle: 'Ask an admin to add rooms.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdge,
              ),
              sliver: SliverList.separated(
                itemCount: state.snapshots.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) =>
                    _RoomCard(snapshot: state.snapshots[i]),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
              vertical: AppSpacing.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: PrimaryButton(
                label: 'Schedule surgery',
                icon: Icons.add,
                onPressed: () =>
                    context.goNamed(AppRoutes.coordinatorSchedule),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        ],
      ),
    );
  }
}

class _MonitoredPill extends StatelessWidget {
  const _MonitoredPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.statusFreeBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.statusFreeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$count Suites Monitored',
            style: AppTextStyles.labelSm.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.snapshot});

  final RoomSnapshot snapshot;

  static final _timeFmt = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context) {
    final current = snapshot.currentSurgery;
    final upcoming = snapshot.nextScheduled;
    final showsCurrent = current != null;

    return AppCard(
      onTap: showsCurrent
          ? () => context.pushNamed(
                AppRoutes.surgeryDetail,
                pathParameters: {'id': '${current.id}'},
              )
          : upcoming != null
              ? () => context.pushNamed(
                    AppRoutes.surgeryDetail,
                    pathParameters: {'id': '${upcoming.id}'},
                  )
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'OR ${snapshot.room.id}',
                style: AppTextStyles.headlineSm,
              ),
              if (snapshot.room.supportedSpecialty != null) ...[
                const SizedBox(width: AppSpacing.xs),
                _SpecialtyChip(text: snapshot.room.supportedSpecialty!),
              ],
              const Spacer(),
              StatusBadge.room(snapshot.room.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _CardBody(
            showsCurrent: showsCurrent,
            current: current,
            upcoming: upcoming,
            timeFmt: _timeFmt,
            roomStatus: snapshot.room.status,
          ),
        ],
      ),
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  const _SpecialtyChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.softHover,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Text(text, style: AppTextStyles.labelSm),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.showsCurrent,
    required this.current,
    required this.upcoming,
    required this.timeFmt,
    required this.roomStatus,
  });

  final bool showsCurrent;
  final Surgery? current;
  final Surgery? upcoming;
  final DateFormat timeFmt;
  final RoomStatus? roomStatus;

  @override
  Widget build(BuildContext context) {
    if (showsCurrent) {
      final s = current!;
      final endEstimate = s.actualStart
          ?.add(Duration(minutes: s.estimatedDurationMin));
      return _CaseRow(
        icon: Icons.person_outline,
        title: s.patient?.name ?? 'Patient #${s.patientId}',
        subtitle: s.surgeryType?.name ?? 'Surgery',
        rightLabel: 'ENDS',
        rightValue: endEstimate == null
            ? '—'
            : timeFmt.format(endEstimate.toLocal()),
        rightHighlighted: true,
      );
    }
    if (upcoming != null) {
      final s = upcoming!;
      return _CaseRow(
        icon: Icons.event_available_outlined,
        title: s.patient?.name ?? 'Patient #${s.patientId}',
        subtitle: s.surgeryType?.name ?? 'Surgery',
        rightLabel: 'NEXT',
        rightValue: timeFmt.format(s.scheduledStart.toLocal()),
        rightHighlighted: false,
      );
    }
    return _EmptyRoomRow(status: roomStatus);
  }
}

class _CaseRow extends StatelessWidget {
  const _CaseRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.rightLabel,
    required this.rightValue,
    required this.rightHighlighted,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String rightLabel;
  final String rightValue;
  final bool rightHighlighted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.softHover,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySm,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rightLabel,
              style: AppTextStyles.labelSm.copyWith(letterSpacing: 0.6),
            ),
            Text(
              rightValue,
              style: AppTextStyles.titleMd.copyWith(
                color: rightHighlighted
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyRoomRow extends StatelessWidget {
  const _EmptyRoomRow({required this.status});

  final RoomStatus? status;

  @override
  Widget build(BuildContext context) {
    final (icon, title, sub) = switch (status) {
      RoomStatus.free => (
          Icons.check_circle_outline,
          'Vacant & Ready',
          'Ready for immediate intake',
        ),
      RoomStatus.preparing => (
          Icons.autorenew,
          'Preparing',
          'Room is being set up',
        ),
      RoomStatus.cleaning => (
          Icons.cleaning_services_outlined,
          'Turnover in progress',
          'Environmental services',
        ),
      RoomStatus.inUse => (
          Icons.circle,
          'In use',
          'No case assigned in the schedule',
        ),
      null => (
          Icons.help_outline,
          'Unknown',
          'Room status not set',
        ),
    };
    return _CaseRow(
      icon: icon,
      title: title,
      subtitle: sub,
      rightLabel: 'STATUS',
      rightValue: switch (status) {
        RoomStatus.free => 'Available',
        RoomStatus.preparing => 'Preparing',
        RoomStatus.cleaning => 'Cleaning',
        RoomStatus.inUse => 'In use',
        null => '—',
      },
      rightHighlighted: status == RoomStatus.free,
    );
  }
}
