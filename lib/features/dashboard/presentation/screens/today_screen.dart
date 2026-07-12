import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../finance/presentation/providers/transaction_providers.dart';
import '../../../finance/presentation/widgets/format_currency.dart';
import '../../../finance/presentation/widgets/summary_stat_card.dart';
import '../../../tasks/presentation/providers/task_providers.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_section_header.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final today = DateTime.now();
    final dateLabel = DateFormat.yMMMMEEEEd(languageCode).format(today);

    final todayTasks = ref.watch(todayTasksProvider);
    final todayEvents = ref.watch(todayEventsProvider);
    final summary = ref.watch(currentMonthSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            dateLabel[0].toUpperCase() + dateLabel.substring(1),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),

          DashboardSectionHeader(
            title: l10n.dashboardTasksSection,
            seeAllLabel: l10n.commonSeeAll,
            onSeeAll: () => context.go('/tasks'),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (todayTasks.isEmpty)
            _EmptyHint(text: l10n.dashboardNoTasks)
          else
            ...todayTasks.take(5).map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: () => context.go('/tasks'),
                      child: Row(
                        children: [
                          Checkbox(
                            value: task.done,
                            onChanged: (v) =>
                                ref.read(taskRepositoryProvider).setDone(task.id, v ?? false),
                          ),
                          Expanded(child: Text(task.title)),
                        ],
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: AppSpacing.lg),

          DashboardSectionHeader(
            title: l10n.dashboardEventsSection,
            seeAllLabel: l10n.commonSeeAll,
            onSeeAll: () => context.go('/calendar'),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (todayEvents.isEmpty)
            _EmptyHint(text: l10n.dashboardNoEvents)
          else
            ...todayEvents.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  onTap: () => context.go('/calendar'),
                  child: Row(
                    children: [
                      Expanded(child: Text(event.title)),
                      Text(
                        event.allDay
                            ? l10n.eventAllDay
                            : '${event.start.hour.toString().padLeft(2, '0')}:${event.start.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),

          DashboardSectionHeader(
            title: l10n.financeMonthlySummary,
            seeAllLabel: l10n.commonSeeAll,
            onSeeAll: () => context.go('/finance'),
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
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}
