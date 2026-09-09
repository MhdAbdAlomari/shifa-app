import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../blocs/pick_manually/pick_manually_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surgery_draft.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_header.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/app_snack_bar.dart';

/// Stage 2 of the two-stage scheduling flow. Given a [SurgeryDraft]
/// from stage 1, lets the coordinator pick a room and a start time,
/// then submits the case.
class PickManuallyScreen extends StatelessWidget {
  const PickManuallyScreen({super.key, required this.draft});

  final SurgeryDraft draft;

  @override
  Widget build(BuildContext context) {
    final container = context.read<AppContainer>();
    return BlocProvider(
      create: (_) => PickManuallyBloc(
        roomService: container.roomService,
        surgeryService: container.surgeryService,
        draft: draft,
      )..add(const PickManuallyRoomsRequested()),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(subtitle: l10n.subtitleOrSchedule),
      body: SafeArea(
        top: false,
        child: BlocConsumer<PickManuallyBloc, PickManuallyState>(
          listenWhen: (p, c) => p.submitStatus != c.submitStatus,
          listener: (context, state) {
            switch (state.submitStatus) {
              case PickManuallySubmitStatus.success:
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(SnackBar(
                    content: Text(l10n.pickManuallyScheduled),
                  ));
                context.goNamed(AppRoutes.coordinatorTimeline);
              case PickManuallySubmitStatus.failure:
                if (state.submitErrorMessage != null) {
                  showErrorSnackBar(
                    context,
                    localizedErrorMessage(
                      l10n,
                      code: state.submitErrorCode,
                      fallback: state.submitErrorMessage!,
                    ),
                  );
                }
              case PickManuallySubmitStatus.idle:
              case PickManuallySubmitStatus.submitting:
                break;
            }
          },
          builder: (context, state) {
            return switch (state.loadStatus) {
              PickManuallyLoadStatus.initial ||
              PickManuallyLoadStatus.loading =>
                const LoadingView(),
              PickManuallyLoadStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback: state.errorMessage ?? l10n.pickManuallyFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<PickManuallyBloc>()
                      .add(const PickManuallyRoomsRequested()),
                ),
              PickManuallyLoadStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final PickManuallyState state;

  static final _startFmt = DateFormat('EEE, MMM d · h:mm a');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward
                    : Icons.arrow_back,
              ),
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.pickManuallyTitle, style: AppTextStyles.headlineMd),
                  Text(
                    l10n.pickManuallySubtitle,
                    style: AppTextStyles.bodySm,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.pickManuallyOperatingRoom, style: AppTextStyles.labelLg),
        const SizedBox(height: AppSpacing.xs),
        ...state.rooms.map((r) {
          final selected = state.roomId == r.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Material(
              color: selected ? AppColors.statusFreeBg : AppColors.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: selected ? AppColors.primary : AppColors.divider,
                ),
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusButton),
              ),
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusButton),
                onTap: () => context
                    .read<PickManuallyBloc>()
                    .add(PickManuallyRoomSelected(r.id)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 18,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name, style: AppTextStyles.labelLg),
                            if (r.supportedSpecialty != null)
                              Text(
                                r.supportedSpecialty!,
                                style: AppTextStyles.bodySm,
                              ),
                          ],
                        ),
                      ),
                      StatusBadge.room(r.status),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (state.submitErrors['room_id'] != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: Text(
              state.submitErrors['room_id']!.first,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.danger),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.pickManuallyScheduledStart, style: AppTextStyles.labelLg),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          onTap: () => _pickStart(context),
          child: InputDecorator(
            decoration:
                InputDecoration(hintText: l10n.pickManuallyPickDateTime),
            child: Row(
              children: [
                const Icon(
                  Icons.event,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    state.scheduledStart == null
                        ? l10n.pickManuallyPickDateTime
                        : _startFmt.format(state.scheduledStart!),
                    style: AppTextStyles.bodyMd,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (state.submitErrors['scheduled_start'] != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: Text(
              state.submitErrors['scheduled_start']!.first,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.danger),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: l10n.pickManuallyConfirm,
          icon: Icons.check,
          isLoading: state.submitStatus == PickManuallySubmitStatus.submitting,
          onPressed: state.isReady
              ? () => context
                  .read<PickManuallyBloc>()
                  .add(const PickManuallySubmitted())
              : null,
        ),
      ],
    );
  }

  Future<void> _pickStart(BuildContext context) async {
    final now = DateTime.now();
    final initial = state.scheduledStart ?? now.add(const Duration(hours: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      // Server rejects any scheduled_start before now — never let the
      // picker offer a date the submit would immediately reject.
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !context.mounted) return;
    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    context
        .read<PickManuallyBloc>()
        .add(PickManuallyStartSelected(picked));
  }
}
