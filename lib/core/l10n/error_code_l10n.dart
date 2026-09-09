import '../../l10n/generated/app_localizations.dart';

/// Maps a backend `error_code` to a localized string. Every code in
/// docs/API_REFERENCE.md's error-codes table has an entry here. Falls
/// back to [fallback] (the raw English `message` a Bloc captured from
/// the exception) only when [code] is null (a pre-error_code response,
/// or a network failure) or unrecognized — per the doc: "the client...
/// should switch on error_code... and treat message as an English
/// fallback / debug aid only."
///
/// Blocs are UI-agnostic and can't call this directly (no
/// BuildContext for AppLocalizations.of); they instead store
/// `errorCode`/`errorMessage` (or `actionErrorCode`/`actionErrorMessage`,
/// etc.) pairs on state, and the consuming screen calls this at
/// display time.
String localizedErrorMessage(
  AppLocalizations l10n, {
  required String? code,
  required String fallback,
}) {
  return switch (code) {
    'unauthenticated' => l10n.errorUnauthenticated,
    'role_forbidden' => l10n.errorRoleForbidden,
    'unauthorized' => l10n.errorUnauthorized,
    'not_found' => l10n.errorNotFound,
    'method_not_allowed' => l10n.errorMethodNotAllowed,
    'validation_failed' => l10n.errorValidationFailed,
    'invalid_credentials' => l10n.errorInvalidCredentials,
    'surgery_not_owned' => l10n.errorSurgeryNotOwned,
    'surgery_time_conflict' => l10n.errorSurgeryTimeConflict,
    'room_availability_window_violation' =>
      l10n.errorRoomAvailabilityWindowViolation,
    'surgery_not_in_progress' => l10n.errorSurgeryNotInProgress,
    'suggestion_not_pending' => l10n.errorSuggestionNotPending,
    'notification_not_owned' => l10n.errorNotificationNotOwned,
    'slot_room_mismatch' => l10n.errorSlotRoomMismatch,
    'slot_invalid_time_range' => l10n.errorSlotInvalidTimeRange,
    _ => fallback,
  };
}
