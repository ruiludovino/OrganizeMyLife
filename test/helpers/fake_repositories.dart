import 'package:organize_my_life/features/auth/domain/entities/app_user.dart';
import 'package:organize_my_life/features/auth/domain/repositories/auth_repository.dart';
import 'package:organize_my_life/features/calendar/domain/entities/event.dart';
import 'package:organize_my_life/features/calendar/domain/repositories/event_repository.dart';
import 'package:organize_my_life/features/finance/domain/entities/transaction.dart';
import 'package:organize_my_life/features/finance/domain/repositories/transaction_repository.dart';
import 'package:organize_my_life/features/tasks/domain/entities/task.dart';
import 'package:organize_my_life/features/tasks/domain/repositories/task_repository.dart';

/// Repositório de auth em memória — evita depender do Firebase real (que
/// não está inicializado nos testes) para os widgets que leem
/// `authRepositoryProvider`/`authStateProvider` (ex.: o router).
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? initialUser}) : currentUser = initialUser;

  @override
  AppUser? currentUser;

  @override
  Stream<AppUser?> authStateChanges() => Stream.value(currentUser);

  @override
  Future<AppUser> signIn({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signUp({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {
    currentUser = null;
  }
}

/// Repositórios em memória para testar providers sem depender do Firebase.
/// Cada um expõe a lista inicial via `Stream.value` — suficiente para os
/// providers que só leem o snapshot atual, sem exercitar updates ao vivo.
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository(this._tasks);

  final List<Task> _tasks;

  @override
  String newId() => 'fake-task-id';

  @override
  Stream<List<Task>> watchTasks() => Stream.value(_tasks);

  @override
  Future<void> addTask(Task task) async {}

  @override
  Future<void> updateTask(Task task) async {}

  @override
  Future<void> deleteTask(String id) async {}

  @override
  Future<void> setDone(String id, bool done) async {}
}

class FakeTransactionRepository implements TransactionRepository {
  FakeTransactionRepository(this._transactions);

  final List<MoneyTransaction> _transactions;

  @override
  String newId() => 'fake-transaction-id';

  @override
  Stream<List<MoneyTransaction>> watchTransactions() => Stream.value(_transactions);

  @override
  Future<void> addTransaction(MoneyTransaction transaction) async {}

  @override
  Future<void> updateTransaction(MoneyTransaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}
}

class FakeEventRepository implements EventRepository {
  FakeEventRepository(this._events);

  final List<Event> _events;

  @override
  String newId() => 'fake-event-id';

  @override
  Stream<List<Event>> watchEvents() => Stream.value(_events);

  @override
  Future<void> addEvent(Event event) async {}

  @override
  Future<void> updateEvent(Event event) async {}

  @override
  Future<void> deleteEvent(String id) async {}
}
