import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/task.dart';
import '../providers/task_providers.dart';
import '../widgets/add_edit_task_sheet.dart';
import '../widgets/task_priority_dot.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.taskListTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditTaskSheet(context),
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.commonError)),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(child: Text(l10n.taskEmptyState));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: ValueKey(task.id),
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
                onDismissed: (_) => ref.read(taskRepositoryProvider).deleteTask(task.id),
                child: _TaskTile(task: task),
              );
            },
          );
        },
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: () => showAddEditTaskSheet(context, existing: task),
      child: Row(
        children: [
          Checkbox(
            value: task.done,
            onChanged: (v) => ref.read(taskRepositoryProvider).setDone(task.id, v ?? false),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: textTheme.bodyLarge?.copyWith(
                    decoration: task.done ? TextDecoration.lineThrough : null,
                    color: task.done ? Theme.of(context).colorScheme.outline : null,
                  ),
                ),
                if (task.category != null || task.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      [
                        if (task.category != null) task.category!,
                        if (task.dueDate != null)
                          '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                      ].join(' · '),
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          TaskPriorityDot(priority: task.priority),
        ],
      ),
    );
  }
}
