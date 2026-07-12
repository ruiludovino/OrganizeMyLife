import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organize_my_life/features/calendar/domain/entities/event.dart';
import 'package:organize_my_life/features/calendar/presentation/providers/event_providers.dart';
import 'package:organize_my_life/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:organize_my_life/features/tasks/domain/entities/task.dart';
import 'package:organize_my_life/features/tasks/presentation/providers/task_providers.dart';

import '../../helpers/fake_repositories.dart';

Task _task({required String id, bool done = false, DateTime? dueDate}) {
  return Task(
    id: id,
    title: 'Task $id',
    priority: TaskPriority.medium,
    done: done,
    dueDate: dueDate,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final tomorrow = today.add(const Duration(days: 1));

  group('todayTasksProvider', () {
    test('inclui tarefas vencidas ou que vencem hoje, exclui futuras e concluídas', () async {
      final container = ProviderContainer(overrides: [
        taskRepositoryProvider.overrideWithValue(FakeTaskRepository([
          _task(id: 'overdue', dueDate: yesterday),
          _task(id: 'today', dueDate: today),
          _task(id: 'future', dueDate: tomorrow),
          _task(id: 'no-due-date'),
          _task(id: 'done-today', dueDate: today, done: true),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(tasksProvider.future);
      final todayTasks = container.read(todayTasksProvider);

      expect(todayTasks.map((t) => t.id), containsAll(['overdue', 'today']));
      expect(todayTasks.map((t) => t.id), isNot(contains('future')));
      expect(todayTasks.map((t) => t.id), isNot(contains('no-due-date')));
      expect(todayTasks.map((t) => t.id), isNot(contains('done-today')));
    });

    test('ordena por data de vencimento crescente', () async {
      final container = ProviderContainer(overrides: [
        taskRepositoryProvider.overrideWithValue(FakeTaskRepository([
          _task(id: 'today', dueDate: today),
          _task(id: 'overdue', dueDate: yesterday),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(tasksProvider.future);
      final todayTasks = container.read(todayTasksProvider);

      expect(todayTasks.map((t) => t.id).toList(), ['overdue', 'today']);
    });
  });

  group('todayEventsProvider', () {
    test('retorna só os eventos de hoje, ordenados pelo horário de início', () async {
      final container = ProviderContainer(overrides: [
        eventRepositoryProvider.overrideWithValue(FakeEventRepository([
          Event(
            id: '1',
            title: 'Tarde',
            start: DateTime(today.year, today.month, today.day, 15),
            end: DateTime(today.year, today.month, today.day, 16),
            allDay: false,
          ),
          Event(
            id: '2',
            title: 'Manhã',
            start: DateTime(today.year, today.month, today.day, 9),
            end: DateTime(today.year, today.month, today.day, 10),
            allDay: false,
          ),
          Event(
            id: '3',
            title: 'Amanhã',
            start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9),
            end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10),
            allDay: false,
          ),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(eventsProvider.future);
      final todayEvents = container.read(todayEventsProvider);

      expect(todayEvents.map((e) => e.title).toList(), ['Manhã', 'Tarde']);
    });
  });
}
