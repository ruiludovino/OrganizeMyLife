import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';

/// Casca de navegação com 5 abas. Cada aba é um `StatefulShellBranch`
/// (ver app_router.dart), então trocar de aba preserva a pilha de
/// navegação de cada uma — voltar para "Tarefas" não perde o scroll
/// nem fecha um sheet que ficou aberto em outra aba.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.today_outlined), label: l10n.navToday),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), label: l10n.navCalendar),
          NavigationDestination(icon: const Icon(Icons.checklist_outlined), label: l10n.navTasks),
          NavigationDestination(icon: const Icon(Icons.account_balance_wallet_outlined), label: l10n.navFinance),
          NavigationDestination(icon: const Icon(Icons.more_horiz), label: l10n.navMore),
        ],
      ),
    );
  }
}
