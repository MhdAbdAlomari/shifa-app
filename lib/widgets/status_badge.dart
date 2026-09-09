import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/room_status.dart';
import '../data/models/schedule_suggestion_status.dart';
import '../data/models/surgery_priority.dart';
import '../data/models/surgery_status.dart';
import '../l10n/generated/app_localizations.dart';

/// Small colored pill used to communicate an entity's state at a
/// glance. Named constructors map every enum in the app to a fixed
/// (background, foreground, border) triple per DESIGN.md's clinical
/// status palette — screens never pass raw hex. The label itself is
/// resolved from the enum in [build] (not the constructor) so it can
/// read the active locale from [BuildContext].
class StatusBadge extends StatelessWidget {
  const StatusBadge._room(this._roomStatus)
      : _surgeryStatus = null,
        _priority = null,
        _suggestionStatus = null;

  const StatusBadge._surgery(this._surgeryStatus)
      : _roomStatus = null,
        _priority = null,
        _suggestionStatus = null;

  const StatusBadge._priority(this._priority)
      : _roomStatus = null,
        _surgeryStatus = null,
        _suggestionStatus = null;

  const StatusBadge._suggestion(this._suggestionStatus)
      : _roomStatus = null,
        _surgeryStatus = null,
        _priority = null;

  final RoomStatus? _roomStatus;
  final SurgeryStatus? _surgeryStatus;
  final SurgeryPriority? _priority;
  final ScheduleSuggestionStatus? _suggestionStatus;

  // `_roomStatus` is nullable independent of which factory built this
  // instance (a room can have an unset status) — a separate flag says
  // whether this badge is a room badge at all.
  const factory StatusBadge.room(RoomStatus? status) = StatusBadge._room;
  const factory StatusBadge.surgery(SurgeryStatus status) =
      StatusBadge._surgery;
  const factory StatusBadge.priority(SurgeryPriority priority) =
      StatusBadge._priority;
  const factory StatusBadge.suggestion(ScheduleSuggestionStatus status) =
      StatusBadge._suggestion;

  static const _free = _Palette(
    AppColors.statusFreeBg,
    AppColors.statusFreeText,
    AppColors.statusFreeBorder,
  );
  static const _inUse = _Palette(
    AppColors.statusInUseBg,
    AppColors.statusInUseText,
    AppColors.statusInUseBorder,
  );
  static const _preparing = _Palette(
    AppColors.statusPreparingBg,
    AppColors.statusPreparingText,
    AppColors.statusPreparingBorder,
  );
  static const _cleaning = _Palette(
    AppColors.statusCleaningBg,
    AppColors.statusCleaningText,
    AppColors.statusCleaningBorder,
  );
  static const _neutral = _Palette(
    AppColors.softHover,
    AppColors.textSecondary,
    AppColors.divider,
  );
  // Solid danger fill — deliberately louder than every other badge
  // (which use a soft tint + matching text). Emergency priority and
  // delayed status are the two states where a hospital app should
  // never let a glance miss them (item 6: increase red's visual
  // weight specifically for emergency/delayed/error states).
  static const _danger = _Palette(
    AppColors.danger,
    AppColors.textOnPrimary,
    AppColors.danger,
  );

  (String, _Palette) _resolve(AppLocalizations l10n) {
    if (_surgeryStatus != null) {
      return switch (_surgeryStatus) {
        // Scheduled surgeries render like "Free" — awaiting, positive.
        SurgeryStatus.scheduled => (l10n.roomsListStatusFree, _free),
        SurgeryStatus.inProgress => (l10n.mySurgeriesInProgress, _inUse),
        SurgeryStatus.completed => (l10n.statusCompleted, _cleaning),
        SurgeryStatus.cancelled => (l10n.statusCancelled, _cleaning),
        SurgeryStatus.delayed => (l10n.mySurgeriesDelayed, _danger),
      };
    }
    if (_priority != null) {
      return switch (_priority) {
        SurgeryPriority.normal => (
            l10n.scheduleSurgeryPriorityNormal,
            _neutral,
          ),
        SurgeryPriority.emergency => (
            l10n.scheduleSurgeryPriorityEmergency,
            _danger,
          ),
      };
    }
    if (_suggestionStatus != null) {
      return switch (_suggestionStatus) {
        ScheduleSuggestionStatus.pending => (l10n.statusPending, _preparing),
        ScheduleSuggestionStatus.accepted => (l10n.statusAccepted, _free),
        ScheduleSuggestionStatus.rejected => (
            l10n.statusRejected,
            _cleaning,
          ),
      };
    }
    return switch (_roomStatus) {
      RoomStatus.free => (l10n.roomsListStatusFree, _free),
      RoomStatus.preparing => (l10n.roomsListStatusPreparing, _preparing),
      RoomStatus.inUse => (l10n.roomsListStatusInUse, _inUse),
      RoomStatus.cleaning => (l10n.roomsListStatusCleaning, _cleaning),
      null => (l10n.commonUnknown, _neutral),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (label, palette) = _resolve(AppLocalizations.of(context));
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: palette.bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: palette.border),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: palette.fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Palette {
  const _Palette(this.bg, this.fg, this.border);
  final Color bg;
  final Color fg;
  final Color border;
}
