import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/labeled_pie_chart.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_providers.dart';
import '../widgets/add_edit_transaction_sheet.dart';
import '../widgets/format_currency.dart';
import '../widgets/summary_stat_card.dart';
import '../widgets/trend_bar_chart.dart';

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final selectedMonth = ref.watch(selectedMonthProvider);
    final summary = ref.watch(monthlySummaryProvider);
    final categoryTotals = ref.watch(expenseByCategoryProvider);
    final trend = ref.watch(sixMonthTrendProvider);
    final transactions = ref.watch(monthlyTransactionsProvider);

    final monthLabel = DateFormat.yMMMM(languageCode).format(selectedMonth);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.financeTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditTransactionSheet(context),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => ref.read(selectedMonthProvider.notifier).state =
                    DateTime(selectedMonth.year, selectedMonth.month - 1),
              ),
              Text(
                monthLabel[0].toUpperCase() + monthLabel.substring(1),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => ref.read(selectedMonthProvider.notifier).state =
                    DateTime(selectedMonth.year, selectedMonth.month + 1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              SummaryStatCard(
                label: l10n.financeIncome,
                value: formatCurrency(summary.income, languageCode),
                color: AppColors.income,
              ),
              const SizedBox(width: AppSpacing.sm),
              SummaryStatCard(
                label: l10n.financeExpense,
                value: formatCurrency(summary.expense, languageCode),
                color: AppColors.expense,
              ),
              const SizedBox(width: AppSpacing.sm),
              SummaryStatCard(
                label: l10n.financeBalance,
                value: formatCurrency(summary.balance, languageCode),
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
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.financeMonthlySummary, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(child: Text(l10n.financeNoTransactions)),
            )
          else
            ...transactions.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Dismissible(
                  key: ValueKey(t.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                  onDismissed: (_) => ref.read(transactionRepositoryProvider).deleteTransaction(t.id),
                  child: AppCard(
                    onTap: () => showAddEditTransactionSheet(context, existing: t),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.title, style: Theme.of(context).textTheme.bodyLarge),
                              Text(
                                t.category,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatCurrency(t.signedAmount, languageCode),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: t.type == TransactionType.income
                                    ? AppColors.income
                                    : AppColors.expense,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
