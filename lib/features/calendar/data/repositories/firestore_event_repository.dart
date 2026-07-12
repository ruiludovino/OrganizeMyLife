import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

/// Eventos ficam em `users/{uid}/events`, mesmo padrão de `tasks`
/// (ver FirestoreTaskRepository) — protegido pelas mesmas regras
/// de segurança `users/{userId}/{document=**}`.
class FirestoreEventRepository implements EventRepository {
  FirestoreEventRepository(FirebaseFirestore firestore, {required String userId})
      : _collection = firestore.collection('users').doc(userId).collection('events');

  final CollectionReference<Map<String, dynamic>> _collection;

  Event _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Event(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String?,
      location: data['location'] as String?,
      start: (data['start'] as Timestamp).toDate(),
      end: (data['end'] as Timestamp).toDate(),
      allDay: data['allDay'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _toMap(Event event) => {
        'title': event.title,
        'description': event.description,
        'location': event.location,
        'start': Timestamp.fromDate(event.start),
        'end': Timestamp.fromDate(event.end),
        'allDay': event.allDay,
      };

  @override
  String newId() => _collection.doc().id;

  @override
  Stream<List<Event>> watchEvents() {
    return _collection.orderBy('start').snapshots().map(
          (snapshot) => snapshot.docs.map(_fromDoc).toList(),
        );
  }

  @override
  Future<void> addEvent(Event event) => _collection.doc(event.id).set(_toMap(event));

  @override
  Future<void> updateEvent(Event event) => _collection.doc(event.id).update(_toMap(event));

  @override
  Future<void> deleteEvent(String id) => _collection.doc(id).delete();
}
