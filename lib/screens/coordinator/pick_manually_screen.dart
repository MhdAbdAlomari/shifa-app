import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/pick_manually/pick_manually_bloc.dart';
import '../../core/di.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surgery_draft.dart';
import '../../widgets/app_header.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

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
    return Scaffold(
      appBar: const AppHeader(subtitle: 'Or Schedule'),
      body: SafeArea(
        top: false,
        child: BlocConsumer<PickManuallyBloc, PickManuallyState>(
          listenWhen: (p, c) => p.submitStatus != c.submitStatus,
          listener: (context, state) {
            switch (state.submitStatus) {
              case PickManuallySubmitStatus.success:
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(const SnackBar(
                    content: Text('Surgery scheduled'),
                  ));
                context.goNamed(AppRoutes.coordinatorTimeline);
              case PickManuallySubmitStatus.failure:
                if (state.submitErrorMessage != null) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(content: Text(state.submitErrorMessage!)),
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
                  message: state.errorMessage ?? 'Failed to load rooms',
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
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pick manually', style: AppTextStyles.headlineMd),
                  Text(
                    'Choose the room and start time',
                    style: AppTextStyles.bodySm,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Operating Room', style: AppTextStyles.labelLg),
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
        Text('Scheduled start', style: AppTextStyles.labelLg),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          onTap: () => _pickStart(context),
          child: InputDecorator(
            decoration:
                const InputDecoration(hintText: 'Pick a date and time'),
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
                        ? 'Pick a date and time'
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
          label: 'Confirm scheduling',
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
      firstDate: now.subtract(const Duration(days: 1)),
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
