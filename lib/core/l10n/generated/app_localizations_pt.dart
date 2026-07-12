// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'OrganizeMyLife';

  @override
  String get navToday => 'Hoje';

  @override
  String get navCalendar => 'Agenda';

  @override
  String get navTasks => 'Tarefas';

  @override
  String get navFinance => 'Finanças';

  @override
  String get navMore => 'Mais';

  @override
  String get authLoginTitle => 'Bem-vindo de volta';

  @override
  String get authLoginSubtitle => 'Entre para manter tudo sincronizado';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authLoginButton => 'Entrar';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String authNoAccount(String action) {
    return 'Não tem uma conta? $action';
  }

  @override
  String get authSignUpAction => 'Cadastre-se';

  @override
  String get authSignUpTitle => 'Crie sua conta';

  @override
  String get authResetPasswordTitle => 'Redefinir senha';

  @override
  String authResetPasswordSent(String email) {
    return 'Enviamos um link de redefinição para $email';
  }

  @override
  String get authSendResetLink => 'Enviar link de redefinição';

  @override
  String get authErrorInvalidCredentials => 'E-mail ou senha incorretos';

  @override
  String get authErrorEmailAlreadyInUse => 'Este e-mail já está cadastrado';

  @override
  String get authErrorWeakPassword =>
      'Senha muito fraca — use pelo menos 6 caracteres';

  @override
  String get authErrorUserNotFound =>
      'Nenhuma conta encontrada com este e-mail';

  @override
  String get authErrorNetwork => 'Erro de conexão — verifique sua internet';

  @override
  String get authErrorUnknown => 'Não foi possível concluir a solicitação';

  @override
  String get taskListTitle => 'Tarefas';

  @override
  String get taskAddNew => 'Nova tarefa';

  @override
  String get taskEmptyState =>
      'Nada por aqui ainda — adicione sua primeira tarefa';

  @override
  String get taskPriorityLow => 'Baixa';

  @override
  String get taskPriorityMedium => 'Média';

  @override
  String get taskPriorityHigh => 'Alta';

  @override
  String get taskMarkDone => 'Marcar como concluída';

  @override
  String taskDueDate(String date) {
    return 'Vence em $date';
  }

  @override
  String get taskTitleLabel => 'Título';

  @override
  String get taskCategoryLabel => 'Categoria (opcional)';

  @override
  String get taskDueDateLabel => 'Data de vencimento (opcional)';

  @override
  String get taskPriorityLabel => 'Prioridade';

  @override
  String get calendarTitle => 'Agenda';

  @override
  String get calendarAddEvent => 'Novo evento';

  @override
  String get calendarNoEvents => 'Nenhum evento neste dia';

  @override
  String get calendarFormatMonth => 'Mês';

  @override
  String get calendarFormatWeek => 'Semana';

  @override
  String get eventTitleLabel => 'Título';

  @override
  String get eventDescriptionLabel => 'Descrição (opcional)';

  @override
  String get eventLocationLabel => 'Local (opcional)';

  @override
  String get eventAllDay => 'Dia inteiro';

  @override
  String get eventStartLabel => 'Início';

  @override
  String get eventEndLabel => 'Fim';

  @override
  String get reminderTitle => 'Lembretes';

  @override
  String get reminderAddNew => 'Novo lembrete';

  @override
  String get reminderTitleLabel => 'Título';

  @override
  String get reminderDateTimeLabel => 'Data e hora';

  @override
  String get reminderEmptyState => 'Nenhum lembrete ainda';

  @override
  String get financeTitle => 'Finanças';

  @override
  String get financeIncome => 'Receita';

  @override
  String get financeExpense => 'Despesa';

  @override
  String get financeBalance => 'Saldo';

  @override
  String get financeMonthlySummary => 'Resumo mensal';

  @override
  String get financeAddTransaction => 'Adicionar transação';

  @override
  String get financeCategory => 'Categoria';

  @override
  String get financeAmount => 'Valor';

  @override
  String get financeNoTransactions => 'Nenhuma transação este mês';

  @override
  String get financeDescriptionLabel => 'Descrição';

  @override
  String get financeDateLabel => 'Data';

  @override
  String get financeCategoryChartTitle => 'Por categoria';

  @override
  String get financeTrendChartTitle => 'Últimos 6 meses';

  @override
  String get financeNoExpenses => 'Nenhuma despesa este mês';

  @override
  String get reportsTitle => 'Relatórios';

  @override
  String get reportsProductivity => 'Produtividade';

  @override
  String get reportsFinanceOverview => 'Visão geral financeira';

  @override
  String get reportsTasksTotal => 'Total';

  @override
  String get reportsTasksDone => 'Concluídas';

  @override
  String get reportsTasksPending => 'Pendentes';

  @override
  String get reportsCompletionRate => 'Taxa de conclusão';

  @override
  String get reportsTasksByPriority => 'Pendentes por prioridade';

  @override
  String get reportsNoPendingTasks => 'Nenhuma tarefa pendente';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsThemeSystem => 'Padrão do sistema';

  @override
  String get settingsLogout => 'Sair';

  @override
  String get dashboardTasksSection => 'Tarefas de hoje';

  @override
  String get dashboardEventsSection => 'Compromissos de hoje';

  @override
  String get dashboardNoTasks => 'Nada pendente hoje';

  @override
  String get dashboardNoEvents => 'Nenhum compromisso hoje';

  @override
  String get commonSeeAll => 'Ver tudo';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonError => 'Algo deu errado';

  @override
  String get commonRetry => 'Tentar novamente';
}
