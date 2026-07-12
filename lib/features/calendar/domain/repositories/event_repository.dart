import '../entities/event.dart';

abstract interface class EventRepository {
  String newId();

  Stream<List<Event>> watchEvents();

  Future<void> addEvent(Event event);

  Future<void> updateEvent(Event event);

  Future<void> deleteEvent(String id);
}
