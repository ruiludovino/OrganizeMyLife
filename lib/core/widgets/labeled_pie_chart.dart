import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Gráfico de pizza com legenda — usado em Finanças (despesas por
/// categoria) e Relatórios (tarefas por prioridade). As cores são
/// atribuídas por índice, na mesma ordem das entradas de [data].
class LabeledPieChart extends StatelessWidget {
  const LabeledPieChart({super.key, required this.data, required this.colors});

  final Map<String, double> data;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value,
                    color: colors[i % colors.length],
                    radius: 56,
                    showTitle: false,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            for (var i = 0; i < entries.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(entries[i].key, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
