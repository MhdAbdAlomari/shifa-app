/// Localizable result codes emitted by Blocs in place of hardcoded
/// English strings.
///
/// Blocs are UI-agnostic and hold no [BuildContext], so they cannot call
/// `AppLocalizations.of(context)`. Instead a Bloc emits one of these codes
/// on its state, and the screen widget (which does have a context) maps
/// the code to translated text right before showing it in a SnackBar.
enum MessageCode {
  roomDeleted,
  roomAdded,
  roomUpdated,
  staffDeleted,
  staffAdded,
  staffUpdated,
  surgeryStarted,
  surgeryCancelled,
  patientDeleted,
  patientAdded,
  patientUpdated,
  surgeryTypeDeleted,
  surgeryTypeAdded,
  surgeryTypeUpdated,
  slotAdded,
  slotUpdated,
  slotDeleted,
}
