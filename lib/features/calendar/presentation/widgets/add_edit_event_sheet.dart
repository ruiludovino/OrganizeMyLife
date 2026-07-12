import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/event.dart';
import '../providers/event_providers.dart';

/// Abre o sheet em modo criação (existing == null) ou edição.
/// `initialDay` pré-preenche a data quando se cria a partir do dia
/// selecionado no calendário.
Future<void> showAddEditEventSheet(
  BuildContext context, {
  Event? existing,
  DateTime? initialDay,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddEditEventSheet(existing: existing, initialDay: initialDay),
  );
}

class _AddEditEventSheet extends ConsumerStatefulWidget {
  const _AddEditEventSheet({this.existing, this.initialDay});

  final Event? existing;
  final DateTime? initialDay;

  @override
  ConsumerState<_AddEditEventSheet> createState() => _AddEditEventSheetState();
}

class _AddEditEventSheetState extends ConsumerState<_AddEditEventSheet> {
  late final _titleController = TextEditingController(text: widget.existing?.title);
  late final _descriptionController = TextEditingController(text: widget.existing?.description);
  late final _locationController = TextEditingController(text: widget.existing?.location);

  late bool _allDay = widget.existing?.allDay ?? false;
  late DateTime _start = widget.existing?.start ??
      widget.initialDay ??
      DateTime.now();
  late DateTime _end = widget.existing?.end ?? _start.add(const Duration(hours: 1));
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final current = isStart ? _start : _end;
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (date == null || !mounted) return;

    var newDateTime = DateTime(date.year, date.month, date.day, current.hour, current.minute);

    if (!_allDay) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(current),
      );
      if (time == null || !mounted) return;
      newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }

    setState(() {
      if (isStart) {
        _start = newDateTime;
        if (_end.isBefore(_start)) _end = _start.add(const Duration(hours: 1));
      } else {
        _end = newDateTime;
      }
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _saving = true);
    final repo = ref.read(eventRepositoryProvider);
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();

    final event = (widget.existing ??
            Event(
              id: repo.newId(),
              title: title,
              start: _start,
              end: _end,
              allDay: _allDay,
            ))
        .copyWith(
      title: title,
      description: description.isEmpty ? null : description,
      location: location.isEmpty ? null : location,
      start: _start,
      end: _end,
      allDay: _allDay,
    );

    if (widget.existing == null) {
      await repo.addEvent(event);
    } else {
      await repo.updateEvent(event);
    }

    if (mounted) Navigator.of(context).pop();
  }

  String _formatDateTime(DateTime d, bool allDay) {
    final date = '${d.day}/${d.month}/${d.year}';
    if (allDay) return date;
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return '$date $hour:$minute';
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
          AppTextField(label: l10n.eventTitleLabel, controller: _titleController),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.eventDescriptionLabel, controller: _descriptionController),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: l10n.eventLocationLabel, controller: _locationController),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.eventAllDay),
            value: _allDay,
            onChanged: (v) => setState(() => _allDay = v),
          ),
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton.icon(
            onPressed: () => _pickDateTime(isStart: true),
            icon: const Icon(Icons.event_outlined),
            label: Text('${l10n.eventStartLabel}: ${_formatDateTime(_start, _allDay)}'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _pickDateTime(isStart: false),
            icon: const Icon(Icons.event_outlined),
            label: Text('${l10n.eventEndLabel}: ${_formatDateTime(_end, _allDay)}'),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: l10n.commonSave, loading: _saving, onPressed: _save),
        ],
      ),
    );
  }
}
