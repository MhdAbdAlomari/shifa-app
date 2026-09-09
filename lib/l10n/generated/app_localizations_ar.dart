// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'شفاء';

  @override
  String get errorUnauthenticated =>
      'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorRoleForbidden => 'ليس لديك صلاحية للقيام بذلك.';

  @override
  String get errorUnauthorized => 'غير مصرّح لك بالقيام بذلك.';

  @override
  String get errorNotFound => 'تعذّر العثور على هذا العنصر. ربما تمت إزالته.';

  @override
  String get errorMethodNotAllowed => 'هذا الإجراء غير مدعوم حاليًا.';

  @override
  String get errorValidationFailed =>
      'يرجى مراجعة الحقول المحددة والمحاولة مرة أخرى.';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errorSurgeryNotOwned => 'يمكنك فقط القيام بذلك لعملياتك الخاصة.';

  @override
  String get errorSurgeryTimeConflict =>
      'هذه الغرفة محجوزة بالفعل في هذا الوقت.';

  @override
  String get errorRoomAvailabilityWindowViolation =>
      'هذا الوقت خارج ساعات إتاحة هذه الغرفة.';

  @override
  String get errorSurgeryNotInProgress =>
      'يتطلب هذا الإجراء أن تكون العملية جارية حاليًا.';

  @override
  String get errorSuggestionNotPending => 'تمت معالجة هذا الاقتراح بالفعل.';

  @override
  String get errorNotificationNotOwned => 'يمكنك فقط إدارة إشعاراتك الخاصة.';

  @override
  String get errorSlotRoomMismatch =>
      'فترة الإتاحة هذه لا تنتمي إلى هذه الغرفة.';

  @override
  String get errorSlotInvalidTimeRange =>
      'يجب أن يكون وقت الانتهاء بعد وقت البدء.';

  @override
  String get errorGeneric => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get appTagline => 'غرف العمليات';

  @override
  String get navRooms => 'الغرف';

  @override
  String get navStaff => 'الطاقم';

  @override
  String get navAlerts => 'التنبيهات';

  @override
  String get navSuggestions => 'الاقتراحات';

  @override
  String get navSchedule => 'الجدولة';

  @override
  String get navSurgeries => 'العمليات';

  @override
  String get navManage => 'الإدارة';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get manageTitle => 'الإدارة';

  @override
  String get manageSubtitle => 'الغرف، الطاقم، المرضى، وأنواع العمليات';

  @override
  String get manageRoomsSubtitle => 'عرض وإضافة وضبط غرف العمليات';

  @override
  String get manageStaffSubtitle => 'عرض وإضافة وتعديل المنسقين والجراحين';

  @override
  String get managePatientsSubtitle =>
      'البحث عن المرضى وإضافتهم وتعديل بياناتهم';

  @override
  String get manageSurgeryTypesSubtitle =>
      'ضبط الإجراءات والمدد والغرف الافتراضية';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonRemove => 'إزالة';

  @override
  String get commonTryAgain => 'إعادة المحاولة';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonUnknown => 'غير معروف';

  @override
  String get commonNotAvailable => '—';

  @override
  String get subtitleOrSchedule => 'جدولة غرف العمليات';

  @override
  String get subtitleMySurgeries => 'عملياتي';

  @override
  String get subtitleClinicalAlerts => 'التنبيهات السريرية';

  @override
  String get subtitleDelaySuggestions => 'اقتراحات التأخير';

  @override
  String get subtitleSettings => 'الإعدادات';

  @override
  String get notificationsTooltip => 'الإشعارات';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get loginTitle => 'شفاء';

  @override
  String get loginSubtitle =>
      'سجّل الدخول لإدارة جدول غرف العمليات لهذا اليوم.';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني';

  @override
  String get loginEmailHint => 'you@shifa.test';

  @override
  String get loginEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get loginEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get roomTimelineTitle => 'جدول الغرف الزمني';

  @override
  String roomTimelineSuitesMonitored(int count) {
    return '$count غرفة تحت المراقبة';
  }

  @override
  String get roomTimelineNoRooms => 'لا توجد غرف عمليات';

  @override
  String get roomTimelineNoRoomsSubtitle =>
      'يرجى التواصل مع المسؤول لإضافة غرف.';

  @override
  String get roomTimelineFailedToLoad => 'تعذّر تحميل الجدول الزمني';

  @override
  String get roomTimelineScheduleSurgery => 'جدولة عملية';

  @override
  String roomTimelineOr(int id) {
    return 'غرفة $id';
  }

  @override
  String roomTimelinePatientNumber(int id) {
    return 'مريض رقم $id';
  }

  @override
  String get roomTimelineSurgeryFallback => 'عملية جراحية';

  @override
  String get roomTimelineEnds => 'تنتهي';

  @override
  String get roomTimelineNext => 'التالي';

  @override
  String get roomTimelineStatus => 'الحالة';

  @override
  String get roomTimelineVacantReady => 'متاحة وجاهزة';

  @override
  String get roomTimelineVacantReadySubtitle => 'جاهزة لاستقبال حالة فورًا';

  @override
  String get roomTimelinePreparing => 'قيد التحضير';

  @override
  String get roomTimelinePreparingSubtitle => 'يتم تجهيز الغرفة حاليًا';

  @override
  String get roomTimelineTurnover => 'قيد التنظيف بين الحالات';

  @override
  String get roomTimelineTurnoverSubtitle => 'خدمات النظافة البيئية';

  @override
  String get roomTimelineInUse => 'مشغولة';

  @override
  String get roomTimelineInUseSubtitle => 'لا توجد حالة مسندة في الجدول';

  @override
  String get roomTimelineUnknownStatusSubtitle => 'حالة الغرفة غير محددة';

  @override
  String get roomTimelineAvailable => 'متاحة';

  @override
  String get roomTimelineCleaning => 'التنظيف';

  @override
  String get statusCompleted => 'مكتملة';

  @override
  String get statusCancelled => 'ملغاة';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusAccepted => 'مقبولة';

  @override
  String get statusRejected => 'مرفوضة';

  @override
  String get scheduleSurgeryTitle => 'عملية جديدة';

  @override
  String get scheduleSurgerySubtitle => 'جدولة الحالة وتخصيص غرفة العمليات';

  @override
  String get scheduleSurgeryFailedToLoad => 'تعذّر تحميل النموذج';

  @override
  String get scheduleSurgeryMissingSetupTitle => 'بيانات الإعداد ناقصة';

  @override
  String get scheduleSurgeryMissingSetupSubtitle =>
      'يرجى التواصل مع المسؤول لإضافة المرضى والجراحين وأنواع العمليات قبل الجدولة.';

  @override
  String get scheduleSurgeryPatientLabel => 'المريض';

  @override
  String get scheduleSurgeryPatientHint => 'اختر مريضًا';

  @override
  String get scheduleSurgerySurgeonLabel => 'الجراح';

  @override
  String get scheduleSurgerySurgeonHint => 'اختر جراحًا';

  @override
  String get scheduleSurgeryTypeLabel => 'نوع العملية';

  @override
  String get scheduleSurgeryTypeHint => 'اختر النوع';

  @override
  String scheduleSurgeryTypeDuration(String name, int minutes) {
    return '$name ($minutes دقيقة)';
  }

  @override
  String get scheduleSurgeryPriorityLabel => 'مستوى الأولوية';

  @override
  String get scheduleSurgeryPriorityNormal => 'عادية';

  @override
  String get scheduleSurgeryPriorityEmergency => 'طارئة';

  @override
  String get scheduleSurgeryAutoSchedule => 'جدولة تلقائية';

  @override
  String get scheduleSurgeryPickManually => 'اختيار يدوي';

  @override
  String get pickManuallyTitle => 'اختيار يدوي';

  @override
  String get pickManuallySubtitle => 'اختر الغرفة ووقت البدء';

  @override
  String get pickManuallyFailedToLoad => 'تعذّر تحميل الغرف';

  @override
  String get pickManuallyOperatingRoom => 'غرفة العمليات';

  @override
  String get pickManuallyScheduledStart => 'وقت البدء المجدول';

  @override
  String get pickManuallyPickDateTime => 'اختر التاريخ والوقت';

  @override
  String get pickManuallyConfirm => 'تأكيد الجدولة';

  @override
  String get pickManuallyScheduled => 'تمت جدولة العملية';

  @override
  String get autoScheduleTitle => 'اقتراحات الجدولة التلقائية';

  @override
  String get autoScheduleSubtitle =>
      'أفضل مواعيد الغرف بناءً على توفر الجراحين';

  @override
  String get autoScheduleFailedToLoad => 'تعذّر تحميل الخيارات';

  @override
  String get autoScheduleNoPendingTitle => 'لا توجد طلبات معلّقة';

  @override
  String get autoScheduleNoPendingSubtitle =>
      'أضف عملية أو أكثر لجدولتها تلقائيًا كدفعة واحدة.';

  @override
  String get autoScheduleAddRequest => 'إضافة طلب';

  @override
  String get autoScheduleAddRequestFirst => 'أضف طلبًا أولاً';

  @override
  String autoScheduleGenerateProposals(int count) {
    return 'إنشاء مقترحات ($count)';
  }

  @override
  String get autoScheduleAddSheetTitle => 'إضافة طلب معلّق';

  @override
  String get autoScheduleAddToBatch => 'إضافة إلى الدفعة';

  @override
  String get autoScheduleAllActionedTitle => 'تمت معالجة جميع المقترحات';

  @override
  String autoScheduleAllActionedSubtitle(int accepted, int skipped) {
    return 'تمت جدولة $accepted، وتخطي $skipped.';
  }

  @override
  String get autoScheduleStartNewBatch => 'بدء دفعة جديدة';

  @override
  String get autoScheduleAccept => 'قبول';

  @override
  String get autoScheduleReject => 'رفض';

  @override
  String get autoScheduleToday => 'اليوم';

  @override
  String get autoScheduleTomorrow => 'غدًا';

  @override
  String get delaySuggestionsTitle => 'معالجة التأخيرات';

  @override
  String get delaySuggestionsNonePending => 'لا توجد تعديلات معلّقة';

  @override
  String delaySuggestionsPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تعديل معلّق',
      many: '$count تعديلاً معلّقًا',
      few: '$count تعديلات معلّقة',
      two: 'تعديلان معلّقان',
      one: 'تعديل واحد معلّق',
    );
    return '$_temp0';
  }

  @override
  String get delaySuggestionsActiveOverrun => 'تجاوز نشط في الوقت';

  @override
  String get delaySuggestionsFailedToLoad => 'تعذّر تحميل الاقتراحات';

  @override
  String get delaySuggestionsNoneTitle => 'لا توجد اقتراحات معلّقة';

  @override
  String get delaySuggestionsNoneSubtitle => 'لا يوجد شيء بانتظارك حاليًا.';

  @override
  String delaySuggestionsSurgeryNumber(int id) {
    return 'عملية رقم $id';
  }

  @override
  String delaySuggestionsRoomNumber(int id) {
    return 'غرفة رقم $id';
  }

  @override
  String get roomsListTitle => 'غرف العمليات';

  @override
  String roomsListSuitesConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غرفة مُعدّة',
      many: '$count غرفة مُعدّة',
      few: '$count غرف مُعدّة',
      two: 'غرفتان مُعدّتان',
      one: 'غرفة واحدة مُعدّة',
    );
    return '$_temp0';
  }

  @override
  String roomsListFilterAll(int count) {
    return 'جميع الغرف ($count)';
  }

  @override
  String roomsListFilterInUse(int count) {
    return 'مشغولة ($count)';
  }

  @override
  String roomsListFilterFree(int count) {
    return 'متاحة ($count)';
  }

  @override
  String roomsListFilterPreparing(int count) {
    return 'قيد التحضير ($count)';
  }

  @override
  String roomsListFilterCleaning(int count) {
    return 'التنظيف ($count)';
  }

  @override
  String get roomsListFailedToLoad => 'تعذّر تحميل الغرف';

  @override
  String get roomsListNoMatchTitle => 'لا توجد غرف مطابقة';

  @override
  String get roomsListNoMatchSubtitle => 'جرّب مرشحًا مختلفًا.';

  @override
  String get roomsListAddRoom => 'إضافة غرفة';

  @override
  String roomsListDeleteTitle(String name) {
    return 'حذف $name؟';
  }

  @override
  String get roomsListDeleteBody => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get roomsListAddSheetTitle => 'إضافة غرفة عمليات';

  @override
  String get roomsListEditSheetTitle => 'تعديل غرفة العمليات';

  @override
  String get roomsListNameLabel => 'الاسم (مثال: OR-6)';

  @override
  String get roomsListNameRequired => 'الاسم مطلوب';

  @override
  String get roomsListSpecialtyLabel => 'التخصص المدعوم (اختياري)';

  @override
  String get roomsListInitialStatusLabel => 'الحالة الأولية';

  @override
  String get roomsListStatusFree => 'متاحة';

  @override
  String get roomsListStatusPreparing => 'قيد التحضير';

  @override
  String get roomsListStatusInUse => 'مشغولة';

  @override
  String get roomsListStatusCleaning => 'التنظيف';

  @override
  String get staffListTitle => 'دليل الطاقم';

  @override
  String get staffListSubtitle => 'نظرة عامة على غرف العمليات والطاقم السريري';

  @override
  String staffListActiveCount(int count) {
    return '$count نشط';
  }

  @override
  String get staffListSearchHint => 'تصفية حسب الاسم أو البريد أو التخصص…';

  @override
  String staffListFilterAll(int count) {
    return 'الكل ($count)';
  }

  @override
  String staffListFilterSurgeons(int count) {
    return 'الجراحون ($count)';
  }

  @override
  String staffListFilterCoordinators(int count) {
    return 'المنسقون ($count)';
  }

  @override
  String get staffListFailedToLoad => 'تعذّر تحميل الطاقم';

  @override
  String get staffListNoMatchTitle => 'لا يوجد طاقم مطابق';

  @override
  String get staffListNoMatchSubtitle =>
      'جرّب مرشحًا مختلفًا أو كلمة بحث أخرى.';

  @override
  String get staffListAddStaff => 'إضافة عضو';

  @override
  String staffListRemoveTitle(String name) {
    return 'إزالة $name؟';
  }

  @override
  String get staffListRemoveBody =>
      'إذا كان لدى هذا المستخدم عمليات مجدولة، ستفشل عملية الإزالة.';

  @override
  String get staffListAddSheetTitle => 'إضافة عضو طاقم';

  @override
  String get staffListNameLabel => 'الاسم الكامل';

  @override
  String get staffListNameRequired => 'الاسم مطلوب';

  @override
  String get staffListEmailLabel => 'البريد الإلكتروني';

  @override
  String get staffListEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get staffListEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get staffListPasswordLabel => 'كلمة المرور';

  @override
  String get staffListPasswordHint => '8 أحرف على الأقل';

  @override
  String get staffListPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get staffListPasswordTooShort => 'الحد الأدنى 8 أحرف';

  @override
  String get staffListRoleLabel => 'الدور';

  @override
  String get staffListRoleCoordinator => 'منسّق';

  @override
  String get staffListRoleSurgeon => 'جراح';

  @override
  String get staffListRoleAdmin => 'مسؤول';

  @override
  String get staffListSpecialtyLabel => 'التخصص';

  @override
  String get staffListSpecialtyRequired => 'التخصص مطلوب للجراحين';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String notificationsNewCount(int count) {
    return '$count جديد';
  }

  @override
  String get notificationsMarkAllRead => 'تعليم الكل كمقروء';

  @override
  String get notificationsFailedToLoad => 'تعذّر تحميل الإشعارات';

  @override
  String get notificationsNoneTitle => 'لا توجد إشعارات';

  @override
  String get notificationsNoneSubtitle =>
      'ستظهر هنا التحديثات المتعلقة بعملياتك.';

  @override
  String get notificationsJustNow => 'الآن';

  @override
  String notificationsMinutesAgo(int count) {
    return 'منذ $count د';
  }

  @override
  String notificationsHoursAgo(int count) {
    return 'منذ $count س';
  }

  @override
  String notificationsDaysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String get mySurgeriesTitle => 'عملياتي';

  @override
  String mySurgeriesToday(String date) {
    return 'اليوم، $date';
  }

  @override
  String get mySurgeriesScheduledToday => 'المجدولة اليوم';

  @override
  String mySurgeriesCasesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حالة',
      many: '$count حالة',
      few: '$count حالات',
      two: 'حالتان',
      one: 'حالة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get mySurgeriesCurrentStatus => 'الحالة الحالية';

  @override
  String get mySurgeriesDelayed => 'متأخرة';

  @override
  String get mySurgeriesOnSchedule => 'ضمن الجدول';

  @override
  String get mySurgeriesNoneTitle => 'لا توجد عمليات مسندة اليوم';

  @override
  String get mySurgeriesNoneSubtitle => 'لا يوجد شيء في قائمتك الآن.';

  @override
  String get mySurgeriesFailedToLoad => 'تعذّر تحميل عملياتك';

  @override
  String get mySurgeriesInProgress => 'جارية الآن';

  @override
  String get mySurgeriesNextUp => 'التالية';

  @override
  String get mySurgeriesUpcomingCase => 'حالة قادمة';

  @override
  String get mySurgeriesStartSurgery => 'بدء العملية';

  @override
  String mySurgeriesPatientNumber(int id) {
    return 'مريض رقم $id';
  }

  @override
  String mySurgeriesRoomNumber(int id) {
    return 'غرفة رقم $id';
  }

  @override
  String get surgeryDetailTitle => 'تفاصيل العملية';

  @override
  String get surgeryDetailFailedToLoad => 'تعذّر تحميل العملية';

  @override
  String surgeryDetailPatientNumber(int id) {
    return 'مريض رقم $id';
  }

  @override
  String surgeryDetailMrn(String mrn) {
    return 'رقم الملف الطبي $mrn';
  }

  @override
  String get surgeryDetailProcedure => 'الإجراء';

  @override
  String get surgeryDetailSurgeryFallback => 'عملية جراحية';

  @override
  String get surgeryDetailAssignedSuite => 'الغرفة المخصصة';

  @override
  String surgeryDetailRoomNumber(int id) {
    return 'غرفة رقم $id';
  }

  @override
  String get surgeryDetailTargetPace => 'المدة المستهدفة';

  @override
  String surgeryDetailMinutesShort(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get surgeryDetailScheduledSlot => 'الموعد المجدول';

  @override
  String get surgeryDetailActualTime => 'الوقت الفعلي';

  @override
  String surgeryDetailInProgressStarted(String time) {
    return 'جارية الآن (بدأت الساعة $time)';
  }

  @override
  String surgeryDetailEnded(String time) {
    return 'انتهت الساعة $time';
  }

  @override
  String surgeryDetailEstimatedDuration(int minutes) {
    return 'المدة المقدّرة $minutes دقيقة';
  }

  @override
  String get surgeryDetailStartSurgery => 'بدء العملية';

  @override
  String get surgeryDetailReportDelay => 'الإبلاغ عن تأخير';

  @override
  String get delayFormTitle => 'الإبلاغ عن تأخير';

  @override
  String get delayFormNewEndLabel => 'وقت الانتهاء المتوقع الجديد';

  @override
  String get delayFormNewEndHint => 'اختر التاريخ والوقت';

  @override
  String get delayFormNewEndRequired => 'اختر وقت انتهاء متوقعًا جديدًا';

  @override
  String get delayFormReasonLabel => 'السبب';

  @override
  String get delayFormReasonHint => 'ما سبب التأخير؟';

  @override
  String get delayFormReasonRequired => 'السبب مطلوب';

  @override
  String get delayFormSubmit => 'إرسال تقرير التأخير';

  @override
  String get delayResultAutoApprovedTitle =>
      'تمت الموافقة على التأخير تلقائيًا';

  @override
  String get delayResultPendingTitle => 'التأخير بانتظار مراجعة المنسّق';

  @override
  String get delayResultDismiss => 'إغلاق';

  @override
  String delayResultAutoApprovedBody(String newEnd) {
    return 'لا يتعارض وقت الانتهاء الجديد مع أي عملية أخرى في هذه الغرفة. ستستمر هذه العملية الآن حتى $newEnd.';
  }

  @override
  String delayResultPendingBody(int surgeryId, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم توليد $count اقتراح',
      many: 'تم توليد $count اقتراحًا',
      few: 'تم توليد $count اقتراحات',
      two: 'تم توليد اقتراحين',
      one: 'تم توليد اقتراح واحد',
      zero: 'لم يتم توليد أي اقتراحات',
    );
    return 'تمديد هذه العملية يتعارض مع العملية رقم $surgeryId في نفس الغرفة. $_temp0 للعمليات المتأثرة اللاحقة.';
  }

  @override
  String get surgeryDetailMarkComplete => 'تعليم كمكتملة';

  @override
  String get surgeryDetailCancelSurgery => 'إلغاء العملية';

  @override
  String get messageRoomDeleted => 'تم حذف الغرفة';

  @override
  String get messageRoomAdded => 'تمت إضافة الغرفة';

  @override
  String get messageRoomUpdated => 'تم تحديث الغرفة';

  @override
  String get messageStaffDeleted => 'تم حذف عضو الطاقم';

  @override
  String get messageStaffAdded => 'تمت إضافة عضو الطاقم';

  @override
  String get messageStaffUpdated => 'تم تحديث بيانات العضو';

  @override
  String get messageSurgeryStarted => 'بدأت العملية';

  @override
  String get messageSurgeryCancelled => 'تم إلغاء العملية';

  @override
  String get messagePatientDeleted => 'تم حذف المريض';

  @override
  String get messagePatientAdded => 'تمت إضافة المريض';

  @override
  String get messagePatientUpdated => 'تم تحديث بيانات المريض';

  @override
  String get messageSurgeryTypeDeleted => 'تم حذف نوع العملية';

  @override
  String get messageSurgeryTypeAdded => 'تمت إضافة نوع العملية';

  @override
  String get messageSurgeryTypeUpdated => 'تم تحديث نوع العملية';

  @override
  String get messageSlotAdded => 'تمت إضافة فترة الإتاحة';

  @override
  String get messageSlotUpdated => 'تم تحديث فترة الإتاحة';

  @override
  String get messageSlotDeleted => 'تم حذف فترة الإتاحة';

  @override
  String get patientsTitle => 'المرضى';

  @override
  String get patientsSearchHint => 'ابحث عن مريض بالاسم…';

  @override
  String get patientsFailedToLoad => 'تعذّر تحميل المرضى';

  @override
  String get patientsNoneTitle => 'لا يوجد مرضى';

  @override
  String get patientsNoneSubtitle =>
      'جرّب بحثًا مختلفًا، أو أضف مريضًا جديدًا.';

  @override
  String get patientsAddPatient => 'إضافة مريض';

  @override
  String get patientsAddSheetTitle => 'إضافة مريض';

  @override
  String get patientsEditSheetTitle => 'تعديل بيانات المريض';

  @override
  String get patientsNameLabel => 'الاسم الكامل';

  @override
  String get patientsNameRequired => 'الاسم مطلوب';

  @override
  String get patientsMrnLabel => 'الرقم الطبي (MRN)';

  @override
  String get patientsMrnRequired => 'الرقم الطبي مطلوب';

  @override
  String get patientsNotesLabel => 'ملاحظات طبية (اختياري)';

  @override
  String patientsDeleteTitle(String name) {
    return 'حذف $name؟';
  }

  @override
  String get patientsDeleteBody =>
      'سيؤدي هذا أيضًا إلى إلغاء/إزالة عملياته المجدولة. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get surgeryTypesTitle => 'أنواع العمليات';

  @override
  String get surgeryTypesFailedToLoad => 'تعذّر تحميل أنواع العمليات';

  @override
  String get surgeryTypesNoneTitle => 'لا توجد أنواع عمليات';

  @override
  String get surgeryTypesNoneSubtitle =>
      'أضف نوعًا لبدء جدولة عمليات من هذا النوع.';

  @override
  String get surgeryTypesAdd => 'إضافة نوع عملية';

  @override
  String get surgeryTypesAddSheetTitle => 'إضافة نوع عملية';

  @override
  String get surgeryTypesEditSheetTitle => 'تعديل نوع العملية';

  @override
  String get surgeryTypesNameLabel => 'الاسم';

  @override
  String get surgeryTypesNameRequired => 'الاسم مطلوب';

  @override
  String get surgeryTypesDurationLabel => 'متوسط المدة (بالدقائق)';

  @override
  String get surgeryTypesDurationRequired => 'المدة مطلوبة';

  @override
  String get surgeryTypesDurationInvalid =>
      'أدخل عددًا صحيحًا من الدقائق (5 أو أكثر)';

  @override
  String get surgeryTypesSpecialtyLabel => 'التخصص المطلوب (اختياري)';

  @override
  String get surgeryTypesDefaultRoomLabel => 'الغرفة الافتراضية (اختياري)';

  @override
  String get surgeryTypesNoDefaultRoom => 'بلا';

  @override
  String surgeryTypesDeleteTitle(String name) {
    return 'حذف $name؟';
  }

  @override
  String get surgeryTypesDeleteBody => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String surgeryTypesDurationMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String surgeryTypesDefaultRoomValue(String name) {
    return 'الغرفة الافتراضية: $name';
  }

  @override
  String get roomDetailTitle => 'تفاصيل الغرفة';

  @override
  String get roomDetailFailedToLoad => 'تعذّر تحميل الغرفة';

  @override
  String get roomDetailFilterToday => 'اليوم';

  @override
  String get roomDetailFilterThisWeek => 'هذا الأسبوع';

  @override
  String get roomDetailFilterLastWeek => 'الأسبوع الماضي';

  @override
  String get roomDetailFilterCustom => 'نطاق مخصص';

  @override
  String get roomDetailFilterAll => 'الكل';

  @override
  String get roomDetailFilterThisMonth => 'هذا الشهر';

  @override
  String get roomDetailNoSurgeriesTitle => 'لا توجد عمليات في هذا النطاق';

  @override
  String get roomDetailNoSurgeriesSubtitle => 'جرّب نطاق تاريخ مختلفًا.';

  @override
  String get roomDetailManageAvailability => 'إدارة الإتاحة';

  @override
  String get roomDetailChangePhoto => 'تغيير الصورة';

  @override
  String get roomDetailAddPhoto => 'إضافة صورة';

  @override
  String get roomSlotsTitle => 'الإتاحة الأسبوعية';

  @override
  String get roomSlotsSubtitle =>
      'الغرف التي لا تحتوي على فترات محددة متاحة في أي وقت.';

  @override
  String get roomSlotsNoneTitle => 'لا توجد فترات إتاحة';

  @override
  String get roomSlotsNoneSubtitle => 'هذه الغرفة متاحة في أي وقت.';

  @override
  String get roomSlotsAdd => 'إضافة فترة';

  @override
  String get roomSlotsAddSheetTitle => 'إضافة فترة إتاحة';

  @override
  String get roomSlotsDayLabel => 'يوم الأسبوع';

  @override
  String get roomSlotsStartLabel => 'وقت البدء';

  @override
  String get roomSlotsEndLabel => 'وقت الانتهاء';

  @override
  String get roomSlotsEndBeforeStart =>
      'يجب أن يكون وقت الانتهاء بعد وقت البدء';

  @override
  String get roomSlotsDeleteTitle => 'حذف هذه الفترة؟';

  @override
  String get roomSlotsDeleteBody => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get daySunday => 'الأحد';

  @override
  String get dayMonday => 'الاثنين';

  @override
  String get dayTuesday => 'الثلاثاء';

  @override
  String get dayWednesday => 'الأربعاء';

  @override
  String get dayThursday => 'الخميس';

  @override
  String get dayFriday => 'الجمعة';

  @override
  String get daySaturday => 'السبت';

  @override
  String get scheduleSurgeryDurationLabel => 'المدة المقدّرة (بالدقائق)';

  @override
  String get scheduleSurgeryDurationRequired => 'المدة مطلوبة';

  @override
  String get scheduleSurgeryDurationInvalid =>
      'أدخل عددًا صحيحًا من الدقائق (5 أو أكثر)';

  @override
  String get settingsNavLabel => 'الإعدادات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguageSection => 'اللغة';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsTermsConditions => 'الشروط والأحكام';

  @override
  String get settingsLogout => 'تسجيل الخروج';

  @override
  String get aboutTitle => 'حول التطبيق';

  @override
  String get aboutAppName => 'شفاء (Shifa)';

  @override
  String get aboutDescription =>
      'شفاء هو نظام لإدارة وجدولة غرف العمليات الجراحية، مصمم لمساعدة الطاقم الطبي على إدارة غرف العمليات، وجدولة العمليات بكفاءة، والتنسيق اللحظي باستخدام خوارزمية جدولة ذكية.';

  @override
  String aboutVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get aboutDeveloperSection => 'المطوّر';

  @override
  String get aboutDeveloperName =>
      'محمد عبد الرحمن العمري (Mohamed Abdulrahman Alomari)';

  @override
  String get aboutDeveloperBlurb =>
      'تم تطويره من قبل مطور Flutter متخصص في البنية المعمارية النظيفة وتطبيقات الموبايل القابلة للتوسع.';

  @override
  String get privacyTitle => 'سياسة الخصوصية';

  @override
  String privacyLastUpdated(String date) {
    return 'آخر تحديث: $date';
  }

  @override
  String get privacyIntro =>
      'توضح سياسة الخصوصية هذه البيانات التي يجمعها تطبيق شفاء وكيفية استخدامها.';

  @override
  String get privacyCollectedHeading => 'البيانات التي يتم جمعها';

  @override
  String get privacyCollectedBody =>
      'نقوم بجمع معلومات الحساب (الاسم، البريد الإلكتروني، الدور الوظيفي) والبيانات التشغيلية اللازمة لتشغيل نظام الجدولة (سجلات المرضى، جداول العمليات، تخصيص الغرف والطاقم). تبقى جميع البيانات ضمن الخادم الخاص بالمستشفى ولا تُخزَّن أبدًا على خوادم خارجية.';

  @override
  String get privacyUsageHeading => 'كيفية استخدام البيانات';

  @override
  String get privacyUsageBody =>
      'تُستخدم البيانات حصريًا لتشغيل وتنسيق جدولة غرف العمليات داخل المستشفى — تخصيص الغرف، ومتابعة حالة العمليات، وإشعار الطاقم المعني.';

  @override
  String get privacySharingHeading => 'المشاركة';

  @override
  String get privacySharingBody =>
      'لا تتم مشاركة البيانات مع أي طرف خارجي. يقتصر الوصول إليها على الطاقم المصرّح له داخل المستشفى عبر هذا التطبيق.';

  @override
  String get privacyStorageHeading => 'التخزين والأمان';

  @override
  String get privacyStorageBody =>
      'تُخزَّن البيانات بأمان على البنية التحتية الخاصة بخادم المستشفى، وتُحمى عبر آليات مصادقة الدخول وصلاحيات محددة حسب الدور الوظيفي.';

  @override
  String get privacyContactHeading => 'التواصل';

  @override
  String get privacyContactBody =>
      'لأي استفسارات تتعلق بالخصوصية، يرجى التواصل عبر mohamed.alomari.dev@gmail.com.';

  @override
  String get termsTitle => 'الشروط والأحكام';

  @override
  String termsLastUpdated(String date) {
    return 'آخر تحديث: $date';
  }

  @override
  String get termsIntro =>
      'تحكم هذه الشروط استخدام تطبيق شفاء لجدولة غرف العمليات.';

  @override
  String get termsAuthorizedHeading => 'الاستخدام المصرّح به فقط';

  @override
  String get termsAuthorizedBody =>
      'هذا التطبيق مخصص لطاقم المستشفى المصرّح له فقط — أدوار المسؤول والمنسّق والجراح. يتم إنشاء الحسابات وإدارتها من قبل إدارة المستشفى.';

  @override
  String get termsAccuracyHeading => 'دقة المعلومات';

  @override
  String get termsAccuracyBody =>
      'يتحمل المستخدمون مسؤولية دقة المعلومات التي يُدخلونها، بما في ذلك بيانات المرضى والعمليات والجدولة.';

  @override
  String get termsDecisionSupportHeading => 'أداة دعم قرار، لا سلطة طبية';

  @override
  String get termsDecisionSupportBody =>
      'اقتراحات الجدولة التي ينتجها التطبيق هي أدوات دعم قرار فقط. تبقى القرارات الطبية وقرارات الجدولة النهائية من مسؤولية طاقم المستشفى، وليس التطبيق.';

  @override
  String get termsAccountsHeading => 'الحسابات';

  @override
  String get termsAccountsBody =>
      'يتم إنشاء الحسابات وإدارتها من قبل إدارة المستشفى. لا يجوز للمستخدمين مشاركة بيانات الدخول الخاصة بهم.';

  @override
  String get termsContactHeading => 'التواصل';

  @override
  String get termsContactBody =>
      'لأي استفسارات حول هذه الشروط، يرجى التواصل عبر mohamed.alomari.dev@gmail.com.';

  @override
  String get aboutEmailAction => 'بريد إلكتروني';

  @override
  String get aboutPhoneAction => 'اتصال';
}
