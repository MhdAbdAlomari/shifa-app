import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/room_detail/room_detail_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surgery.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

/// Room Detail — full surgery history/schedule for one room, driven by
/// `GET /rooms/{room}/surgeries?from=&to=`. Distinct from Room Timeline
/// (a "now" snapshot across every room): this is one room, any range.
class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key, required this.roomId});

  final int roomId;

  @override
  Widget build(BuildContext context) {
    final container = context.read<AppContainer>();
    return BlocProvider(
      create: (_) => RoomDetailBloc(
        roomService: container.roomService,
        roomId: roomId,
      )..add(const RoomDetailRequested()),
      child: _View(roomId: roomId),
    );
  }
}

class _View extends StatelessWidget {
  const _View({required this.roomId});

  final int roomId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.roomDetailTitle)),
      body: SafeArea(
        child: BlocBuilder<RoomDetailBloc, RoomDetailState>(
          builder: (context, state) {
            return switch (state.status) {
              RoomDetailStatus.initial ||
              RoomDetailStatus.loading =>
                state.room == null
                    ? const LoadingView()
                    : _Body(state: state, roomId: roomId),
              RoomDetailStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback: state.errorMessage ?? l10n.roomDetailFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<RoomDetailBloc>()
                      .add(const RoomDetailRequested()),
                ),
              RoomDetailStatus.loaded => _Body(state: state, roomId: roomId),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.roomId});

  final RoomDetailState state;
  final int roomId;

  @override
  Widget build(BuildContext context) {
    final room = state.room;
    if (room == null) return const LoadingView();
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      children: [
        AppCard(
          hero: true,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusCard),
                ),
                child: room.imageUrl != null
                    ? Image.network(
                        room.imageUrl!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const _RoomImageLoading();
                        },
                        errorBuilder: (_, __, ___) => const _RoomImagePlaceholder(),
                      )
                    : const _RoomImagePlaceholder(),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(room.name, style: AppTextStyles.headlineMd),
                          if (room.supportedSpecialty != null)
                            Text(
                              room.supportedSpecialty!,
                              style: AppTextStyles.bodySm,
                            ),
                        ],
                      ),
                    ),
                    StatusBadge.room(room.status),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: l10n.roomDetailManageAvailability,
          icon: Icons.event_available_outlined,
          variant: PrimaryButtonVariant.outlined,
          onPressed: () => context.pushNamed(
            AppRoutes.roomSlots,
            pathParameters: {'id': '$roomId'},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _RangeFilterRow(state: state),
        const SizedBox(height: AppSpacing.md),
        if (state.surgeries.isEmpty)
          EmptyView(
            icon: Icons.event_busy_outlined,
            title: l10n.roomDetailNoSurgeriesTitle,
            subtitle: l10n.roomDetailNoSurgeriesSubtitle,
          )
        else
          ...state.surgeries.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _SurgeryRow(surgery: s),
              )),
      ],
    );
  }
}

class _RoomImagePlaceholder extends StatelessWidget {
  const _RoomImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      color: AppColors.softHover,
      alignment: Alignment.center,
      child: const Icon(
        Icons.meeting_room_outlined,
        size: 40,
        color: AppColors.textDisabled,
      ),
    );
  }
}

class _RoomImageLoading extends StatelessWidget {
  const _RoomImageLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      color: AppColors.softHover,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _RangeFilterRow extends StatelessWidget {
  const _RangeFilterRow({required this.state});

  final RoomDetailState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: AppSpacing.filterPillHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _RangeChip(
            label: l10n.roomDetailFilterAll,
            selected: state.rangeFilter == RoomDetailRangeFilter.all,
            onTap: () => context.read<RoomDetailBloc>().add(
                  const RoomDetailRangeChanged(
                    RoomDetailRangeFilter.all,
                    clearCustomRange: true,
                  ),
                ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _RangeChip(
            label: l10n.roomDetailFilterToday,
            selected: state.rangeFilter == RoomDetailRangeFilter.today,
            onTap: () => context.read<RoomDetailBloc>().add(
                  const RoomDetailRangeChanged(
                    RoomDetailRangeFilter.today,
                    clearCustomRange: true,
                  ),
                ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _RangeChip(
            label: l10n.roomDetailFilterThisWeek,
            selected: state.rangeFilter == RoomDetailRangeFilter.thisWeek,
            onTap: () => context.read<RoomDetailBloc>().add(
                  const RoomDetailRangeChanged(
                    RoomDetailRangeFilter.thisWeek,
                    clearCustomRange: true,
                  ),
                ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _RangeChip(
            label: l10n.roomDetailFilterLastWeek,
            selected: state.rangeFilter == RoomDetailRangeFilter.lastWeek,
            onTap: () => context.read<RoomDetailBloc>().add(
                  const RoomDetailRangeChanged(
                    RoomDetailRangeFilter.lastWeek,
                    clearCustomRange: true,
                  ),
                ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _RangeChip(
            label: l10n.roomDetailFilterThisMonth,
            selected: state.rangeFilter == RoomDetailRangeFilter.thisMonth,
            onTap: () => context.read<RoomDetailBloc>().add(
                  const RoomDetailRangeChanged(
                    RoomDetailRangeFilter.thisMonth,
                    clearCustomRange: true,
                  ),
                ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _RangeChip(
            label: l10n.roomDetailFilterCustom,
            selected: state.rangeFilter == RoomDetailRangeFilter.custom,
            onTap: () => _pickCustomRange(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      initialDateRange: state.customFrom != null && state.customTo != null
          ? DateTimeRange(start: state.customFrom!, end: state.customTo!)
          : null,
    );
    if (range == null || !context.mounted) return;
    context.read<RoomDetailBloc>().add(
          RoomDetailRangeChanged(
            RoomDetailRangeFilter.custom,
            customFrom: range.start,
            customTo: range.end,
          ),
        );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.divider,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                color:
                    selected ? AppColors.textOnPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurgeryRow extends StatelessWidget {
  const _SurgeryRow({required this.surgery});

  final Surgery surgery;

  static final _fmt = DateFormat('EEE, MMM d · h:mm a');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      onTap: () => context.pushNamed(
        AppRoutes.surgeryDetail,
        pathParameters: {'id': '${surgery.id}'},
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surgery.patient?.name ??
                      l10n.mySurgeriesPatientNumber(surgery.patientId),
                  style: AppTextStyles.titleLg,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  surgery.surgeon?.name ?? '#${surgery.surgeonId}',
                  style: AppTextStyles.bodySm,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _fmt.format(surgery.scheduledStart.toLocal()),
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ),
          StatusBadge.surgery(surgery.status),
        ],
      ),
    );
  }
}
