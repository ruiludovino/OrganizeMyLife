import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/generated/app_localizations.dart';

/// Aba "Mais" — porta de entrada para telas que não cabem nas 4 abas
/// principais (Lembretes, Relatórios). Configurações também mora aqui.
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.alarm_outlined),
            title: Text(l10n.reminderTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/reminders'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: Text(l10n.reportsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/reports'),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.settingsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }
}
