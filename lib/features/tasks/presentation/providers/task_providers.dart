import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_task_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';

/// Só é lido a partir de telas dentro do shell autenticado (o redirect
/// guard do router garante que `currentUser` nunca é nulo aqui).
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    throw StateError('taskRepositoryProvider só pode ser lido com usuário autenticado');
  }
  return FirestoreTaskRepository(FirebaseFirestore.instance, userId: user.id);
});

final tasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskRepositoryProvider).watchTasks();
});

class TaskStats {
  const TaskStats({required this.total, required this.done});

  final int total;
  final int done;

  int get pending => total - done;
  double get completionRate => total == 0 ? 0 : done / total;
}

/// Contagens usadas no relatório de produtividade.
final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? const [];
  return TaskStats(total: tasks.length, done: tasks.where((t) => t.done).length);
});

/// Tarefas pendentes agrupadas por prioridade — alimenta o gráfico de
/// pizza do relatório de produtividade. Só entram prioridades com pelo
/// menos uma tarefa pendente.
final pendingTasksByPriorityProvider = Provider<Map<TaskPriority, int>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? const [];
  final map = <TaskPriority, int>{};
  for (final t in tasks.where((t) => !t.done)) {
    map.update(t.priority, (v) => v + 1, ifAbsent: () => 1);
  }
  return map;
});
