import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organize_my_life/features/tasks/domain/entities/task.dart';
import 'package:organize_my_life/features/tasks/presentation/providers/task_providers.dart';

import '../../helpers/fake_repositories.dart';

Task _task({
  required String id,
  TaskPriority priority = TaskPriority.medium,
  bool done = false,
  DateTime? dueDate,
}) {
  return Task(
    id: id,
    title: 'Task $id',
    priority: priority,
    done: done,
    dueDate: dueDate,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('taskStatsProvider', () {
    test('conta total, concluídas e pendentes corretamente', () async {
      final container = ProviderContainer(overrides: [
        taskRepositoryProvider.overrideWithValue(FakeTaskRepository([
          _task(id: '1', done: true),
          _task(id: '2', done: true),
          _task(id: '3', done: false),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(tasksProvider.future);
      final stats = container.read(taskStatsProvider);

      expect(stats.total, 3);
      expect(stats.done, 2);
      expect(stats.pending, 1);
      expect(stats.completionRate, closeTo(2 / 3, 0.0001));
    });

    test('taxa de conclusão é 0 quando não há tarefas, sem dividir por zero', () async {
      final container = ProviderContainer(overrides: [
        taskRepositoryProvider.overrideWithValue(FakeTaskRepository(const [])),
      ]);
      addTearDown(container.dispose);

      await container.read(tasksProvider.future);
      final stats = container.read(taskStatsProvider);

      expect(stats.total, 0);
      expect(stats.completionRate, 0);
    });
  });

  group('pendingTasksByPriorityProvider', () {
    test('agrupa só as tarefas pendentes, ignorando as concluídas', () async {
      final container = ProviderContainer(overrides: [
        taskRepositoryProvider.overrideWithValue(FakeTaskRepository([
          _task(id: '1', priority: TaskPriority.high, done: false),
          _task(id: '2', priority: TaskPriority.high, done: false),
          _task(id: '3', priority: TaskPriority.high, done: true),
          _task(id: '4', priority: TaskPriority.low, done: false),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(tasksProvider.future);
      final byPriority = container.read(pendingTasksByPriorityProvider);

      expect(byPriority[TaskPriority.high], 2);
      expect(byPriority[TaskPriority.low], 1);
      expect(byPriority.containsKey(TaskPriority.medium), isFalse);
    });

    test('não inclui prioridades sem tarefas pendentes', () async {
      final container = ProviderContainer(overrides: [
        taskRepositoryProvider.overrideWithValue(FakeTaskRepository([
          _task(id: '1', priority: TaskPriority.medium, done: true),
        ])),
      ]);
      addTearDown(container.dispose);

      await container.read(tasksProvider.future);
      final byPriority = container.read(pendingTasksByPriorityProvider);

      expect(byPriority, isEmpty);
    });
  });
}
