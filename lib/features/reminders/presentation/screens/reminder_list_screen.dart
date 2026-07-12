import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/reminder_providers.dart';
import '../widgets/add_edit_reminder_sheet.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final remindersAsync = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reminderTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditReminderSheet(context),
        child: const Icon(Icons.add),
      ),
      body: remindersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.commonError)),
        data: (reminders) {
          if (reminders.isEmpty) {
            return Center(child: Text(l10n.reminderEmptyState));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: reminders.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final d = reminder.dateTime;
              final formatted =
                  '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

              return Dismissible(
                key: ValueKey(reminder.id),
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
                onDismissed: (_) {
                  ref.read(reminderRepositoryProvider).deleteReminder(reminder.id);
                  NotificationService.instance.cancelReminder(reminder.id);
                },
                child: AppCard(
                  onTap: () => showAddEditReminderSheet(context, existing: reminder),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm_outlined),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reminder.title, style: Theme.of(context).textTheme.bodyLarge),
                            Text(
                              formatted,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
