import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/labeled_pie_chart.dart';
import '../../../finance/presentation/providers/transaction_providers.dart';
import '../../../finance/presentation/widgets/format_currency.dart';
import '../../../finance/presentation/widgets/summary_stat_card.dart';
import '../../../finance/presentation/widgets/trend_bar_chart.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_providers.dart';
import '../../../tasks/presentation/widgets/task_priority_dot.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    final taskStats = ref.watch(taskStatsProvider);
    final pendingByPriority = ref.watch(pendingTasksByPriorityProvider);

    final financeSummary = ref.watch(currentMonthSummaryProvider);
    final trend = ref.watch(sixMonthTrendProvider);
    final categoryTotals = ref.watch(currentMonthExpenseByCategoryProvider);

    final priorityData = <String, double>{
      for (final p in TaskPriority.values)
        if (pendingByPriority[p] != null) _priorityLabel(l10n, p): pendingByPriority[p]!.toDouble(),
    };
    final priorityColors = [
      for (final p in TaskPriority.values)
        if (pendingByPriority[p] != null) colorForPriority(p),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.reportsProductivity, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              SummaryStatCard(
                label: l10n.reportsTasksTotal,
                value: '${taskStats.total}',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: AppSpacing.sm),
              SummaryStatCard(
                label: l10n.reportsTasksDone,
                value: '${taskStats.done}',
                color: AppColors.income,
              ),
              const SizedBox(width: AppSpacing.sm),
              SummaryStatCard(
                label: l10n.reportsTasksPending,
                value: '${taskStats.pending}',
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              SummaryStatCard(
                label: l10n.reportsCompletionRate,
                value: NumberFormat.percentPattern(languageCode).format(taskStats.completionRate),
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.reportsTasksByPriority, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: priorityData.isEmpty
                ? SizedBox(
                    height: 120,
                    child: Center(child: Text(l10n.reportsNoPendingTasks)),
                  )
                : LabeledPieChart(data: priorityData, colors: priorityColors),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.reportsFinanceOverview, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              SummaryStatCard(
                label: l10n.financeIncome,
                value: formatCurrency(financeSummary.income, languageCode),
                color: AppColors.income,
              ),
              const SizedBox(width: AppSpacing.sm),
              SummaryStatCard(
                label: l10n.financeExpense,
                value: formatCurrency(financeSummary.expense, languageCode),
                color: AppColors.expense,
              ),
              const SizedBox(width: AppSpacing.sm),
              SummaryStatCard(
                label: l10n.financeBalance,
                value: formatCurrency(financeSummary.balance, languageCode),
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.financeCategoryChartTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: categoryTotals.isEmpty
                ? SizedBox(
                    height: 120,
                    child: Center(child: Text(l10n.financeNoExpenses)),
                  )
                : LabeledPieChart(data: categoryTotals, colors: AppColors.categoryPalette),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.financeTrendChartTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          AppCard(child: TrendBarChart(trend: trend, languageCode: languageCode)),
        ],
      ),
    );
  }
}

String _priorityLabel(AppLocalizations l10n, TaskPriority priority) => switch (priority) {
      TaskPriority.low => l10n.taskPriorityLow,
      TaskPriority.medium => l10n.taskPriorityMedium,
      TaskPriority.high => l10n.taskPriorityHigh,
    };
