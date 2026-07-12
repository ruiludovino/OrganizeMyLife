import '../entities/transaction.dart';

abstract interface class TransactionRepository {
  String newId();

  Stream<List<MoneyTransaction>> watchTransactions();

  Future<void> addTransaction(MoneyTransaction transaction);

  Future<void> updateTransaction(MoneyTransaction transaction);

  Future<void> deleteTransaction(String id);
}
