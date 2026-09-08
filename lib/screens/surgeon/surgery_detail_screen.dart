import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/surgery_detail/surgery_detail_bloc.dart';
import '../../core/di.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surgery.dart';
import '../../data/models/surgery_status.dart';
import '../../data/models/user_role.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

/// Detail view for a single surgery. Role-aware action bar:
///   - Surgeon: Start / Complete / Report delay.
///   - Coordinator: Cancel (soft delete via `DELETE /surgeries/{id}`).
///
/// The Bloc is intentionally role-blind; the UI decides which action
/// set to render based on the current [UserRole].
class SurgeryDetailScreen extends StatelessWidget {
  const SurgeryDetailScreen({super.key, required this.surgeryId});

  final int surgeryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurgeryDetailBloc(
        surgeryService: context.read<AppContainer>().surgeryService,
        surgeryId: surgeryId,
      )..add(const SurgeryDetailRequested()),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(subtitle: 'My Surgeries'),
      body: SafeArea(
        top: false,
        child: BlocConsumer<SurgeryDetailBloc, SurgeryDetailState>(
          listenWhen: (p, c) =>
              p.actionMessage != c.actionMessage && c.actionMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          },
          builder: (context, state) {
            return switch (state.status) {
              SurgeryDetailStatus.initial ||
              SurgeryDetailStatus.loading =>
                const LoadingView(),
              SurgeryDetailStatus.error => ErrorView(
                  message: state.errorMessage ?? 'Failed to load surgery',
                  onRetry: () => context
                      .read<SurgeryDetailBloc>()
                      .add(const SurgeryDetailRequested()),
                ),
              SurgeryDetailStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final SurgeryDetailState state;

  static final _timeFmt = DateFormat('h:mm a');
  static final _dateFmt = DateFormat('MMM d');

  @override
  Widget build(BuildContext context) {
    final surgery = state.surgery!;
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenEdge),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.canPop() ? context.pop() : null,
            ),
            const Spacer(),
            Text('Surgery Details', style: AppTextStyles.titleLg),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.softHover,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surgery.patient?.name ??
                              'Patient #${surgery.patientId}',
                          style: AppTextStyles.headlineSm,
                        ),
                        if (surgery.patient != null)
                          Text(
                            'MRN ${surgery.patient!.mrn}',
                            style: AppTextStyles.bodySm,
                          ),
                      ],
                    ),
                  ),
                  StatusBadge.surgery(surgery.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PROCEDURE', style: AppTextStyles.labelSm),
                    Text(
                      surgery.surgeryType?.name ?? 'Surgery',
                      style: AppTextStyles.titleLg,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      icon: Icons.meeting_room_outlined,
                      label: 'Assigned Suite',
                      value: surgery.room?.name ?? 'Room #${surgery.roomId}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MiniStat(
                      icon: Icons.timelapse,
                      label: 'Target Pace',
                      value: '${surgery.estimatedDurationMin} min',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text('Scheduled Slot', style: AppTextStyles.labelLg),
                  const Spacer(),
                  Text(
                    _slotLabel(surgery, _timeFmt, _dateFmt),
                    style: AppTextStyles.bodyMd,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text('Actual Time', style: AppTextStyles.labelLg),
                  const Spacer(),
                  _ActualTimePill(surgery: surgery, timeFmt: _timeFmt),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        'Estimated duration ${surgery.estimatedDurationMin} mins',
                        style: AppTextStyles.bodySm,
                      ),
                    ),
                    StatusBadge.priority(surgery.priority),
                  ],
                ),
              ),
              if (surgery.surgeon != null) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        surgery.surgeon!.specialty == null
                            ? surgery.surgeon!.name
                            : '${surgery.surgeon!.name} · ${surgery.surgeon!.specialty}',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _Actions(surgery: surgery, role: user.role, state: state),
      ],
    );
  }

  String _slotLabel(Surgery s, DateFormat time, DateFormat date) {
    final start = s.scheduledStart.toLocal();
    final end = start.add(Duration(minutes: s.estimatedDurationMin));
    return '${date.format(start)} · ${time.format(start)} – ${time.format(end)}';
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelSm),
                Text(value, style: AppTextStyles.titleLg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActualTimePill extends StatelessWidget {
  const _ActualTimePill({required this.surgery, required this.timeFmt});

  final Surgery surgery;
  final DateFormat timeFmt;

  @override
  Widget build(BuildContext context) {
    if (surgery.actualStart == null) {
      return Text('—', style: AppTextStyles.bodyMd);
    }
    final start = surgery.actualStart!.toLocal();
    final label = surgery.actualEnd == null
        ? 'In Progress (Started ${timeFmt.format(start)})'
        : 'Ended ${timeFmt.format(surgery.actualEnd!.toLocal())}';
    final isRunning = surgery.actualEnd == null;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color:
            isRunning ? AppColors.statusFreeBg : AppColors.softHover,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(
          color: isRunning
              ? AppColors.statusFreeBorder
              : AppColors.divider,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: isRunning ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.surgery,
    required this.role,
    required this.state,
  });

  final Surgery surgery;
  final UserRole role;
  final SurgeryDetailState state;

  @override
  Widget build(BuildContext context) {
    final isBusy = state.actionStatus == SurgeryActionStatus.running;

    if (role == UserRole.surgeon) {
      return switch (surgery.status) {
        SurgeryStatus.scheduled => Column(
            children: [
              PrimaryButton(
                label: 'Start Surgery',
                icon: Icons.play_arrow,
                isLoading: isBusy,
                onPressed: () => context
                    .read<SurgeryDetailBloc>()
                    .add(const SurgeryDetailStartRequested()),
              ),
              const SizedBox(height: AppSpacing.sm),
              _TextAction(
                label: 'Report Delay',
                icon: Icons.warning_amber_outlined,
                color: AppColors.accentText,
                onPressed: isBusy
                    ? null
                    : () => context
                        .read<SurgeryDetailBloc>()
                        .add(const SurgeryDetailDelayRequested()),
              ),
            ],
          ),
        SurgeryStatus.inProgress => Column(
            children: [
              PrimaryButton(
                label: 'Mark Complete',
                icon: Icons.check,
                isLoading: isBusy,
                onPressed: () => context
                    .read<SurgeryDetailBloc>()
                    .add(const SurgeryDetailCompleteRequested()),
              ),
              const SizedBox(height: AppSpacing.sm),
              _TextAction(
                label: 'Report Delay',
                icon: Icons.warning_amber_outlined,
                color: AppColors.accentText,
                onPressed: isBusy
                    ? null
                    : () => context
                        .read<SurgeryDetailBloc>()
                        .add(const SurgeryDetailDelayRequested()),
              ),
            ],
          ),
        SurgeryStatus.completed ||
        SurgeryStatus.cancelled ||
        SurgeryStatus.delayed =>
          const SizedBox.shrink(),
      };
    }

    if (role == UserRole.coordinator &&
        surgery.status != SurgeryStatus.cancelled &&
        surgery.status != SurgeryStatus.completed) {
      return PrimaryButton(
        label: 'Cancel surgery',
        icon: Icons.cancel_outlined,
        variant: PrimaryButtonVariant.danger,
        isLoading: isBusy,
        onPressed: () => context
            .read<SurgeryDetailBloc>()
            .add(const SurgeryDetailCancelRequested()),
      );
    }
    return const SizedBox.shrink();
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: AppTextStyles.button.copyWith(color: color),
      ),
      onPressed: onPressed,
    );
  }
}
