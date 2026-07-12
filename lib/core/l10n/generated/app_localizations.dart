import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'OrganizeMyLife'**
  String get appName;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get navFinance;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep everything in sync'**
  String get authLoginSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginButton;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? {action}'**
  String authNoAccount(String action);

  /// No description provided for @authSignUpAction.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpAction;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignUpTitle;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a reset link to {email}'**
  String authResetPasswordSent(String email);

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authSendResetLink;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get authErrorEmailAlreadyInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak — use at least 6 characters'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Connection error — check your internet'**
  String get authErrorNetwork;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete the request'**
  String get authErrorUnknown;

  /// No description provided for @taskListTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get taskListTitle;

  /// No description provided for @taskAddNew.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskAddNew;

  /// No description provided for @taskEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Nothing to do yet — add your first task'**
  String get taskEmptyState;

  /// No description provided for @taskPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get taskPriorityLow;

  /// No description provided for @taskPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get taskPriorityMedium;

  /// No description provided for @taskPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get taskPriorityHigh;

  /// No description provided for @taskMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get taskMarkDone;

  /// No description provided for @taskDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String taskDueDate(String date);

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskTitleLabel;

  /// No description provided for @taskCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get taskCategoryLabel;

  /// No description provided for @taskDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date (optional)'**
  String get taskDueDateLabel;

  /// No description provided for @taskPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskPriorityLabel;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarAddEvent.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get calendarAddEvent;

  /// No description provided for @calendarNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events on this day'**
  String get calendarNoEvents;

  /// No description provided for @calendarFormatMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarFormatMonth;

  /// No description provided for @calendarFormatWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calendarFormatWeek;

  /// No description provided for @eventTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventTitleLabel;

  /// No description provided for @eventDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get eventDescriptionLabel;

  /// No description provided for @eventLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get eventLocationLabel;

  /// No description provided for @eventAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get eventAllDay;

  /// No description provided for @eventStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get eventStartLabel;

  /// No description provided for @eventEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get eventEndLabel;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminderTitle;

  /// No description provided for @reminderAddNew.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get reminderAddNew;

  /// No description provided for @reminderTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get reminderTitleLabel;

  /// No description provided for @reminderDateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get reminderDateTimeLabel;

  /// No description provided for @reminderEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet'**
  String get reminderEmptyState;

  /// No description provided for @financeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeTitle;

  /// No description provided for @financeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeIncome;

  /// No description provided for @financeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeExpense;

  /// No description provided for @financeBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get financeBalance;

  /// No description provided for @financeMonthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary'**
  String get financeMonthlySummary;

  /// No description provided for @financeAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get financeAddTransaction;

  /// No description provided for @financeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get financeCategory;

  /// No description provided for @financeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get financeAmount;

  /// No description provided for @financeNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions this month'**
  String get financeNoTransactions;

  /// No description provided for @financeDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get financeDescriptionLabel;

  /// No description provided for @financeDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get financeDateLabel;

  /// No description provided for @financeCategoryChartTitle.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get financeCategoryChartTitle;

  /// No description provided for @financeTrendChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get financeTrendChartTitle;

  /// No description provided for @financeNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get financeNoExpenses;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsProductivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get reportsProductivity;

  /// No description provided for @reportsFinanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Finance overview'**
  String get reportsFinanceOverview;

  /// No description provided for @reportsTasksTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reportsTasksTotal;

  /// No description provided for @reportsTasksDone.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get reportsTasksDone;

  /// No description provided for @reportsTasksPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reportsTasksPending;

  /// No description provided for @reportsCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get reportsCompletionRate;

  /// No description provided for @reportsTasksByPriority.
  ///
  /// In en, this message translates to:
  /// **'Pending by priority'**
  String get reportsTasksByPriority;

  /// No description provided for @reportsNoPendingTasks.
  ///
  /// In en, this message translates to:
  /// **'No pending tasks'**
  String get reportsNoPendingTasks;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogout;

  /// No description provided for @dashboardTasksSection.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get dashboardTasksSection;

  /// No description provided for @dashboardEventsSection.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get dashboardEventsSection;

  /// No description provided for @dashboardNoTasks.
  ///
  /// In en, this message translates to:
  /// **'Nothing pending today'**
  String get dashboardNoTasks;

  /// No description provided for @dashboardNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events today'**
  String get dashboardNoEvents;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

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

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
