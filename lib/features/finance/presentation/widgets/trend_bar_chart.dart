import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/transaction_providers.dart';

/// Barras de receita x despesa por mês — usado em Finanças e Relatórios.
class TrendBarChart extends StatelessWidget {
  const TrendBarChart({super.key, required this.trend, required this.languageCode});

  final List<MonthlyTotals> trend;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final maxY = trend
        .expand((t) => [t.income, t.expense])
        .fold<double>(0, (max, v) => v > max ? v : max);

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxY == 0 ? 1 : maxY * 1.2,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= trend.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.MMM(languageCode).format(trend[index].month),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < trend.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(toY: trend[i].income, color: AppColors.income, width: 7),
                  BarChartRodData(toY: trend[i].expense, color: AppColors.expense, width: 7),
                ],
                barsSpace: 3,
              ),
          ],
        ),
      ),
    );
  }
}
