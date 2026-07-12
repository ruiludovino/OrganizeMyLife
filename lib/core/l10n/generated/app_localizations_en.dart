// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'OrganizeMyLife';

  @override
  String get navToday => 'Today';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navFinance => 'Finance';

  @override
  String get navMore => 'More';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Sign in to keep everything in sync';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authForgotPassword => 'Forgot your password?';

  @override
  String authNoAccount(String action) {
    return 'Don\'t have an account? $action';
  }

  @override
  String get authSignUpAction => 'Sign up';

  @override
  String get authSignUpTitle => 'Create your account';

  @override
  String get authResetPasswordTitle => 'Reset password';

  @override
  String authResetPasswordSent(String email) {
    return 'We sent a reset link to $email';
  }

  @override
  String get authSendResetLink => 'Send reset link';

  @override
  String get authErrorInvalidCredentials => 'Incorrect email or password';

  @override
  String get authErrorEmailAlreadyInUse => 'This email is already registered';

  @override
  String get authErrorWeakPassword =>
      'Password is too weak — use at least 6 characters';

  @override
  String get authErrorUserNotFound => 'No account found with this email';

  @override
  String get authErrorNetwork => 'Connection error — check your internet';

  @override
  String get authErrorUnknown => 'Couldn\'t complete the request';

  @override
  String get taskListTitle => 'Tasks';

  @override
  String get taskAddNew => 'New task';

  @override
  String get taskEmptyState => 'Nothing to do yet — add your first task';

  @override
  String get taskPriorityLow => 'Low';

  @override
  String get taskPriorityMedium => 'Medium';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskMarkDone => 'Mark as done';

  @override
  String taskDueDate(String date) {
    return 'Due $date';
  }

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskCategoryLabel => 'Category (optional)';

  @override
  String get taskDueDateLabel => 'Due date (optional)';

  @override
  String get taskPriorityLabel => 'Priority';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarAddEvent => 'New event';

  @override
  String get calendarNoEvents => 'No events on this day';

  @override
  String get calendarFormatMonth => 'Month';

  @override
  String get calendarFormatWeek => 'Week';

  @override
  String get eventTitleLabel => 'Title';

  @override
  String get eventDescriptionLabel => 'Description (optional)';

  @override
  String get eventLocationLabel => 'Location (optional)';

  @override
  String get eventAllDay => 'All day';

  @override
  String get eventStartLabel => 'Start';

  @override
  String get eventEndLabel => 'End';

  @override
  String get reminderTitle => 'Reminders';

  @override
  String get reminderAddNew => 'New reminder';

  @override
  String get reminderTitleLabel => 'Title';

  @override
  String get reminderDateTimeLabel => 'Date and time';

  @override
  String get reminderEmptyState => 'No reminders yet';

  @override
  String get financeTitle => 'Finance';

  @override
  String get financeIncome => 'Income';

  @override
  String get financeExpense => 'Expense';

  @override
  String get financeBalance => 'Balance';

  @override
  String get financeMonthlySummary => 'Monthly summary';

  @override
  String get financeAddTransaction => 'Add transaction';

  @override
  String get financeCategory => 'Category';

  @override
  String get financeAmount => 'Amount';

  @override
  String get financeNoTransactions => 'No transactions this month';

  @override
  String get financeDescriptionLabel => 'Description';

  @override
  String get financeDateLabel => 'Date';

  @override
  String get financeCategoryChartTitle => 'By category';

  @override
  String get financeTrendChartTitle => 'Last 6 months';

  @override
  String get financeNoExpenses => 'No expenses this month';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsProductivity => 'Productivity';

  @override
  String get reportsFinanceOverview => 'Finance overview';

  @override
  String get reportsTasksTotal => 'Total';

  @override
  String get reportsTasksDone => 'Completed';

  @override
  String get reportsTasksPending => 'Pending';

  @override
  String get reportsCompletionRate => 'Completion rate';

  @override
  String get reportsTasksByPriority => 'Pending by priority';

  @override
  String get reportsNoPendingTasks => 'No pending tasks';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsLogout => 'Log out';

  @override
  String get dashboardTasksSection => 'Today\'s tasks';

  @override
  String get dashboardEventsSection => 'Today\'s schedule';

  @override
  String get dashboardNoTasks => 'Nothing pending today';

  @override
  String get dashboardNoEvents => 'No events today';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonRetry => 'Try again';
}
