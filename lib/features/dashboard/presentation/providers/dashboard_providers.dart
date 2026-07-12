import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../calendar/domain/entities/event.dart';
import '../../../calendar/presentation/providers/event_providers.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_providers.dart';

DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

/// Tarefas pendentes para hoje — vencidas ou vencendo hoje. Tarefas sem
/// data de vencimento ficam só na aba Tarefas, não poluem o dashboard.
final todayTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? const [];
  final today = _dayKey(DateTime.now());

  final pending = tasks.where((t) => !t.done && t.dueDate != null).where((t) {
    final due = _dayKey(t.dueDate!);
    return !due.isAfter(today);
  }).toList()
    ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

  return pending;
});

final todayEventsProvider = Provider<List<Event>>((ref) {
  final eventsByDay = ref.watch(eventsByDayProvider);
  final events = eventsByDay[_dayKey(DateTime.now())] ?? const <Event>[];
  return [...events]..sort((a, b) => a.start.compareTo(b.start));
});
