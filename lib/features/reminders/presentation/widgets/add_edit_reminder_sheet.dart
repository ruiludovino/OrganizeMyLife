import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminder_providers.dart';

Future<void> showAddEditReminderSheet(BuildContext context, {Reminder? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddEditReminderSheet(existing: existing),
  );
}

class _AddEditReminderSheet extends ConsumerStatefulWidget {
  const _AddEditReminderSheet({this.existing});

  final Reminder? existing;

  @override
  ConsumerState<_AddEditReminderSheet> createState() => _AddEditReminderSheetState();
}

class _AddEditReminderSheetState extends ConsumerState<_AddEditReminderSheet> {
  late final _titleController = TextEditingController(text: widget.existing?.title);
  late DateTime _dateTime = widget.existing?.dateTime ??
      DateTime.now().add(const Duration(hours: 1));
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (time == null || !mounted) return;

    setState(() {
      _dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _saving = true);
    final repo = ref.read(reminderRepositoryProvider);

    final reminder = (widget.existing ??
            Reminder(id: repo.newId(), title: title, dateTime: _dateTime))
        .copyWith(title: title, dateTime: _dateTime);

    if (widget.existing == null) {
      await repo.addReminder(reminder);
    } else {
      await repo.updateReminder(reminder);
    }
    await NotificationService.instance.scheduleReminder(
      id: reminder.id,
      title: reminder.title,
      dateTime: reminder.dateTime,
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final d = _dateTime;
    final formatted =
        '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

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
          AppTextField(label: l10n.reminderTitleLabel, controller: _titleController),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: _pickDateTime,
            icon: const Icon(Icons.alarm_outlined),
            label: Text('${l10n.reminderDateTimeLabel}: $formatted'),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: l10n.commonSave, loading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}
