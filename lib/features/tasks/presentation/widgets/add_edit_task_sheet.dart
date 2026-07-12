import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/task.dart';
import '../providers/task_providers.dart';
import 'task_priority_dot.dart';

/// Abre o sheet em modo criação (existing == null) ou edição.
Future<void> showAddEditTaskSheet(BuildContext context, {Task? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddEditTaskSheet(existing: existing),
  );
}

class _AddEditTaskSheet extends ConsumerStatefulWidget {
  const _AddEditTaskSheet({this.existing});

  final Task? existing;

  @override
  ConsumerState<_AddEditTaskSheet> createState() => _AddEditTaskSheetState();
}

class _AddEditTaskSheetState extends ConsumerState<_AddEditTaskSheet> {
  late final _titleController = TextEditingController(text: widget.existing?.title);
  late final _categoryController = TextEditingController(text: widget.existing?.category);
  late TaskPriority _priority = widget.existing?.priority ?? TaskPriority.medium;
  late DateTime? _dueDate = widget.existing?.dueDate;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _saving = true);
    final repo = ref.read(taskRepositoryProvider);
    final category = _categoryController.text.trim();

    final task = (widget.existing ?? Task(
      id: repo.newId(),
      title: title,
      priority: _priority,
      done: false,
      createdAt: DateTime.now(),
    )).copyWith(
      title: title,
      category: category.isEmpty ? null : category,
      priority: _priority,
      dueDate: _dueDate,
    );

    if (widget.existing == null) {
      await repo.addTask(task);
    } else {
      await repo.updateTask(task);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(label: l10n.taskTitleLabel, controller: _titleController),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.taskCategoryLabel, controller: _categoryController),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.taskPriorityLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: TaskPriority.values.map((p) {
              final label = switch (p) {
                TaskPriority.low => l10n.taskPriorityLow,
                TaskPriority.medium => l10n.taskPriorityMedium,
                TaskPriority.high => l10n.taskPriorityHigh,
              };
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TaskPriorityDot(priority: p),
                    const SizedBox(width: 6),
                    Text(label),
                  ],
                ),
                selected: _priority == p,
                onSelected: (_) => setState(() => _priority = p),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: _pickDueDate,
            icon: const Icon(Icons.event_outlined),
            label: Text(
              _dueDate == null
                  ? l10n.taskDueDateLabel
                  : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: l10n.commonSave, loading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}
