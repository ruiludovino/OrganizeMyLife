import '../entities/task.dart';

abstract interface class TaskRepository {
  /// Gera um id novo para uma tarefa antes de criá-la.
  String newId();

  Stream<List<Task>> watchTasks();

  Future<void> addTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String id);

  Future<void> setDone(String id, bool done);
}
