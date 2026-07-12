import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

/// Lembretes ficam em `users/{uid}/reminders`, mesmo padrão de
/// tasks/events/transactions — protegido pelas mesmas regras de segurança.
class FirestoreReminderRepository implements ReminderRepository {
  FirestoreReminderRepository(FirebaseFirestore firestore, {required String userId})
      : _collection = firestore.collection('users').doc(userId).collection('reminders');

  final CollectionReference<Map<String, dynamic>> _collection;

  Reminder _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Reminder(
      id: doc.id,
      title: data['title'] as String,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _toMap(Reminder reminder) => {
        'title': reminder.title,
        'dateTime': Timestamp.fromDate(reminder.dateTime),
      };

  @override
  String newId() => _collection.doc().id;

  @override
  Stream<List<Reminder>> watchReminders() {
    return _collection.orderBy('dateTime').snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  @override
  Future<void> addReminder(Reminder reminder) => _collection.doc(reminder.id).set(_toMap(reminder));

  @override
  Future<void> updateReminder(Reminder reminder) =>
      _collection.doc(reminder.id).update(_toMap(reminder));

  @override
  Future<void> deleteReminder(String id) => _collection.doc(id).delete();
}
