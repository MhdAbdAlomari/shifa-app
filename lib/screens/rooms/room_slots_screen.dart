import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/room_slots/room_slots_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/l10n/message_code.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/room_slot.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_snack_bar.dart';

String _messageText(
  AppLocalizations l10n,
  MessageCode? code,
  String? error, [
  String? errorCode,
]) {
  if (code != null) {
    return switch (code) {
      MessageCode.slotAdded => l10n.messageSlotAdded,
      MessageCode.slotDeleted => l10n.messageSlotDeleted,
      _ => localizedErrorMessage(l10n, code: errorCode, fallback: error ?? ''),
    };
  }
  return localizedErrorMessage(l10n, code: errorCode, fallback: error ?? '');
}

List<String> _dayLabels(AppLocalizations l10n) => [
      l10n.daySunday,
      l10n.dayMonday,
      l10n.dayTuesday,
      l10n.dayWednesday,
      l10n.dayThursday,
      l10n.dayFriday,
      l10n.daySaturday,
    ];

/// Weekly availability slots for one room — reached from Room Detail.
class RoomSlotsScreen extends StatelessWidget {
  const RoomSlotsScreen({super.key, required this.roomId});

  final int roomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomSlotsBloc(
        roomSlotService: context.read<AppContainer>().roomSlotService,
        roomId: roomId,
      )..add(const RoomSlotsRequested()),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.roomSlotsTitle)),
      body: SafeArea(
        child: BlocConsumer<RoomSlotsBloc, RoomSlotsState>(
          listenWhen: (p, c) =>
              (p.actionMessageCode != c.actionMessageCode ||
                  p.actionErrorMessage != c.actionErrorMessage) &&
              (c.actionMessageCode != null || c.actionErrorMessage != null),
          listener: (context, state) {
            final message = _messageText(
              l10n,
              state.actionMessageCode,
              state.actionErrorMessage,
              state.actionErrorCode,
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
              RoomSlotsStatus.initial ||
              RoomSlotsStatus.loading =>
                state.slots.isEmpty ? const LoadingView() : _Body(state: state),
              RoomSlotsStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback: state.errorMessage ?? l10n.roomsListFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<RoomSlotsBloc>()
                      .add(const RoomSlotsRequested()),
                ),
              RoomSlotsStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final RoomSlotsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: Text(
            l10n.roomSlotsSubtitle,
            style: AppTextStyles.bodySm,
          ),
        ),
        Expanded(
          child: state.slots.isEmpty
              ? EmptyView(
                  icon: Icons.event_available_outlined,
                  title: l10n.roomSlotsNoneTitle,
                  subtitle: l10n.roomSlotsNoneSubtitle,
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenEdge,
                  ),
                  itemCount: state.slots.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => _SlotRow(
                    slot: state.slots[i],
                    isDeleting: state.deletingId == state.slots[i].id,
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: PrimaryButton(
            label: l10n.roomSlotsAdd,
            icon: Icons.add,
            isLoading: state.saving,
            onPressed: () => _openAddSheet(context),
          ),
        ),
      ],
    );
  }

  Future<void> _openAddSheet(BuildContext context) async {
    final bloc = context.read<RoomSlotsBloc>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const _AddSlotSheet(),
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({required this.slot, required this.isDeleting});

  final RoomSlot slot;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_dayLabels(l10n)[slot.dayOfWeek], style: AppTextStyles.titleLg),
                Text(
                  '${slot.startTime} – ${slot.endTime}',
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ),
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

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.roomSlotsDeleteTitle),
        content: Text(l10n.roomSlotsDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<RoomSlotsBloc>().add(RoomSlotsDeleteRequested(slot.id));
    }
  }
}

class _AddSlotSheet extends StatefulWidget {
  const _AddSlotSheet();

  @override
  State<_AddSlotSheet> createState() => _AddSlotSheetState();
}

class _AddSlotSheetState extends State<_AddSlotSheet> {
  int _dayOfWeek = 1;
  TimeOfDay _start = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 16, minute: 0);

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<RoomSlotsBloc, RoomSlotsState>(
      listenWhen: (p, c) =>
          p.saving != c.saving && !c.saving && c.actionMessageCode != null,
      listener: (context, state) {
        if (state.formErrors.isEmpty) Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.screenEdge,
          right: AppSpacing.screenEdge,
          top: AppSpacing.xs,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: BlocBuilder<RoomSlotsBloc, RoomSlotsState>(
          builder: (context, state) {
            final endError = state.formErrors['end_time']?.first;
            return SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.roomSlotsAddSheetTitle, style: AppTextStyles.headlineMd),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<int>(
                  initialValue: _dayOfWeek,
                  decoration: InputDecoration(labelText: l10n.roomSlotsDayLabel),
                  items: [
                    for (var i = 0; i < 7; i++)
                      DropdownMenuItem(value: i, child: Text(_dayLabels(l10n)[i])),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _dayOfWeek = v);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _start,
                    );
                    if (picked != null) setState(() => _start = picked);
                  },
                  child: InputDecorator(
                    decoration:
                        InputDecoration(labelText: l10n.roomSlotsStartLabel),
                    child: Text(_fmt(_start)),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _end,
                    );
                    if (picked != null) setState(() => _end = picked);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.roomSlotsEndLabel,
                      errorText: endError,
                    ),
                    child: Text(_fmt(_end)),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: l10n.roomSlotsAdd,
                  isLoading: state.saving,
                  onPressed: () =>
                      context.read<RoomSlotsBloc>().add(RoomSlotsCreateRequested(
                            dayOfWeek: _dayOfWeek,
                            startTime: _fmt(_start),
                            endTime: _fmt(_end),
                          )),
                ),
              ],
              ),
            );
          },
        ),
      ),
    );
  }
}
