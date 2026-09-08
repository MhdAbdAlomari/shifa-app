import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/my_surgeries/my_surgeries_bloc.dart';
import '../../core/di.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surgery.dart';
import '../../data/models/surgery_status.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class MySurgeriesScreen extends StatelessWidget {
  const MySurgeriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MySurgeriesBloc(
        surgeryService: context.read<AppContainer>().surgeryService,
      )..add(const MySurgeriesRequested()),
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
      appBar: const AppHeader(subtitle: 'My Surgeries'),
      bottomNavigationBar: AppBottomNavBar(
        role: user.role,
        currentRouteName: AppRoutes.surgeonMySurgeries,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<MySurgeriesBloc, MySurgeriesState>(
          listenWhen: (p, c) =>
              p.actionMessage != c.actionMessage && c.actionMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          },
          builder: (context, state) {
            return switch (state.status) {
              MySurgeriesStatus.initial ||
              MySurgeriesStatus.loading =>
                state.items.isEmpty ? const LoadingView() : _Body(state: state),
              MySurgeriesStatus.error => ErrorView(
                  message:
                      state.errorMessage ?? 'Failed to load your surgeries',
                  onRetry: () => context
                      .read<MySurgeriesBloc>()
                      .add(const MySurgeriesRequested()),
                ),
              MySurgeriesStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final MySurgeriesState state;

  static final _dateFmt = DateFormat('MMMM d');

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    final local = dt.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.read<AuthBloc>().state.user?.name ?? '';

    final today = state.items.where((s) => _isToday(s.scheduledStart)).toList()
      ..sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));
    final hasDelayed = today.any((s) => s.status == SurgeryStatus.delayed);

    // "Next up" = first in-progress case, else first scheduled case.
    // If neither exists (all completed/cancelled), we skip the Next Up
    // card and just show whatever remains in the day's list.
    Surgery? nextUp;
    for (final s in today) {
      if (s.status == SurgeryStatus.inProgress) {
        nextUp = s;
        break;
      }
    }
    nextUp ??= today
        .where((s) => s.status == SurgeryStatus.scheduled)
        .cast<Surgery?>()
        .firstWhere((_) => true, orElse: () => null);
    final hasNextUp = nextUp != null;
    final upcoming =
        today.where((s) => !hasNextUp || s.id != nextUp!.id).toList();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context
          .read<MySurgeriesBloc>()
          .add(const MySurgeriesRefreshRequested()),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenEdge,
        ),
        children: [
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Surgeries', style: AppTextStyles.headlineMd),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          'Today, ${_dateFmt.format(DateTime.now())}',
                          style: AppTextStyles.bodySm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _NamePill(name: userName),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Scheduled Today',
                  value: '${today.length} Case${today.length == 1 ? '' : 's'}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryCard(
                  label: 'Current Status',
                  value: hasDelayed ? 'Delayed' : 'On Schedule',
                  accent: hasDelayed
                      ? AppColors.accentText
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (today.isEmpty)
            const EmptyView(
              icon: Icons.medical_services_outlined,
              title: 'No assigned surgeries today',
              subtitle: 'Nothing on your list right now.',
            )
          else ...[
            if (hasNextUp)
              _NextUpCard(
                surgery: nextUp,
                isStarting: state.startingId == nextUp.id,
              ),
            const SizedBox(height: AppSpacing.md),
            for (final s in upcoming) ...[
              _UpcomingCard(surgery: s),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

}

class _NamePill extends StatelessWidget {
  const _NamePill({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
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
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.textOnPrimary,
              size: 14,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              name,
              style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.accent,
  });

  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelSm),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              if (accent != null)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                value,
                style: AppTextStyles.titleLg.copyWith(
                  color: accent ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextUpCard extends StatelessWidget {
  const _NextUpCard({required this.surgery, required this.isStarting});

  final Surgery surgery;
  final bool isStarting;

  static final _timeFmt = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context) {
    final start = surgery.scheduledStart.toLocal();
    final end = start.add(Duration(minutes: surgery.estimatedDurationMin));
    return AppCard(
      onTap: () => context.pushNamed(
        AppRoutes.surgeryDetail,
        pathParameters: {'id': '${surgery.id}'},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                surgery.status == SurgeryStatus.inProgress ? 'IN PROGRESS' : 'NEXT UP',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              StatusBadge.surgery(surgery.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            surgery.patient?.name ?? 'Patient #${surgery.patientId}',
            style: AppTextStyles.headlineSm,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.meeting_room_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                surgery.room?.name ?? 'Room #${surgery.roomId}',
                style: AppTextStyles.labelLg,
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.schedule,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${_timeFmt.format(start)} – ${_timeFmt.format(end)}',
                style: AppTextStyles.bodyMd,
              ),
            ],
          ),
          if (surgery.status == SurgeryStatus.scheduled) ...[
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Start Surgery',
              icon: Icons.play_arrow,
              isLoading: isStarting,
              onPressed: () => context
                  .read<MySurgeriesBloc>()
                  .add(MySurgeryStartRequested(surgery.id)),
            ),
          ],
        ],
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.surgery});

  final Surgery surgery;

  static final _timeFmt = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context) {
    final start = surgery.scheduledStart.toLocal();
    final end = start.add(Duration(minutes: surgery.estimatedDurationMin));
    return AppCard(
      onTap: () => context.pushNamed(
        AppRoutes.surgeryDetail,
        pathParameters: {'id': '${surgery.id}'},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Upcoming Case',
                  style: AppTextStyles.labelSm,
                ),
              ),
              StatusBadge.surgery(surgery.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            surgery.patient?.name ?? 'Patient #${surgery.patientId}',
            style: AppTextStyles.titleLg,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.meeting_room_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                surgery.room?.name ?? 'Room #${surgery.roomId}',
                style: AppTextStyles.labelLg,
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.schedule,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${_timeFmt.format(start)} – ${_timeFmt.format(end)}',
                style: AppTextStyles.bodyMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
