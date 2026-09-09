import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/surgery_detail/surgery_detail_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/message_code.dart';
import '../../data/models/delay_response.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surgery.dart';
import '../../data/models/surgery_status.dart';
import '../../data/models/user_role.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/app_snack_bar.dart';

String _messageText(AppLocalizations l10n, MessageCode? code, String? error) {
  if (code != null) {
    return switch (code) {
      MessageCode.surgeryCancelled => l10n.messageSurgeryCancelled,
      _ => error ?? '',
    };
  }
  return error ?? '';
}

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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(subtitle: l10n.subtitleMySurgeries),
      body: SafeArea(
        top: false,
        child: BlocConsumer<SurgeryDetailBloc, SurgeryDetailState>(
          listenWhen: (p, c) =>
              (p.actionMessageCode != c.actionMessageCode ||
                  p.actionErrorMessage != c.actionErrorMessage) &&
              (c.actionMessageCode != null || c.actionErrorMessage != null),
          listener: (context, state) {
            final message = _messageText(
              l10n,
              state.actionMessageCode,
              state.actionErrorMessage,
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
              SurgeryDetailStatus.initial ||
              SurgeryDetailStatus.loading =>
                const LoadingView(),
              SurgeryDetailStatus.error => ErrorView(
                  message: state.errorMessage ?? l10n.surgeryDetailFailedToLoad,
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
    final l10n = AppLocalizations.of(context);
    final surgery = state.surgery!;
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

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
              onPressed: () => context.canPop() ? context.pop() : null,
            ),
            const Spacer(),
            Text(l10n.surgeryDetailTitle, style: AppTextStyles.titleLg),
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
                              l10n.surgeryDetailPatientNumber(
                                  surgery.patientId),
                          style: AppTextStyles.headlineSm,
                        ),
                        if (surgery.patient != null)
                          Text(
                            l10n.surgeryDetailMrn(surgery.patient!.mrn),
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
                    Text(l10n.surgeryDetailProcedure, style: AppTextStyles.labelSm),
                    Text(
                      surgery.surgeryType?.name ?? l10n.surgeryDetailSurgeryFallback,
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
                      label: l10n.surgeryDetailAssignedSuite,
                      value: surgery.room?.name ??
                          l10n.surgeryDetailRoomNumber(surgery.roomId),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MiniStat(
                      icon: Icons.timelapse,
                      label: l10n.surgeryDetailTargetPace,
                      value: l10n.surgeryDetailMinutesShort(
                          surgery.estimatedDurationMin),
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
                  Text(l10n.surgeryDetailScheduledSlot, style: AppTextStyles.labelLg),
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
                  Text(l10n.surgeryDetailActualTime, style: AppTextStyles.labelLg),
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
                        l10n.surgeryDetailEstimatedDuration(
                            surgery.estimatedDurationMin),
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
        if (state.delayResponse != null) ...[
          const SizedBox(height: AppSpacing.md),
          _DelayResultBanner(response: state.delayResponse!),
        ],
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
    final l10n = AppLocalizations.of(context);
    if (surgery.actualStart == null) {
      return Text(l10n.commonNotAvailable, style: AppTextStyles.bodyMd);
    }
    final start = surgery.actualStart!.toLocal();
    final label = surgery.actualEnd == null
        ? l10n.surgeryDetailInProgressStarted(timeFmt.format(start))
        : l10n.surgeryDetailEnded(timeFmt.format(surgery.actualEnd!.toLocal()));
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

class _DelayResultBanner extends StatelessWidget {
  const _DelayResultBanner({required this.response});

  final DelayResponse response;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Built entirely from the response's structured fields, never the
    // raw backend `message` — that's an untranslated English sentence
    // and can't be localized by parsing it client-side.
    final String body;
    if (response.autoApproved) {
      final newEnd = response.surgery?.scheduledEnd?.toLocal();
      final locale = Localizations.localeOf(context).toString();
      body = l10n.delayResultAutoApprovedBody(
        newEnd == null
            ? ''
            : DateFormat('EEE, MMM d · h:mm a', locale).format(newEnd),
      );
    } else {
      body = l10n.delayResultPendingBody(
        response.conflictWithSurgeryId ?? 0,
        response.suggestions.length,
      );
    }
    // Auto-approved reads as a confirmation (primary/green), pending
    // review reads as a warning the surgeon should notice (amber) —
    // neither is an error, so neither uses the danger treatment.
    final (bg, border, fg, icon) = response.autoApproved
        ? (
            AppColors.statusFreeBg,
            AppColors.statusFreeBorder,
            AppColors.primary,
            Icons.check_circle_outline,
          )
        : (
            AppColors.statusPreparingBg,
            AppColors.statusPreparingBorder,
            AppColors.accentText,
            Icons.hourglass_top_outlined,
          );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.autoApproved
                      ? l10n.delayResultAutoApprovedTitle
                      : l10n.delayResultPendingTitle,
                  style: AppTextStyles.labelLg.copyWith(color: fg),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(body, style: AppTextStyles.bodySm),
              ],
            ),
          ),
        ],
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
    final l10n = AppLocalizations.of(context);
    final isBusy = state.actionStatus == SurgeryActionStatus.running;

    if (role == UserRole.surgeon) {
      return switch (surgery.status) {
        SurgeryStatus.scheduled => PrimaryButton(
            label: l10n.surgeryDetailStartSurgery,
            icon: Icons.play_arrow,
            isLoading: isBusy,
            onPressed: () => context
                .read<SurgeryDetailBloc>()
                .add(const SurgeryDetailStartRequested()),
          ),
        // Report Delay only applies to an in-progress surgery — the
        // backend rejects it otherwise with surgery_not_in_progress
        // (see the delay endpoint's precondition #2 in the API doc),
        // so it's not offered on a merely-scheduled case.
        SurgeryStatus.inProgress => Column(
            children: [
              PrimaryButton(
                label: l10n.surgeryDetailMarkComplete,
                icon: Icons.check,
                isLoading: isBusy,
                onPressed: () => context
                    .read<SurgeryDetailBloc>()
                    .add(const SurgeryDetailCompleteRequested()),
              ),
              const SizedBox(height: AppSpacing.sm),
              _TextAction(
                label: l10n.surgeryDetailReportDelay,
                icon: Icons.warning_amber_outlined,
                color: AppColors.accentText,
                onPressed: isBusy
                    ? null
                    : () => _openDelaySheet(context),
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
        label: l10n.surgeryDetailCancelSurgery,
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

  Future<void> _openDelaySheet(BuildContext context) async {
    final bloc = context.read<SurgeryDetailBloc>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const _DelayFormSheet(),
      ),
    );
  }
}

class _DelayFormSheet extends StatefulWidget {
  const _DelayFormSheet();

  @override
  State<_DelayFormSheet> createState() => _DelayFormSheetState();
}

class _DelayFormSheetState extends State<_DelayFormSheet> {
  final _reasonController = TextEditingController();
  DateTime? _newExpectedEnd;

  static final _fmt = DateFormat('EEE, MMM d · h:mm a');

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickNewEnd(BuildContext context) async {
    final now = DateTime.now();
    final initial = _newExpectedEnd ?? now.add(const Duration(hours: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      // Server requires new_expected_end strictly after now.
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    setState(() {
      _newExpectedEnd =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<SurgeryDetailBloc, SurgeryDetailState>(
      listenWhen: (p, c) =>
          p.delayResponse != c.delayResponse && c.delayResponse != null,
      listener: (context, state) {
        // The delay result banner (auto-approved vs pending) is shown
        // on the detail screen itself once this sheet closes — a
        // one-shot SnackBar would undersell which of the two outcomes
        // happened.
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.screenEdge,
          right: AppSpacing.screenEdge,
          top: AppSpacing.xs,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<SurgeryDetailBloc, SurgeryDetailState>(
            builder: (context, state) {
              final endError = state.delayFormErrors['new_expected_end']?.first;
              final reasonError = state.delayFormErrors['reason']?.first;
              final isBusy = state.actionStatus == SurgeryActionStatus.running;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.delayFormTitle, style: AppTextStyles.headlineMd),
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: () => _pickNewEnd(context),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.delayFormNewEndLabel,
                        errorText: endError,
                      ),
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
                              _newExpectedEnd == null
                                  ? l10n.delayFormNewEndHint
                                  : _fmt.format(_newExpectedEnd!),
                              style: AppTextStyles.bodyMd,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.delayFormReasonLabel,
                      hintText: l10n.delayFormReasonHint,
                      errorText: reasonError,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: l10n.delayFormSubmit,
                    icon: Icons.warning_amber_outlined,
                    variant: PrimaryButtonVariant.danger,
                    isLoading: isBusy,
                    onPressed: _newExpectedEnd == null
                        ? null
                        : () => context.read<SurgeryDetailBloc>().add(
                              SurgeryDetailDelayRequested(
                                newExpectedEnd: _newExpectedEnd!,
                                reason: _reasonController.text.trim(),
                              ),
                            ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
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
