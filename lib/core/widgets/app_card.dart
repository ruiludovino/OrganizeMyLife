import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Cartão padrão — usado para itens de lista (tarefas, eventos, transações)
/// e blocos de resumo (dashboard). Mantém padding/raio consistentes em
/// vez de cada tela reimplementar um Container com BoxDecoration.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: card,
    );
  }
}
