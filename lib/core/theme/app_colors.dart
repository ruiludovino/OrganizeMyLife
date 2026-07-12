import 'package:flutter/material.dart';

/// Design tokens — cores da marca OrganizeMyLife.
///
/// A paleta nasce de duas seed colors (Material 3 `ColorScheme.fromSeed`),
/// uma para o tema claro e outra para o escuro, garantindo contraste AA
/// automático em todos os tons derivados (surface, container, onX...).
/// As cores semânticas (renda/despesa/prioridade) ficam fixas nos dois temas.
abstract final class AppColors {
  // Seeds — Material 3 gera toda a paleta tonal a partir destas.
  static const seedLight = Color(0xFF3D5AFE); // indigo elétrico
  static const seedDark = Color(0xFF6C82FF);

  // Semânticas — não variam com o tema, precisam de reconhecimento imediato.
  static const income = Color(0xFF1FAE68); // verde receita
  static const expense = Color(0xFFE5484D); // vermelho despesa
  static const warning = Color(0xFFF2A93B);

  static const priorityLow = Color(0xFF4CAF7D);
  static const priorityMedium = Color(0xFFF2A93B);
  static const priorityHigh = Color(0xFFE5484D);

  // Categorias financeiras/tarefas — paleta categórica com contraste
  // suficiente entre vizinhos para uso em gráficos de pizza/barras.
  static const categoryPalette = <Color>[
    Color(0xFF3D5AFE),
    Color(0xFF00B8A9),
    Color(0xFFF2A93B),
    Color(0xFFE5484D),
    Color(0xFF8B5CF6),
    Color(0xFF2E9CCA),
    Color(0xFFEA6FAC),
    Color(0xFF6B8E23),
  ];
}

ColorScheme buildLightColorScheme() => ColorScheme.fromSeed(
      seedColor: AppColors.seedLight,
      brightness: Brightness.light,
    );

ColorScheme buildDarkColorScheme() => ColorScheme.fromSeed(
      seedColor: AppColors.seedDark,
      brightness: Brightness.dark,
    );
