// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shifa';

  @override
  String get errorUnauthenticated =>
      'Your session has expired. Please log in again.';

  @override
  String get errorRoleForbidden => 'You don\'t have permission to do that.';

  @override
  String get errorUnauthorized => 'You\'re not authorized to do that.';

  @override
  String get errorNotFound =>
      'That item couldn\'t be found. It may have been removed.';

  @override
  String get errorMethodNotAllowed => 'That action isn\'t supported right now.';

  @override
  String get errorValidationFailed =>
      'Please check the highlighted fields and try again.';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorSurgeryNotOwned =>
      'You can only do that for your own surgeries.';

  @override
  String get errorSurgeryTimeConflict =>
      'This room is already booked at that time.';

  @override
  String get errorRoomAvailabilityWindowViolation =>
      'That time falls outside this room\'s available hours.';

  @override
  String get errorSurgeryNotInProgress =>
      'This action requires the surgery to be in progress.';

  @override
  String get errorSuggestionNotPending =>
      'This suggestion has already been actioned.';

  @override
  String get errorNotificationNotOwned =>
      'You can only manage your own notifications.';

  @override
  String get errorSlotRoomMismatch =>
      'That availability slot doesn\'t belong to this room.';

  @override
  String get errorSlotInvalidTimeRange =>
      'The end time must be after the start time.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get appTagline => 'OR';

  @override
  String get navRooms => 'Rooms';

  @override
  String get navStaff => 'Staff';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navSuggestions => 'Suggestions';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navSurgeries => 'Surgeries';

  @override
  String get navManage => 'Manage';

  @override
  String get navSettings => 'Settings';

  @override
  String get manageTitle => 'Manage';

  @override
  String get manageSubtitle => 'Rooms, staff, patients, and surgery types';

  @override
  String get manageRoomsSubtitle => 'View, add, and configure operating rooms';

  @override
  String get manageStaffSubtitle =>
      'View, add, and edit coordinators and surgeons';

  @override
  String get managePatientsSubtitle => 'Search, add, and edit patient records';

  @override
  String get manageSurgeryTypesSubtitle =>
      'Configure procedures, durations, and default rooms';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get commonNotAvailable => '—';

  @override
  String get subtitleOrSchedule => 'Or Schedule';

  @override
  String get subtitleMySurgeries => 'My Surgeries';

  @override
  String get subtitleClinicalAlerts => 'Clinical Alerts';

  @override
  String get subtitleDelaySuggestions => 'Delay Suggestions';

  @override
  String get subtitleSettings => 'Settings';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get logOut => 'Log out';

  @override
  String get loginTitle => 'Shifa';

  @override
  String get loginSubtitle =>
      'Sign in to manage today\'s operating room schedule.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'you@shifa.test';

  @override
  String get loginEmailRequired => 'Email is required';

  @override
  String get loginEmailInvalid => 'Enter a valid email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginButton => 'Log in';

  @override
  String get roomTimelineTitle => 'Room Timeline';

  @override
  String roomTimelineSuitesMonitored(int count) {
    return '$count Suites Monitored';
  }

  @override
  String get roomTimelineNoRooms => 'No operating rooms';

  @override
  String get roomTimelineNoRoomsSubtitle => 'Ask an admin to add rooms.';

  @override
  String get roomTimelineFailedToLoad => 'Failed to load timeline';

  @override
  String get roomTimelineScheduleSurgery => 'Schedule surgery';

  @override
  String roomTimelineOr(int id) {
    return 'OR $id';
  }

  @override
  String roomTimelinePatientNumber(int id) {
    return 'Patient #$id';
  }

  @override
  String get roomTimelineSurgeryFallback => 'Surgery';

  @override
  String get roomTimelineEnds => 'ENDS';

  @override
  String get roomTimelineNext => 'NEXT';

  @override
  String get roomTimelineStatus => 'STATUS';

  @override
  String get roomTimelineVacantReady => 'Vacant & Ready';

  @override
  String get roomTimelineVacantReadySubtitle => 'Ready for immediate intake';

  @override
  String get roomTimelinePreparing => 'Preparing';

  @override
  String get roomTimelinePreparingSubtitle => 'Room is being set up';

  @override
  String get roomTimelineTurnover => 'Turnover in progress';

  @override
  String get roomTimelineTurnoverSubtitle => 'Environmental services';

  @override
  String get roomTimelineInUse => 'In use';

  @override
  String get roomTimelineInUseSubtitle => 'No case assigned in the schedule';

  @override
  String get roomTimelineUnknownStatusSubtitle => 'Room status not set';

  @override
  String get roomTimelineAvailable => 'Available';

  @override
  String get roomTimelineCleaning => 'Cleaning';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get scheduleSurgeryTitle => 'New Surgery';

  @override
  String get scheduleSurgerySubtitle => 'Case Scheduling & OR Assignment';

  @override
  String get scheduleSurgeryFailedToLoad => 'Failed to load form';

  @override
  String get scheduleSurgeryMissingSetupTitle => 'Missing setup data';

  @override
  String get scheduleSurgeryMissingSetupSubtitle =>
      'Ask an admin to add patients, surgeons, and surgery types before scheduling.';

  @override
  String get scheduleSurgeryPatientLabel => 'Patient';

  @override
  String get scheduleSurgeryPatientHint => 'Select a patient';

  @override
  String get scheduleSurgerySurgeonLabel => 'Surgeon';

  @override
  String get scheduleSurgerySurgeonHint => 'Select a surgeon';

  @override
  String get scheduleSurgeryTypeLabel => 'Surgery Type';

  @override
  String get scheduleSurgeryTypeHint => 'Select a type';

  @override
  String scheduleSurgeryTypeDuration(String name, int minutes) {
    return '$name (${minutes}m)';
  }

  @override
  String get scheduleSurgeryPriorityLabel => 'Priority Level';

  @override
  String get scheduleSurgeryPriorityNormal => 'Normal';

  @override
  String get scheduleSurgeryPriorityEmergency => 'Emergency';

  @override
  String get scheduleSurgeryAutoSchedule => 'Auto-schedule';

  @override
  String get scheduleSurgeryPickManually => 'Pick manually';

  @override
  String get pickManuallyTitle => 'Pick manually';

  @override
  String get pickManuallySubtitle => 'Choose the room and start time';

  @override
  String get pickManuallyFailedToLoad => 'Failed to load rooms';

  @override
  String get pickManuallyOperatingRoom => 'Operating Room';

  @override
  String get pickManuallyScheduledStart => 'Scheduled start';

  @override
  String get pickManuallyPickDateTime => 'Pick a date and time';

  @override
  String get pickManuallyConfirm => 'Confirm scheduling';

  @override
  String get pickManuallyScheduled => 'Surgery scheduled';

  @override
  String get autoScheduleTitle => 'Auto-Schedule Suggestions';

  @override
  String get autoScheduleSubtitle =>
      'Optimal room slots based on surgeon availability';

  @override
  String get autoScheduleFailedToLoad => 'Failed to load options';

  @override
  String get autoScheduleNoPendingTitle => 'No pending requests';

  @override
  String get autoScheduleNoPendingSubtitle =>
      'Add one or more surgeries to auto-schedule as a batch.';

  @override
  String get autoScheduleAddRequest => 'Add request';

  @override
  String get autoScheduleAddRequestFirst => 'Add a request first';

  @override
  String autoScheduleGenerateProposals(int count) {
    return 'Generate proposals ($count)';
  }

  @override
  String get autoScheduleAddSheetTitle => 'Add pending request';

  @override
  String get autoScheduleAddToBatch => 'Add to batch';

  @override
  String get autoScheduleAllActionedTitle => 'All proposals actioned';

  @override
  String autoScheduleAllActionedSubtitle(int accepted, int skipped) {
    return '$accepted scheduled, $skipped skipped.';
  }

  @override
  String get autoScheduleStartNewBatch => 'Start a new batch';

  @override
  String get autoScheduleAccept => 'Accept';

  @override
  String get autoScheduleReject => 'Reject';

  @override
  String get autoScheduleToday => 'Today';

  @override
  String get autoScheduleTomorrow => 'Tomorrow';

  @override
  String get delaySuggestionsTitle => 'Delay Resolution';

  @override
  String get delaySuggestionsNonePending => 'No pending adjustments';

  @override
  String delaySuggestionsPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending adjustments',
      one: '1 pending adjustment',
    );
    return '$_temp0';
  }

  @override
  String get delaySuggestionsActiveOverrun => 'ACTIVE OVERRUN';

  @override
  String get delaySuggestionsFailedToLoad => 'Failed to load suggestions';

  @override
  String get delaySuggestionsNoneTitle => 'No pending suggestions';

  @override
  String get delaySuggestionsNoneSubtitle => 'You\'re all caught up.';

  @override
  String delaySuggestionsSurgeryNumber(int id) {
    return 'Surgery #$id';
  }

  @override
  String delaySuggestionsRoomNumber(int id) {
    return 'Room #$id';
  }

  @override
  String get roomsListTitle => 'Operating Rooms';

  @override
  String roomsListSuitesConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Operating Suites Configured',
      one: '1 Operating Suite Configured',
    );
    return '$_temp0';
  }

  @override
  String roomsListFilterAll(int count) {
    return 'All Suites ($count)';
  }

  @override
  String roomsListFilterInUse(int count) {
    return 'In use ($count)';
  }

  @override
  String roomsListFilterFree(int count) {
    return 'Free ($count)';
  }

  @override
  String roomsListFilterPreparing(int count) {
    return 'Preparing ($count)';
  }

  @override
  String roomsListFilterCleaning(int count) {
    return 'Cleaning ($count)';
  }

  @override
  String get roomsListFailedToLoad => 'Failed to load rooms';

  @override
  String get roomsListNoMatchTitle => 'No matching rooms';

  @override
  String get roomsListNoMatchSubtitle => 'Try a different filter.';

  @override
  String get roomsListAddRoom => 'Add Room';

  @override
  String roomsListDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get roomsListDeleteBody => 'This cannot be undone.';

  @override
  String get roomsListAddSheetTitle => 'Add Operating Room';

  @override
  String get roomsListEditSheetTitle => 'Edit Operating Room';

  @override
  String get roomsListNameLabel => 'Name (e.g. OR-6)';

  @override
  String get roomsListNameRequired => 'Name is required';

  @override
  String get roomsListSpecialtyLabel => 'Supported specialty (optional)';

  @override
  String get roomsListInitialStatusLabel => 'Initial status';

  @override
  String get roomsListStatusFree => 'Free';

  @override
  String get roomsListStatusPreparing => 'Preparing';

  @override
  String get roomsListStatusInUse => 'In use';

  @override
  String get roomsListStatusCleaning => 'Cleaning';

  @override
  String get staffListTitle => 'Staff Directory';

  @override
  String get staffListSubtitle =>
      'Surgical suites & clinical personnel overview';

  @override
  String staffListActiveCount(int count) {
    return '$count Active';
  }

  @override
  String get staffListSearchHint => 'Filter by name, email or specialty…';

  @override
  String staffListFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String staffListFilterSurgeons(int count) {
    return 'Surgeons ($count)';
  }

  @override
  String staffListFilterCoordinators(int count) {
    return 'Coordinators ($count)';
  }

  @override
  String get staffListFailedToLoad => 'Failed to load staff';

  @override
  String get staffListNoMatchTitle => 'No matching staff';

  @override
  String get staffListNoMatchSubtitle =>
      'Try a different filter or search term.';

  @override
  String get staffListAddStaff => 'Add Staff';

  @override
  String staffListRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get staffListRemoveBody =>
      'If this user has scheduled surgeries, the removal will fail.';

  @override
  String get staffListAddSheetTitle => 'Add Staff';

  @override
  String get staffListNameLabel => 'Full name';

  @override
  String get staffListNameRequired => 'Name is required';

  @override
  String get staffListEmailLabel => 'Email';

  @override
  String get staffListEmailRequired => 'Email is required';

  @override
  String get staffListEmailInvalid => 'Enter a valid email';

  @override
  String get staffListPasswordLabel => 'Password';

  @override
  String get staffListPasswordHint => 'At least 8 characters';

  @override
  String get staffListPasswordRequired => 'Password is required';

  @override
  String get staffListPasswordTooShort => 'Minimum 8 characters';

  @override
  String get staffListRoleLabel => 'Role';

  @override
  String get staffListRoleCoordinator => 'Coordinator';

  @override
  String get staffListRoleSurgeon => 'Surgeon';

  @override
  String get staffListRoleAdmin => 'Admin';

  @override
  String get staffListSpecialtyLabel => 'Specialty';

  @override
  String get staffListSpecialtyRequired => 'Specialty is required for surgeons';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String notificationsNewCount(int count) {
    return '$count new';
  }

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsFailedToLoad => 'Failed to load notifications';

  @override
  String get notificationsNoneTitle => 'No notifications';

  @override
  String get notificationsNoneSubtitle =>
      'Updates about your surgeries will appear here.';

  @override
  String get notificationsJustNow => 'just now';

  @override
  String notificationsMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String notificationsHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String notificationsDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get mySurgeriesTitle => 'My Surgeries';

  @override
  String mySurgeriesToday(String date) {
    return 'Today, $date';
  }

  @override
  String get mySurgeriesScheduledToday => 'Scheduled Today';

  @override
  String mySurgeriesCasesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Cases',
      one: '1 Case',
    );
    return '$_temp0';
  }

  @override
  String get mySurgeriesCurrentStatus => 'Current Status';

  @override
  String get mySurgeriesDelayed => 'Delayed';

  @override
  String get mySurgeriesOnSchedule => 'On Schedule';

  @override
  String get mySurgeriesNoneTitle => 'No assigned surgeries today';

  @override
  String get mySurgeriesNoneSubtitle => 'Nothing on your list right now.';

  @override
  String get mySurgeriesFailedToLoad => 'Failed to load your surgeries';

  @override
  String get mySurgeriesInProgress => 'IN PROGRESS';

  @override
  String get mySurgeriesNextUp => 'NEXT UP';

  @override
  String get mySurgeriesUpcomingCase => 'Upcoming Case';

  @override
  String get mySurgeriesStartSurgery => 'Start Surgery';

  @override
  String mySurgeriesPatientNumber(int id) {
    return 'Patient #$id';
  }

  @override
  String mySurgeriesRoomNumber(int id) {
    return 'Room #$id';
  }

  @override
  String get surgeryDetailTitle => 'Surgery Details';

  @override
  String get surgeryDetailFailedToLoad => 'Failed to load surgery';

  @override
  String surgeryDetailPatientNumber(int id) {
    return 'Patient #$id';
  }

  @override
  String surgeryDetailMrn(String mrn) {
    return 'MRN $mrn';
  }

  @override
  String get surgeryDetailProcedure => 'PROCEDURE';

  @override
  String get surgeryDetailSurgeryFallback => 'Surgery';

  @override
  String get surgeryDetailAssignedSuite => 'Assigned Suite';

  @override
  String surgeryDetailRoomNumber(int id) {
    return 'Room #$id';
  }

  @override
  String get surgeryDetailTargetPace => 'Target Pace';

  @override
  String surgeryDetailMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get surgeryDetailScheduledSlot => 'Scheduled Slot';

  @override
  String get surgeryDetailActualTime => 'Actual Time';

  @override
  String surgeryDetailInProgressStarted(String time) {
    return 'In Progress (Started $time)';
  }

  @override
  String surgeryDetailEnded(String time) {
    return 'Ended $time';
  }

  @override
  String surgeryDetailEstimatedDuration(int minutes) {
    return 'Estimated duration $minutes mins';
  }

  @override
  String get surgeryDetailStartSurgery => 'Start Surgery';

  @override
  String get surgeryDetailReportDelay => 'Report Delay';

  @override
  String get delayFormTitle => 'Report Delay';

  @override
  String get delayFormNewEndLabel => 'New expected end time';

  @override
  String get delayFormNewEndHint => 'Pick a date and time';

  @override
  String get delayFormNewEndRequired => 'Pick a new expected end time';

  @override
  String get delayFormReasonLabel => 'Reason';

  @override
  String get delayFormReasonHint => 'What\'s causing the delay?';

  @override
  String get delayFormReasonRequired => 'A reason is required';

  @override
  String get delayFormSubmit => 'Submit delay report';

  @override
  String get delayResultAutoApprovedTitle => 'Delay approved automatically';

  @override
  String get delayResultPendingTitle => 'Delay pending coordinator review';

  @override
  String get delayResultDismiss => 'Dismiss';

  @override
  String delayResultAutoApprovedBody(String newEnd) {
    return 'The new expected end time does not conflict with any other surgery in this room. This surgery now runs until $newEnd.';
  }

  @override
  String delayResultPendingBody(int surgeryId, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggestions were generated',
      one: '1 suggestion was generated',
      zero: 'No suggestions were generated',
    );
    return 'Extending this surgery would conflict with surgery #$surgeryId in the same room. $_temp0 for the affected downstream surgeries.';
  }

  @override
  String get surgeryDetailMarkComplete => 'Mark Complete';

  @override
  String get surgeryDetailCancelSurgery => 'Cancel surgery';

  @override
  String get messageRoomDeleted => 'Room deleted';

  @override
  String get messageRoomAdded => 'Room added';

  @override
  String get messageRoomUpdated => 'Room updated';

  @override
  String get messageStaffDeleted => 'Staff deleted';

  @override
  String get messageStaffAdded => 'Staff added';

  @override
  String get messageStaffUpdated => 'Staff updated';

  @override
  String get messageSurgeryStarted => 'Surgery started';

  @override
  String get messageSurgeryCancelled => 'Surgery cancelled';

  @override
  String get messagePatientDeleted => 'Patient deleted';

  @override
  String get messagePatientAdded => 'Patient added';

  @override
  String get messagePatientUpdated => 'Patient updated';

  @override
  String get messageSurgeryTypeDeleted => 'Surgery type deleted';

  @override
  String get messageSurgeryTypeAdded => 'Surgery type added';

  @override
  String get messageSurgeryTypeUpdated => 'Surgery type updated';

  @override
  String get messageSlotAdded => 'Availability slot added';

  @override
  String get messageSlotUpdated => 'Availability slot updated';

  @override
  String get messageSlotDeleted => 'Availability slot deleted';

  @override
  String get patientsTitle => 'Patients';

  @override
  String get patientsSearchHint => 'Search patients by name…';

  @override
  String get patientsFailedToLoad => 'Failed to load patients';

  @override
  String get patientsNoneTitle => 'No patients found';

  @override
  String get patientsNoneSubtitle =>
      'Try a different search, or add a new patient.';

  @override
  String get patientsAddPatient => 'Add Patient';

  @override
  String get patientsAddSheetTitle => 'Add Patient';

  @override
  String get patientsEditSheetTitle => 'Edit Patient';

  @override
  String get patientsNameLabel => 'Full name';

  @override
  String get patientsNameRequired => 'Name is required';

  @override
  String get patientsMrnLabel => 'MRN';

  @override
  String get patientsMrnRequired => 'MRN is required';

  @override
  String get patientsNotesLabel => 'Medical notes (optional)';

  @override
  String patientsDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get patientsDeleteBody =>
      'This also cancels/removes their scheduled surgeries. This cannot be undone.';

  @override
  String get surgeryTypesTitle => 'Surgery Types';

  @override
  String get surgeryTypesFailedToLoad => 'Failed to load surgery types';

  @override
  String get surgeryTypesNoneTitle => 'No surgery types';

  @override
  String get surgeryTypesNoneSubtitle =>
      'Add one to start scheduling surgeries of this type.';

  @override
  String get surgeryTypesAdd => 'Add Surgery Type';

  @override
  String get surgeryTypesAddSheetTitle => 'Add Surgery Type';

  @override
  String get surgeryTypesEditSheetTitle => 'Edit Surgery Type';

  @override
  String get surgeryTypesNameLabel => 'Name';

  @override
  String get surgeryTypesNameRequired => 'Name is required';

  @override
  String get surgeryTypesDurationLabel => 'Average duration (minutes)';

  @override
  String get surgeryTypesDurationRequired => 'Duration is required';

  @override
  String get surgeryTypesDurationInvalid =>
      'Enter a whole number of minutes (5 or more)';

  @override
  String get surgeryTypesSpecialtyLabel => 'Required specialty (optional)';

  @override
  String get surgeryTypesDefaultRoomLabel => 'Default room (optional)';

  @override
  String get surgeryTypesNoDefaultRoom => 'None';

  @override
  String surgeryTypesDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get surgeryTypesDeleteBody => 'This cannot be undone.';

  @override
  String surgeryTypesDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String surgeryTypesDefaultRoomValue(String name) {
    return 'Default room: $name';
  }

  @override
  String get roomDetailTitle => 'Room Details';

  @override
  String get roomDetailFailedToLoad => 'Failed to load room';

  @override
  String get roomDetailFilterToday => 'Today';

  @override
  String get roomDetailFilterThisWeek => 'This Week';

  @override
  String get roomDetailFilterLastWeek => 'Last Week';

  @override
  String get roomDetailFilterCustom => 'Custom Range';

  @override
  String get roomDetailFilterAll => 'All';

  @override
  String get roomDetailFilterThisMonth => 'This Month';

  @override
  String get roomDetailNoSurgeriesTitle => 'No surgeries in this range';

  @override
  String get roomDetailNoSurgeriesSubtitle => 'Try a different date range.';

  @override
  String get roomDetailManageAvailability => 'Manage availability';

  @override
  String get roomDetailChangePhoto => 'Change photo';

  @override
  String get roomDetailAddPhoto => 'Add photo';

  @override
  String get roomSlotsTitle => 'Weekly Availability';

  @override
  String get roomSlotsSubtitle =>
      'Rooms with no slots defined are bookable at any time.';

  @override
  String get roomSlotsNoneTitle => 'No availability slots';

  @override
  String get roomSlotsNoneSubtitle => 'This room is bookable at any time.';

  @override
  String get roomSlotsAdd => 'Add Slot';

  @override
  String get roomSlotsAddSheetTitle => 'Add Availability Slot';

  @override
  String get roomSlotsDayLabel => 'Day of week';

  @override
  String get roomSlotsStartLabel => 'Start time';

  @override
  String get roomSlotsEndLabel => 'End time';

  @override
  String get roomSlotsEndBeforeStart => 'End time must be after start time';

  @override
  String get roomSlotsDeleteTitle => 'Delete this slot?';

  @override
  String get roomSlotsDeleteBody => 'This cannot be undone.';

  @override
  String get daySunday => 'Sunday';

  @override
  String get dayMonday => 'Monday';

  @override
  String get dayTuesday => 'Tuesday';

  @override
  String get dayWednesday => 'Wednesday';

  @override
  String get dayThursday => 'Thursday';

  @override
  String get dayFriday => 'Friday';

  @override
  String get daySaturday => 'Saturday';

  @override
  String get scheduleSurgeryDurationLabel => 'Estimated duration (minutes)';

  @override
  String get scheduleSurgeryDurationRequired => 'Duration is required';

  @override
  String get scheduleSurgeryDurationInvalid =>
      'Enter a whole number of minutes (5 or more)';

  @override
  String get settingsNavLabel => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsAbout => 'About the app';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsConditions => 'Terms & Conditions';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutAppName => 'Shifa (شفاء)';

  @override
  String get aboutDescription =>
      'Shifa is a hospital operating-room scheduling system designed to help hospital staff manage operating rooms, schedule surgeries efficiently, and coordinate in real time using smart scheduling optimization.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDeveloperSection => 'Developer';

  @override
  String get aboutDeveloperName =>
      'Mohamed Abdulrahman Alomari (محمد عبد الرحمن العمري)';

  @override
  String get aboutDeveloperBlurb =>
      'Developed by a Flutter developer specializing in clean architecture and scalable mobile applications.';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String privacyLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get privacyIntro =>
      'This Privacy Policy explains what information Shifa collects and how it is used.';

  @override
  String get privacyCollectedHeading => 'What data is collected';

  @override
  String get privacyCollectedBody =>
      'We collect account information (name, email, role) and operational data needed to run the scheduling system (patient records, surgery schedules, room and staff assignments). All data stays within the hospital\'s own private backend and is never stored on third-party servers.';

  @override
  String get privacyUsageHeading => 'How data is used';

  @override
  String get privacyUsageBody =>
      'Data is used solely to operate and coordinate operating-room scheduling within the hospital — assigning rooms, tracking surgery status, and notifying relevant staff.';

  @override
  String get privacySharingHeading => 'Sharing';

  @override
  String get privacySharingBody =>
      'Data is not shared with any third party. It is only accessible to authorized hospital staff through this application.';

  @override
  String get privacyStorageHeading => 'Storage & security';

  @override
  String get privacyStorageBody =>
      'Data is stored securely on the hospital\'s own server infrastructure, protected by authenticated access and role-based permissions.';

  @override
  String get privacyContactHeading => 'Contact';

  @override
  String get privacyContactBody =>
      'For privacy concerns, contact mohamed.alomari.dev@gmail.com.';

  @override
  String get termsTitle => 'Terms & Conditions';

  @override
  String termsLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get termsIntro =>
      'These Terms govern the use of the Shifa operating-room scheduling application.';

  @override
  String get termsAuthorizedHeading => 'Authorized use only';

  @override
  String get termsAuthorizedBody =>
      'This app is intended for authorized hospital staff only — admin, coordinator, and surgeon roles. Accounts are provisioned and managed by hospital administration.';

  @override
  String get termsAccuracyHeading => 'Accuracy of information';

  @override
  String get termsAccuracyBody =>
      'Users are responsible for the accuracy of the information they enter, including patient, surgery, and scheduling details.';

  @override
  String get termsDecisionSupportHeading =>
      'Decision support, not medical authority';

  @override
  String get termsDecisionSupportBody =>
      'Scheduling suggestions produced by the app are decision-support tools only. Final medical and scheduling decisions remain the responsibility of hospital staff, not the application.';

  @override
  String get termsAccountsHeading => 'Accounts';

  @override
  String get termsAccountsBody =>
      'Accounts are provisioned and managed by hospital administration. Users may not share credentials.';

  @override
  String get termsContactHeading => 'Contact';

  @override
  String get termsContactBody =>
      'For questions about these terms, contact mohamed.alomari.dev@gmail.com.';

  @override
  String get aboutEmailAction => 'Email';

  @override
  String get aboutPhoneAction => 'Call';
}
