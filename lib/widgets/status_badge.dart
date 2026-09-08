import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/room_status.dart';
import '../data/models/schedule_suggestion_status.dart';
import '../data/models/surgery_priority.dart';
import '../data/models/surgery_status.dart';

/// Small colored pill used to communicate an entity's state at a
/// glance. Named constructors map every enum in the app to a fixed
/// (label, background, foreground, border) triple per DESIGN.md's
/// clinical status palette — screens never pass raw hex.
class StatusBadge extends StatelessWidget {
  const StatusBadge._({
    required this.label,
    required this.background,
    required this.foreground,
    required this.borderColor,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color borderColor;

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

  factory StatusBadge.room(RoomStatus? status) {
    if (status == null) {
      return const StatusBadge._(
        label: 'Unknown',
        background: AppColors.softHover,
        foreground: AppColors.textSecondary,
        borderColor: AppColors.divider,
      );
    }
    return switch (status) {
      RoomStatus.free => _from('Free', _free),
      RoomStatus.preparing => _from('Preparing', _preparing),
      RoomStatus.inUse => _from('In use', _inUse),
      RoomStatus.cleaning => _from('Cleaning', _cleaning),
    };
  }

  factory StatusBadge.surgery(SurgeryStatus status) {
    return switch (status) {
      // Scheduled surgeries render like "Free" — awaiting, positive.
      SurgeryStatus.scheduled => _from('Scheduled', _free),
      SurgeryStatus.inProgress => _from('In progress', _inUse),
      SurgeryStatus.completed => _from('Completed', _cleaning),
      SurgeryStatus.cancelled => _from('Cancelled', _cleaning),
      SurgeryStatus.delayed => _from('Delayed', _preparing),
    };
  }

  factory StatusBadge.priority(SurgeryPriority priority) {
    return switch (priority) {
      SurgeryPriority.normal => const StatusBadge._(
          label: 'Normal',
          background: AppColors.softHover,
          foreground: AppColors.textSecondary,
          borderColor: AppColors.divider,
        ),
      SurgeryPriority.emergency => const StatusBadge._(
          label: 'Emergency',
          background: Color(0xFFFFDAD6),
          foreground: AppColors.danger,
          borderColor: Color(0xFFFFB4AB),
        ),
    };
  }

  factory StatusBadge.suggestion(ScheduleSuggestionStatus status) {
    return switch (status) {
      ScheduleSuggestionStatus.pending => _from('Pending', _preparing),
      ScheduleSuggestionStatus.accepted => _from('Accepted', _free),
      ScheduleSuggestionStatus.rejected => _from('Rejected', _cleaning),
    };
  }

  static StatusBadge _from(String label, _Palette p) => StatusBadge._(
        label: label,
        background: p.bg,
        foreground: p.fg,
        borderColor: p.border,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: foreground,
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
