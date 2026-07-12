import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/providers/app_preferences_providers.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          _SectionLabel(l10n.settingsTheme),
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).state = v!,
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.settingsThemeSystem),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.settingsThemeLight),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.settingsThemeDark),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.xl),
          _SectionLabel(l10n.settingsLanguage),
          RadioGroup<Locale?>(
            groupValue: locale,
            onChanged: (v) => ref.read(localeProvider.notifier).state = v,
            child: Column(
              children: [
                RadioListTile<Locale?>(
                  title: Text(l10n.settingsThemeSystem),
                  value: null,
                ),
                const RadioListTile<Locale?>(
                  title: Text('Português'),
                  value: Locale('pt'),
                ),
                const RadioListTile<Locale?>(
                  title: Text('English'),
                  value: Locale('en'),
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.xl),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.settingsLogout),
            onTap: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
