import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, danger }

/// Botão padrão do design system. Encapsula FilledButton/OutlinedButton
/// para que toda a app use os mesmos três variantes em vez de estilos
/// ad-hoc espalhados pelas telas.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onPressedEffective = loading ? null : onPressed;

    final child = loading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: variant == AppButtonVariant.secondary
                  ? scheme.primary
                  : scheme.onPrimary,
            ),
          )
        : icon == null
            ? Text(label)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              );

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: onPressedEffective,
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: onPressedEffective,
          child: child,
        ),
      AppButtonVariant.danger => FilledButton(
          onPressed: onPressedEffective,
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          child: child,
        ),
    };
  }
}
