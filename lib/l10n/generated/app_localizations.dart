import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// App wordmark
  ///
  /// In en, this message translates to:
  /// **'Shifa'**
  String get appName;

  /// No description provided for @errorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorUnauthenticated;

  /// No description provided for @errorRoleForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do that.'**
  String get errorRoleForbidden;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You\'re not authorized to do that.'**
  String get errorUnauthorized;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'That item couldn\'t be found. It may have been removed.'**
  String get errorNotFound;

  /// No description provided for @errorMethodNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'That action isn\'t supported right now.'**
  String get errorMethodNotAllowed;

  /// No description provided for @errorValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted fields and try again.'**
  String get errorValidationFailed;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorSurgeryNotOwned.
  ///
  /// In en, this message translates to:
  /// **'You can only do that for your own surgeries.'**
  String get errorSurgeryNotOwned;

  /// No description provided for @errorSurgeryTimeConflict.
  ///
  /// In en, this message translates to:
  /// **'This room is already booked at that time.'**
  String get errorSurgeryTimeConflict;

  /// No description provided for @errorRoomAvailabilityWindowViolation.
  ///
  /// In en, this message translates to:
  /// **'That time falls outside this room\'s available hours.'**
  String get errorRoomAvailabilityWindowViolation;

  /// No description provided for @errorSurgeryNotInProgress.
  ///
  /// In en, this message translates to:
  /// **'This action requires the surgery to be in progress.'**
  String get errorSurgeryNotInProgress;

  /// No description provided for @errorSuggestionNotPending.
  ///
  /// In en, this message translates to:
  /// **'This suggestion has already been actioned.'**
  String get errorSuggestionNotPending;

  /// No description provided for @errorNotificationNotOwned.
  ///
  /// In en, this message translates to:
  /// **'You can only manage your own notifications.'**
  String get errorNotificationNotOwned;

  /// No description provided for @errorSlotRoomMismatch.
  ///
  /// In en, this message translates to:
  /// **'That availability slot doesn\'t belong to this room.'**
  String get errorSlotRoomMismatch;

  /// No description provided for @errorSlotInvalidTimeRange.
  ///
  /// In en, this message translates to:
  /// **'The end time must be after the start time.'**
  String get errorSlotInvalidTimeRange;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get appTagline;

  /// No description provided for @navRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get navRooms;

  /// No description provided for @navStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get navSuggestions;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navSurgeries.
  ///
  /// In en, this message translates to:
  /// **'Surgeries'**
  String get navSurgeries;

  /// No description provided for @navManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get navManage;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @manageTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manageTitle;

  /// No description provided for @manageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rooms, staff, patients, and surgery types'**
  String get manageSubtitle;

  /// No description provided for @manageRoomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, add, and configure operating rooms'**
  String get manageRoomsSubtitle;

  /// No description provided for @manageStaffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, add, and edit coordinators and surgeons'**
  String get manageStaffSubtitle;

  /// No description provided for @managePatientsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search, add, and edit patient records'**
  String get managePatientsSubtitle;

  /// No description provided for @manageSurgeryTypesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure procedures, durations, and default rooms'**
  String get manageSurgeryTypesSubtitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get commonUnknown;

  /// No description provided for @commonNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get commonNotAvailable;

  /// No description provided for @subtitleOrSchedule.
  ///
  /// In en, this message translates to:
  /// **'Or Schedule'**
  String get subtitleOrSchedule;

  /// No description provided for @subtitleMySurgeries.
  ///
  /// In en, this message translates to:
  /// **'My Surgeries'**
  String get subtitleMySurgeries;

  /// No description provided for @subtitleClinicalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Clinical Alerts'**
  String get subtitleClinicalAlerts;

  /// No description provided for @subtitleDelaySuggestions.
  ///
  /// In en, this message translates to:
  /// **'Delay Suggestions'**
  String get subtitleDelaySuggestions;

  /// No description provided for @subtitleSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get subtitleSettings;

  /// No description provided for @notificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Shifa'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage today\'s operating room schedule.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@shifa.test'**
  String get loginEmailHint;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @roomTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Timeline'**
  String get roomTimelineTitle;

  /// No description provided for @roomTimelineSuitesMonitored.
  ///
  /// In en, this message translates to:
  /// **'{count} Suites Monitored'**
  String roomTimelineSuitesMonitored(int count);

  /// No description provided for @roomTimelineNoRooms.
  ///
  /// In en, this message translates to:
  /// **'No operating rooms'**
  String get roomTimelineNoRooms;

  /// No description provided for @roomTimelineNoRoomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask an admin to add rooms.'**
  String get roomTimelineNoRoomsSubtitle;

  /// No description provided for @roomTimelineFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load timeline'**
  String get roomTimelineFailedToLoad;

  /// No description provided for @roomTimelineScheduleSurgery.
  ///
  /// In en, this message translates to:
  /// **'Schedule surgery'**
  String get roomTimelineScheduleSurgery;

  /// No description provided for @roomTimelineOr.
  ///
  /// In en, this message translates to:
  /// **'OR {id}'**
  String roomTimelineOr(int id);

  /// No description provided for @roomTimelinePatientNumber.
  ///
  /// In en, this message translates to:
  /// **'Patient #{id}'**
  String roomTimelinePatientNumber(int id);

  /// No description provided for @roomTimelineSurgeryFallback.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get roomTimelineSurgeryFallback;

  /// No description provided for @roomTimelineEnds.
  ///
  /// In en, this message translates to:
  /// **'ENDS'**
  String get roomTimelineEnds;

  /// No description provided for @roomTimelineNext.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get roomTimelineNext;

  /// No description provided for @roomTimelineStatus.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get roomTimelineStatus;

  /// No description provided for @roomTimelineVacantReady.
  ///
  /// In en, this message translates to:
  /// **'Vacant & Ready'**
  String get roomTimelineVacantReady;

  /// No description provided for @roomTimelineVacantReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for immediate intake'**
  String get roomTimelineVacantReadySubtitle;

  /// No description provided for @roomTimelinePreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get roomTimelinePreparing;

  /// No description provided for @roomTimelinePreparingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Room is being set up'**
  String get roomTimelinePreparingSubtitle;

  /// No description provided for @roomTimelineTurnover.
  ///
  /// In en, this message translates to:
  /// **'Turnover in progress'**
  String get roomTimelineTurnover;

  /// No description provided for @roomTimelineTurnoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Environmental services'**
  String get roomTimelineTurnoverSubtitle;

  /// No description provided for @roomTimelineInUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get roomTimelineInUse;

  /// No description provided for @roomTimelineInUseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No case assigned in the schedule'**
  String get roomTimelineInUseSubtitle;

  /// No description provided for @roomTimelineUnknownStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Room status not set'**
  String get roomTimelineUnknownStatusSubtitle;

  /// No description provided for @roomTimelineAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get roomTimelineAvailable;

  /// No description provided for @roomTimelineCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get roomTimelineCleaning;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @scheduleSurgeryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Surgery'**
  String get scheduleSurgeryTitle;

  /// No description provided for @scheduleSurgerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Case Scheduling & OR Assignment'**
  String get scheduleSurgerySubtitle;

  /// No description provided for @scheduleSurgeryFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load form'**
  String get scheduleSurgeryFailedToLoad;

  /// No description provided for @scheduleSurgeryMissingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing setup data'**
  String get scheduleSurgeryMissingSetupTitle;

  /// No description provided for @scheduleSurgeryMissingSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask an admin to add patients, surgeons, and surgery types before scheduling.'**
  String get scheduleSurgeryMissingSetupSubtitle;

  /// No description provided for @scheduleSurgeryPatientLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get scheduleSurgeryPatientLabel;

  /// No description provided for @scheduleSurgeryPatientHint.
  ///
  /// In en, this message translates to:
  /// **'Select a patient'**
  String get scheduleSurgeryPatientHint;

  /// No description provided for @scheduleSurgerySurgeonLabel.
  ///
  /// In en, this message translates to:
  /// **'Surgeon'**
  String get scheduleSurgerySurgeonLabel;

  /// No description provided for @scheduleSurgerySurgeonHint.
  ///
  /// In en, this message translates to:
  /// **'Select a surgeon'**
  String get scheduleSurgerySurgeonHint;

  /// No description provided for @scheduleSurgeryTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Surgery Type'**
  String get scheduleSurgeryTypeLabel;

  /// No description provided for @scheduleSurgeryTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get scheduleSurgeryTypeHint;

  /// No description provided for @scheduleSurgeryTypeDuration.
  ///
  /// In en, this message translates to:
  /// **'{name} ({minutes}m)'**
  String scheduleSurgeryTypeDuration(String name, int minutes);

  /// No description provided for @scheduleSurgeryPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority Level'**
  String get scheduleSurgeryPriorityLabel;

  /// No description provided for @scheduleSurgeryPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get scheduleSurgeryPriorityNormal;

  /// No description provided for @scheduleSurgeryPriorityEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get scheduleSurgeryPriorityEmergency;

  /// No description provided for @scheduleSurgeryAutoSchedule.
  ///
  /// In en, this message translates to:
  /// **'Auto-schedule'**
  String get scheduleSurgeryAutoSchedule;

  /// No description provided for @scheduleSurgeryPickManually.
  ///
  /// In en, this message translates to:
  /// **'Pick manually'**
  String get scheduleSurgeryPickManually;

  /// No description provided for @pickManuallyTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick manually'**
  String get pickManuallyTitle;

  /// No description provided for @pickManuallySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the room and start time'**
  String get pickManuallySubtitle;

  /// No description provided for @pickManuallyFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load rooms'**
  String get pickManuallyFailedToLoad;

  /// No description provided for @pickManuallyOperatingRoom.
  ///
  /// In en, this message translates to:
  /// **'Operating Room'**
  String get pickManuallyOperatingRoom;

  /// No description provided for @pickManuallyScheduledStart.
  ///
  /// In en, this message translates to:
  /// **'Scheduled start'**
  String get pickManuallyScheduledStart;

  /// No description provided for @pickManuallyPickDateTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a date and time'**
  String get pickManuallyPickDateTime;

  /// No description provided for @pickManuallyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm scheduling'**
  String get pickManuallyConfirm;

  /// No description provided for @pickManuallyScheduled.
  ///
  /// In en, this message translates to:
  /// **'Surgery scheduled'**
  String get pickManuallyScheduled;

  /// No description provided for @autoScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Schedule Suggestions'**
  String get autoScheduleTitle;

  /// No description provided for @autoScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optimal room slots based on surgeon availability'**
  String get autoScheduleSubtitle;

  /// No description provided for @autoScheduleFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load options'**
  String get autoScheduleFailedToLoad;

  /// No description provided for @autoScheduleNoPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get autoScheduleNoPendingTitle;

  /// No description provided for @autoScheduleNoPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add one or more surgeries to auto-schedule as a batch.'**
  String get autoScheduleNoPendingSubtitle;

  /// No description provided for @autoScheduleAddRequest.
  ///
  /// In en, this message translates to:
  /// **'Add request'**
  String get autoScheduleAddRequest;

  /// No description provided for @autoScheduleAddRequestFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a request first'**
  String get autoScheduleAddRequestFirst;

  /// No description provided for @autoScheduleGenerateProposals.
  ///
  /// In en, this message translates to:
  /// **'Generate proposals ({count})'**
  String autoScheduleGenerateProposals(int count);

  /// No description provided for @autoScheduleAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add pending request'**
  String get autoScheduleAddSheetTitle;

  /// No description provided for @autoScheduleAddToBatch.
  ///
  /// In en, this message translates to:
  /// **'Add to batch'**
  String get autoScheduleAddToBatch;

  /// No description provided for @autoScheduleAllActionedTitle.
  ///
  /// In en, this message translates to:
  /// **'All proposals actioned'**
  String get autoScheduleAllActionedTitle;

  /// No description provided for @autoScheduleAllActionedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{accepted} scheduled, {skipped} skipped.'**
  String autoScheduleAllActionedSubtitle(int accepted, int skipped);

  /// No description provided for @autoScheduleStartNewBatch.
  ///
  /// In en, this message translates to:
  /// **'Start a new batch'**
  String get autoScheduleStartNewBatch;

  /// No description provided for @autoScheduleAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get autoScheduleAccept;

  /// No description provided for @autoScheduleReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get autoScheduleReject;

  /// No description provided for @autoScheduleToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get autoScheduleToday;

  /// No description provided for @autoScheduleTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get autoScheduleTomorrow;

  /// No description provided for @delaySuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delay Resolution'**
  String get delaySuggestionsTitle;

  /// No description provided for @delaySuggestionsNonePending.
  ///
  /// In en, this message translates to:
  /// **'No pending adjustments'**
  String get delaySuggestionsNonePending;

  /// No description provided for @delaySuggestionsPendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 pending adjustment} other{{count} pending adjustments}}'**
  String delaySuggestionsPendingCount(int count);

  /// No description provided for @delaySuggestionsActiveOverrun.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE OVERRUN'**
  String get delaySuggestionsActiveOverrun;

  /// No description provided for @delaySuggestionsFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load suggestions'**
  String get delaySuggestionsFailedToLoad;

  /// No description provided for @delaySuggestionsNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending suggestions'**
  String get delaySuggestionsNoneTitle;

  /// No description provided for @delaySuggestionsNoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up.'**
  String get delaySuggestionsNoneSubtitle;

  /// No description provided for @delaySuggestionsSurgeryNumber.
  ///
  /// In en, this message translates to:
  /// **'Surgery #{id}'**
  String delaySuggestionsSurgeryNumber(int id);

  /// No description provided for @delaySuggestionsRoomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room #{id}'**
  String delaySuggestionsRoomNumber(int id);

  /// No description provided for @roomsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Operating Rooms'**
  String get roomsListTitle;

  /// No description provided for @roomsListSuitesConfigured.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 Operating Suite Configured} other{{count} Operating Suites Configured}}'**
  String roomsListSuitesConfigured(int count);

  /// No description provided for @roomsListFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Suites ({count})'**
  String roomsListFilterAll(int count);

  /// No description provided for @roomsListFilterInUse.
  ///
  /// In en, this message translates to:
  /// **'In use ({count})'**
  String roomsListFilterInUse(int count);

  /// No description provided for @roomsListFilterFree.
  ///
  /// In en, this message translates to:
  /// **'Free ({count})'**
  String roomsListFilterFree(int count);

  /// No description provided for @roomsListFilterPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing ({count})'**
  String roomsListFilterPreparing(int count);

  /// No description provided for @roomsListFilterCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning ({count})'**
  String roomsListFilterCleaning(int count);

  /// No description provided for @roomsListFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load rooms'**
  String get roomsListFailedToLoad;

  /// No description provided for @roomsListNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching rooms'**
  String get roomsListNoMatchTitle;

  /// No description provided for @roomsListNoMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different filter.'**
  String get roomsListNoMatchSubtitle;

  /// No description provided for @roomsListAddRoom.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get roomsListAddRoom;

  /// No description provided for @roomsListDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String roomsListDeleteTitle(String name);

  /// No description provided for @roomsListDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get roomsListDeleteBody;

  /// No description provided for @roomsListAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Operating Room'**
  String get roomsListAddSheetTitle;

  /// No description provided for @roomsListEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Operating Room'**
  String get roomsListEditSheetTitle;

  /// No description provided for @roomsListNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (e.g. OR-6)'**
  String get roomsListNameLabel;

  /// No description provided for @roomsListNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get roomsListNameRequired;

  /// No description provided for @roomsListSpecialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Supported specialty (optional)'**
  String get roomsListSpecialtyLabel;

  /// No description provided for @roomsListInitialStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial status'**
  String get roomsListInitialStatusLabel;

  /// No description provided for @roomsListStatusFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get roomsListStatusFree;

  /// No description provided for @roomsListStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get roomsListStatusPreparing;

  /// No description provided for @roomsListStatusInUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get roomsListStatusInUse;

  /// No description provided for @roomsListStatusCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get roomsListStatusCleaning;

  /// No description provided for @staffListTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff Directory'**
  String get staffListTitle;

  /// No description provided for @staffListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Surgical suites & clinical personnel overview'**
  String get staffListSubtitle;

  /// No description provided for @staffListActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String staffListActiveCount(int count);

  /// No description provided for @staffListSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Filter by name, email or specialty…'**
  String get staffListSearchHint;

  /// No description provided for @staffListFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String staffListFilterAll(int count);

  /// No description provided for @staffListFilterSurgeons.
  ///
  /// In en, this message translates to:
  /// **'Surgeons ({count})'**
  String staffListFilterSurgeons(int count);

  /// No description provided for @staffListFilterCoordinators.
  ///
  /// In en, this message translates to:
  /// **'Coordinators ({count})'**
  String staffListFilterCoordinators(int count);

  /// No description provided for @staffListFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load staff'**
  String get staffListFailedToLoad;

  /// No description provided for @staffListNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching staff'**
  String get staffListNoMatchTitle;

  /// No description provided for @staffListNoMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different filter or search term.'**
  String get staffListNoMatchSubtitle;

  /// No description provided for @staffListAddStaff.
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get staffListAddStaff;

  /// No description provided for @staffListRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String staffListRemoveTitle(String name);

  /// No description provided for @staffListRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'If this user has scheduled surgeries, the removal will fail.'**
  String get staffListRemoveBody;

  /// No description provided for @staffListAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get staffListAddSheetTitle;

  /// No description provided for @staffListNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get staffListNameLabel;

  /// No description provided for @staffListNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get staffListNameRequired;

  /// No description provided for @staffListEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get staffListEmailLabel;

  /// No description provided for @staffListEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get staffListEmailRequired;

  /// No description provided for @staffListEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get staffListEmailInvalid;

  /// No description provided for @staffListPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get staffListPasswordLabel;

  /// No description provided for @staffListPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get staffListPasswordHint;

  /// No description provided for @staffListPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get staffListPasswordRequired;

  /// No description provided for @staffListPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get staffListPasswordTooShort;

  /// No description provided for @staffListRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get staffListRoleLabel;

  /// No description provided for @staffListRoleCoordinator.
  ///
  /// In en, this message translates to:
  /// **'Coordinator'**
  String get staffListRoleCoordinator;

  /// No description provided for @staffListRoleSurgeon.
  ///
  /// In en, this message translates to:
  /// **'Surgeon'**
  String get staffListRoleSurgeon;

  /// No description provided for @staffListRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get staffListRoleAdmin;

  /// No description provided for @staffListSpecialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get staffListSpecialtyLabel;

  /// No description provided for @staffListSpecialtyRequired.
  ///
  /// In en, this message translates to:
  /// **'Specialty is required for surgeons'**
  String get staffListSpecialtyRequired;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsNewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String notificationsNewCount(int count);

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get notificationsFailedToLoad;

  /// No description provided for @notificationsNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsNoneTitle;

  /// No description provided for @notificationsNoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Updates about your surgeries will appear here.'**
  String get notificationsNoneSubtitle;

  /// No description provided for @notificationsJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get notificationsJustNow;

  /// No description provided for @notificationsMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String notificationsMinutesAgo(int count);

  /// No description provided for @notificationsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String notificationsHoursAgo(int count);

  /// No description provided for @notificationsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String notificationsDaysAgo(int count);

  /// No description provided for @mySurgeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Surgeries'**
  String get mySurgeriesTitle;

  /// No description provided for @mySurgeriesToday.
  ///
  /// In en, this message translates to:
  /// **'Today, {date}'**
  String mySurgeriesToday(String date);

  /// No description provided for @mySurgeriesScheduledToday.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Today'**
  String get mySurgeriesScheduledToday;

  /// No description provided for @mySurgeriesCasesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 Case} other{{count} Cases}}'**
  String mySurgeriesCasesCount(int count);

  /// No description provided for @mySurgeriesCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get mySurgeriesCurrentStatus;

  /// No description provided for @mySurgeriesDelayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get mySurgeriesDelayed;

  /// No description provided for @mySurgeriesOnSchedule.
  ///
  /// In en, this message translates to:
  /// **'On Schedule'**
  String get mySurgeriesOnSchedule;

  /// No description provided for @mySurgeriesNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No assigned surgeries today'**
  String get mySurgeriesNoneTitle;

  /// No description provided for @mySurgeriesNoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing on your list right now.'**
  String get mySurgeriesNoneSubtitle;

  /// No description provided for @mySurgeriesFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load your surgeries'**
  String get mySurgeriesFailedToLoad;

  /// No description provided for @mySurgeriesInProgress.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get mySurgeriesInProgress;

  /// No description provided for @mySurgeriesNextUp.
  ///
  /// In en, this message translates to:
  /// **'NEXT UP'**
  String get mySurgeriesNextUp;

  /// No description provided for @mySurgeriesUpcomingCase.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Case'**
  String get mySurgeriesUpcomingCase;

  /// No description provided for @mySurgeriesStartSurgery.
  ///
  /// In en, this message translates to:
  /// **'Start Surgery'**
  String get mySurgeriesStartSurgery;

  /// No description provided for @mySurgeriesPatientNumber.
  ///
  /// In en, this message translates to:
  /// **'Patient #{id}'**
  String mySurgeriesPatientNumber(int id);

  /// No description provided for @mySurgeriesRoomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room #{id}'**
  String mySurgeriesRoomNumber(int id);

  /// No description provided for @surgeryDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Surgery Details'**
  String get surgeryDetailTitle;

  /// No description provided for @surgeryDetailFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load surgery'**
  String get surgeryDetailFailedToLoad;

  /// No description provided for @surgeryDetailPatientNumber.
  ///
  /// In en, this message translates to:
  /// **'Patient #{id}'**
  String surgeryDetailPatientNumber(int id);

  /// No description provided for @surgeryDetailMrn.
  ///
  /// In en, this message translates to:
  /// **'MRN {mrn}'**
  String surgeryDetailMrn(String mrn);

  /// No description provided for @surgeryDetailProcedure.
  ///
  /// In en, this message translates to:
  /// **'PROCEDURE'**
  String get surgeryDetailProcedure;

  /// No description provided for @surgeryDetailSurgeryFallback.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get surgeryDetailSurgeryFallback;

  /// No description provided for @surgeryDetailAssignedSuite.
  ///
  /// In en, this message translates to:
  /// **'Assigned Suite'**
  String get surgeryDetailAssignedSuite;

  /// No description provided for @surgeryDetailRoomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room #{id}'**
  String surgeryDetailRoomNumber(int id);

  /// No description provided for @surgeryDetailTargetPace.
  ///
  /// In en, this message translates to:
  /// **'Target Pace'**
  String get surgeryDetailTargetPace;

  /// No description provided for @surgeryDetailMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String surgeryDetailMinutesShort(int minutes);

  /// No description provided for @surgeryDetailScheduledSlot.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Slot'**
  String get surgeryDetailScheduledSlot;

  /// No description provided for @surgeryDetailActualTime.
  ///
  /// In en, this message translates to:
  /// **'Actual Time'**
  String get surgeryDetailActualTime;

  /// No description provided for @surgeryDetailInProgressStarted.
  ///
  /// In en, this message translates to:
  /// **'In Progress (Started {time})'**
  String surgeryDetailInProgressStarted(String time);

  /// No description provided for @surgeryDetailEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended {time}'**
  String surgeryDetailEnded(String time);

  /// No description provided for @surgeryDetailEstimatedDuration.
  ///
  /// In en, this message translates to:
  /// **'Estimated duration {minutes} mins'**
  String surgeryDetailEstimatedDuration(int minutes);

  /// No description provided for @surgeryDetailStartSurgery.
  ///
  /// In en, this message translates to:
  /// **'Start Surgery'**
  String get surgeryDetailStartSurgery;

  /// No description provided for @surgeryDetailReportDelay.
  ///
  /// In en, this message translates to:
  /// **'Report Delay'**
  String get surgeryDetailReportDelay;

  /// No description provided for @delayFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Delay'**
  String get delayFormTitle;

  /// No description provided for @delayFormNewEndLabel.
  ///
  /// In en, this message translates to:
  /// **'New expected end time'**
  String get delayFormNewEndLabel;

  /// No description provided for @delayFormNewEndHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a date and time'**
  String get delayFormNewEndHint;

  /// No description provided for @delayFormNewEndRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a new expected end time'**
  String get delayFormNewEndRequired;

  /// No description provided for @delayFormReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get delayFormReasonLabel;

  /// No description provided for @delayFormReasonHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s causing the delay?'**
  String get delayFormReasonHint;

  /// No description provided for @delayFormReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is required'**
  String get delayFormReasonRequired;

  /// No description provided for @delayFormSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit delay report'**
  String get delayFormSubmit;

  /// No description provided for @delayResultAutoApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Delay approved automatically'**
  String get delayResultAutoApprovedTitle;

  /// No description provided for @delayResultPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delay pending coordinator review'**
  String get delayResultPendingTitle;

  /// No description provided for @delayResultDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get delayResultDismiss;

  /// No description provided for @delayResultAutoApprovedBody.
  ///
  /// In en, this message translates to:
  /// **'The new expected end time does not conflict with any other surgery in this room. This surgery now runs until {newEnd}.'**
  String delayResultAutoApprovedBody(String newEnd);

  /// No description provided for @delayResultPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Extending this surgery would conflict with surgery #{surgeryId} in the same room. {count, plural, =0{No suggestions were generated} one{1 suggestion was generated} other{{count} suggestions were generated}} for the affected downstream surgeries.'**
  String delayResultPendingBody(int surgeryId, int count);

  /// No description provided for @surgeryDetailMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get surgeryDetailMarkComplete;

  /// No description provided for @surgeryDetailCancelSurgery.
  ///
  /// In en, this message translates to:
  /// **'Cancel surgery'**
  String get surgeryDetailCancelSurgery;

  /// No description provided for @messageRoomDeleted.
  ///
  /// In en, this message translates to:
  /// **'Room deleted'**
  String get messageRoomDeleted;

  /// No description provided for @messageRoomAdded.
  ///
  /// In en, this message translates to:
  /// **'Room added'**
  String get messageRoomAdded;

  /// No description provided for @messageRoomUpdated.
  ///
  /// In en, this message translates to:
  /// **'Room updated'**
  String get messageRoomUpdated;

  /// No description provided for @messageStaffDeleted.
  ///
  /// In en, this message translates to:
  /// **'Staff deleted'**
  String get messageStaffDeleted;

  /// No description provided for @messageStaffAdded.
  ///
  /// In en, this message translates to:
  /// **'Staff added'**
  String get messageStaffAdded;

  /// No description provided for @messageStaffUpdated.
  ///
  /// In en, this message translates to:
  /// **'Staff updated'**
  String get messageStaffUpdated;

  /// No description provided for @messageSurgeryStarted.
  ///
  /// In en, this message translates to:
  /// **'Surgery started'**
  String get messageSurgeryStarted;

  /// No description provided for @messageSurgeryCancelled.
  ///
  /// In en, this message translates to:
  /// **'Surgery cancelled'**
  String get messageSurgeryCancelled;

  /// No description provided for @messagePatientDeleted.
  ///
  /// In en, this message translates to:
  /// **'Patient deleted'**
  String get messagePatientDeleted;

  /// No description provided for @messagePatientAdded.
  ///
  /// In en, this message translates to:
  /// **'Patient added'**
  String get messagePatientAdded;

  /// No description provided for @messagePatientUpdated.
  ///
  /// In en, this message translates to:
  /// **'Patient updated'**
  String get messagePatientUpdated;

  /// No description provided for @messageSurgeryTypeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Surgery type deleted'**
  String get messageSurgeryTypeDeleted;

  /// No description provided for @messageSurgeryTypeAdded.
  ///
  /// In en, this message translates to:
  /// **'Surgery type added'**
  String get messageSurgeryTypeAdded;

  /// No description provided for @messageSurgeryTypeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Surgery type updated'**
  String get messageSurgeryTypeUpdated;

  /// No description provided for @messageSlotAdded.
  ///
  /// In en, this message translates to:
  /// **'Availability slot added'**
  String get messageSlotAdded;

  /// No description provided for @messageSlotUpdated.
  ///
  /// In en, this message translates to:
  /// **'Availability slot updated'**
  String get messageSlotUpdated;

  /// No description provided for @messageSlotDeleted.
  ///
  /// In en, this message translates to:
  /// **'Availability slot deleted'**
  String get messageSlotDeleted;

  /// No description provided for @patientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsTitle;

  /// No description provided for @patientsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search patients by name…'**
  String get patientsSearchHint;

  /// No description provided for @patientsFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load patients'**
  String get patientsFailedToLoad;

  /// No description provided for @patientsNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No patients found'**
  String get patientsNoneTitle;

  /// No description provided for @patientsNoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different search, or add a new patient.'**
  String get patientsNoneSubtitle;

  /// No description provided for @patientsAddPatient.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get patientsAddPatient;

  /// No description provided for @patientsAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get patientsAddSheetTitle;

  /// No description provided for @patientsEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Patient'**
  String get patientsEditSheetTitle;

  /// No description provided for @patientsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get patientsNameLabel;

  /// No description provided for @patientsNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get patientsNameRequired;

  /// No description provided for @patientsMrnLabel.
  ///
  /// In en, this message translates to:
  /// **'MRN'**
  String get patientsMrnLabel;

  /// No description provided for @patientsMrnRequired.
  ///
  /// In en, this message translates to:
  /// **'MRN is required'**
  String get patientsMrnRequired;

  /// No description provided for @patientsNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Medical notes (optional)'**
  String get patientsNotesLabel;

  /// No description provided for @patientsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String patientsDeleteTitle(String name);

  /// No description provided for @patientsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This also cancels/removes their scheduled surgeries. This cannot be undone.'**
  String get patientsDeleteBody;

  /// No description provided for @surgeryTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Surgery Types'**
  String get surgeryTypesTitle;

  /// No description provided for @surgeryTypesFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load surgery types'**
  String get surgeryTypesFailedToLoad;

  /// No description provided for @surgeryTypesNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No surgery types'**
  String get surgeryTypesNoneTitle;

  /// No description provided for @surgeryTypesNoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add one to start scheduling surgeries of this type.'**
  String get surgeryTypesNoneSubtitle;

  /// No description provided for @surgeryTypesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Surgery Type'**
  String get surgeryTypesAdd;

  /// No description provided for @surgeryTypesAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Surgery Type'**
  String get surgeryTypesAddSheetTitle;

  /// No description provided for @surgeryTypesEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Surgery Type'**
  String get surgeryTypesEditSheetTitle;

  /// No description provided for @surgeryTypesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get surgeryTypesNameLabel;

  /// No description provided for @surgeryTypesNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get surgeryTypesNameRequired;

  /// No description provided for @surgeryTypesDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Average duration (minutes)'**
  String get surgeryTypesDurationLabel;

  /// No description provided for @surgeryTypesDurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Duration is required'**
  String get surgeryTypesDurationRequired;

  /// No description provided for @surgeryTypesDurationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of minutes (5 or more)'**
  String get surgeryTypesDurationInvalid;

  /// No description provided for @surgeryTypesSpecialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Required specialty (optional)'**
  String get surgeryTypesSpecialtyLabel;

  /// No description provided for @surgeryTypesDefaultRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Default room (optional)'**
  String get surgeryTypesDefaultRoomLabel;

  /// No description provided for @surgeryTypesNoDefaultRoom.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get surgeryTypesNoDefaultRoom;

  /// No description provided for @surgeryTypesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String surgeryTypesDeleteTitle(String name);

  /// No description provided for @surgeryTypesDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get surgeryTypesDeleteBody;

  /// No description provided for @surgeryTypesDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String surgeryTypesDurationMinutes(int minutes);

  /// No description provided for @surgeryTypesDefaultRoomValue.
  ///
  /// In en, this message translates to:
  /// **'Default room: {name}'**
  String surgeryTypesDefaultRoomValue(String name);

  /// No description provided for @roomDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Details'**
  String get roomDetailTitle;

  /// No description provided for @roomDetailFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load room'**
  String get roomDetailFailedToLoad;

  /// No description provided for @roomDetailFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get roomDetailFilterToday;

  /// No description provided for @roomDetailFilterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get roomDetailFilterThisWeek;

  /// No description provided for @roomDetailFilterLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get roomDetailFilterLastWeek;

  /// No description provided for @roomDetailFilterCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get roomDetailFilterCustom;

  /// No description provided for @roomDetailFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get roomDetailFilterAll;

  /// No description provided for @roomDetailFilterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get roomDetailFilterThisMonth;

  /// No description provided for @roomDetailNoSurgeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'No surgeries in this range'**
  String get roomDetailNoSurgeriesTitle;

  /// No description provided for @roomDetailNoSurgeriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different date range.'**
  String get roomDetailNoSurgeriesSubtitle;

  /// No description provided for @roomDetailManageAvailability.
  ///
  /// In en, this message translates to:
  /// **'Manage availability'**
  String get roomDetailManageAvailability;

  /// No description provided for @roomDetailChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get roomDetailChangePhoto;

  /// No description provided for @roomDetailAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get roomDetailAddPhoto;

  /// No description provided for @roomSlotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Availability'**
  String get roomSlotsTitle;

  /// No description provided for @roomSlotsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rooms with no slots defined are bookable at any time.'**
  String get roomSlotsSubtitle;

  /// No description provided for @roomSlotsNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No availability slots'**
  String get roomSlotsNoneTitle;

  /// No description provided for @roomSlotsNoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This room is bookable at any time.'**
  String get roomSlotsNoneSubtitle;

  /// No description provided for @roomSlotsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Slot'**
  String get roomSlotsAdd;

  /// No description provided for @roomSlotsAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Availability Slot'**
  String get roomSlotsAddSheetTitle;

  /// No description provided for @roomSlotsDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day of week'**
  String get roomSlotsDayLabel;

  /// No description provided for @roomSlotsStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get roomSlotsStartLabel;

  /// No description provided for @roomSlotsEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get roomSlotsEndLabel;

  /// No description provided for @roomSlotsEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get roomSlotsEndBeforeStart;

  /// No description provided for @roomSlotsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this slot?'**
  String get roomSlotsDeleteTitle;

  /// No description provided for @roomSlotsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get roomSlotsDeleteBody;

  /// No description provided for @daySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get daySunday;

  /// No description provided for @dayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dayMonday;

  /// No description provided for @dayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dayTuesday;

  /// No description provided for @dayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dayWednesday;

  /// No description provided for @dayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dayThursday;

  /// No description provided for @dayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dayFriday;

  /// No description provided for @daySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get daySaturday;

  /// No description provided for @scheduleSurgeryDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated duration (minutes)'**
  String get scheduleSurgeryDurationLabel;

  /// No description provided for @scheduleSurgeryDurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Duration is required'**
  String get scheduleSurgeryDurationRequired;

  /// No description provided for @scheduleSurgeryDurationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of minutes (5 or more)'**
  String get scheduleSurgeryDurationInvalid;

  /// No description provided for @settingsNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsNavLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get settingsAbout;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get settingsTermsConditions;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutAppName.
  ///
  /// In en, this message translates to:
  /// **'Shifa (شفاء)'**
  String get aboutAppName;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Shifa is a hospital operating-room scheduling system designed to help hospital staff manage operating rooms, schedule surgeries efficiently, and coordinate in real time using smart scheduling optimization.'**
  String get aboutDescription;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDeveloperSection.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloperSection;

  /// No description provided for @aboutDeveloperName.
  ///
  /// In en, this message translates to:
  /// **'Mohamed Abdulrahman Alomari (محمد عبد الرحمن العمري)'**
  String get aboutDeveloperName;

  /// No description provided for @aboutDeveloperBlurb.
  ///
  /// In en, this message translates to:
  /// **'Developed by a Flutter developer specializing in clean architecture and scalable mobile applications.'**
  String get aboutDeveloperBlurb;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyTitle;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String privacyLastUpdated(String date);

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy explains what information Shifa collects and how it is used.'**
  String get privacyIntro;

  /// No description provided for @privacyCollectedHeading.
  ///
  /// In en, this message translates to:
  /// **'What data is collected'**
  String get privacyCollectedHeading;

  /// No description provided for @privacyCollectedBody.
  ///
  /// In en, this message translates to:
  /// **'We collect account information (name, email, role) and operational data needed to run the scheduling system (patient records, surgery schedules, room and staff assignments). All data stays within the hospital\'s own private backend and is never stored on third-party servers.'**
  String get privacyCollectedBody;

  /// No description provided for @privacyUsageHeading.
  ///
  /// In en, this message translates to:
  /// **'How data is used'**
  String get privacyUsageHeading;

  /// No description provided for @privacyUsageBody.
  ///
  /// In en, this message translates to:
  /// **'Data is used solely to operate and coordinate operating-room scheduling within the hospital — assigning rooms, tracking surgery status, and notifying relevant staff.'**
  String get privacyUsageBody;

  /// No description provided for @privacySharingHeading.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get privacySharingHeading;

  /// No description provided for @privacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'Data is not shared with any third party. It is only accessible to authorized hospital staff through this application.'**
  String get privacySharingBody;

  /// No description provided for @privacyStorageHeading.
  ///
  /// In en, this message translates to:
  /// **'Storage & security'**
  String get privacyStorageHeading;

  /// No description provided for @privacyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Data is stored securely on the hospital\'s own server infrastructure, protected by authenticated access and role-based permissions.'**
  String get privacyStorageBody;

  /// No description provided for @privacyContactHeading.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get privacyContactHeading;

  /// No description provided for @privacyContactBody.
  ///
  /// In en, this message translates to:
  /// **'For privacy concerns, contact mohamed.alomari.dev@gmail.com.'**
  String get privacyContactBody;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @termsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String termsLastUpdated(String date);

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'These Terms govern the use of the Shifa operating-room scheduling application.'**
  String get termsIntro;

  /// No description provided for @termsAuthorizedHeading.
  ///
  /// In en, this message translates to:
  /// **'Authorized use only'**
  String get termsAuthorizedHeading;

  /// No description provided for @termsAuthorizedBody.
  ///
  /// In en, this message translates to:
  /// **'This app is intended for authorized hospital staff only — admin, coordinator, and surgeon roles. Accounts are provisioned and managed by hospital administration.'**
  String get termsAuthorizedBody;

  /// No description provided for @termsAccuracyHeading.
  ///
  /// In en, this message translates to:
  /// **'Accuracy of information'**
  String get termsAccuracyHeading;

  /// No description provided for @termsAccuracyBody.
  ///
  /// In en, this message translates to:
  /// **'Users are responsible for the accuracy of the information they enter, including patient, surgery, and scheduling details.'**
  String get termsAccuracyBody;

  /// No description provided for @termsDecisionSupportHeading.
  ///
  /// In en, this message translates to:
  /// **'Decision support, not medical authority'**
  String get termsDecisionSupportHeading;

  /// No description provided for @termsDecisionSupportBody.
  ///
  /// In en, this message translates to:
  /// **'Scheduling suggestions produced by the app are decision-support tools only. Final medical and scheduling decisions remain the responsibility of hospital staff, not the application.'**
  String get termsDecisionSupportBody;

  /// No description provided for @termsAccountsHeading.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get termsAccountsHeading;

  /// No description provided for @termsAccountsBody.
  ///
  /// In en, this message translates to:
  /// **'Accounts are provisioned and managed by hospital administration. Users may not share credentials.'**
  String get termsAccountsBody;

  /// No description provided for @termsContactHeading.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get termsContactHeading;

  /// No description provided for @termsContactBody.
  ///
  /// In en, this message translates to:
  /// **'For questions about these terms, contact mohamed.alomari.dev@gmail.com.'**
  String get termsContactBody;

  /// No description provided for @aboutEmailAction.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutEmailAction;

  /// No description provided for @aboutPhoneAction.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get aboutPhoneAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
