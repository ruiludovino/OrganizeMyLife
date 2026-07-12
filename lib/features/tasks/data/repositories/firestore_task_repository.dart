import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

/// Tarefas ficam em `users/{uid}/tasks` — cada usuário só enxerga (e as
/// regras de segurança do Firestore só devem liberar) a própria subcoleção.
/// O SDK do Firestore já cacheia localmente e sincroniza em tempo real,
/// então não precisamos de uma camada SQLite separada.
class FirestoreTaskRepository implements TaskRepository {
  FirestoreTaskRepository(FirebaseFirestore firestore, {required String userId})
      : _collection = firestore.collection('users').doc(userId).collection('tasks');

  final CollectionReference<Map<String, dynamic>> _collection;

  Task _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Task(
      id: doc.id,
      title: data['title'] as String,
      category: data['category'] as String?,
      priority: TaskPriority.values[data['priority'] as int? ?? 1],
      done: data['done'] as bool? ?? false,
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> _toMap(Task task) => {
        'title': task.title,
        'category': task.category,
        'priority': task.priority.index,
        'done': task.done,
        'dueDate': task.dueDate == null ? null : Timestamp.fromDate(task.dueDate!),
        'createdAt': Timestamp.fromDate(task.createdAt),
      };

  @override
  String newId() => _collection.doc().id;

  @override
  Stream<List<Task>> watchTasks() {
    return _collection.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  @override
  Future<void> addTask(Task task) => _collection.doc(task.id).set(_toMap(task));

  @override
  Future<void> updateTask(Task task) => _collection.doc(task.id).update(_toMap(task));

  @override
  Future<void> deleteTask(String id) => _collection.doc(id).delete();

  @override
  Future<void> setDone(String id, bool done) => _collection.doc(id).update({'done': done});
}
