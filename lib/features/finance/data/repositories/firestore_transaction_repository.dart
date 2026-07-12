import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

/// Transações ficam em `users/{uid}/transactions`, mesmo padrão de
/// `tasks`/`events` — protegido pelas mesmas regras `users/{userId}/{document=**}`.
class FirestoreTransactionRepository implements TransactionRepository {
  FirestoreTransactionRepository(FirebaseFirestore firestore, {required String userId})
      : _collection = firestore.collection('users').doc(userId).collection('transactions');

  final CollectionReference<Map<String, dynamic>> _collection;

  MoneyTransaction _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MoneyTransaction(
      id: doc.id,
      title: data['title'] as String,
      amount: (data['amount'] as num).toDouble(),
      type: TransactionType.values[data['type'] as int? ?? 1],
      category: data['category'] as String,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _toMap(MoneyTransaction transaction) => {
        'title': transaction.title,
        'amount': transaction.amount,
        'type': transaction.type.index,
        'category': transaction.category,
        'date': Timestamp.fromDate(transaction.date),
      };

  @override
  String newId() => _collection.doc().id;

  @override
  Stream<List<MoneyTransaction>> watchTransactions() {
    return _collection.orderBy('date', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  @override
  Future<void> addTransaction(MoneyTransaction transaction) =>
      _collection.doc(transaction.id).set(_toMap(transaction));

  @override
  Future<void> updateTransaction(MoneyTransaction transaction) =>
      _collection.doc(transaction.id).update(_toMap(transaction));

  @override
  Future<void> deleteTransaction(String id) => _collection.doc(id).delete();
}
