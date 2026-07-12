import '../entities/reminder.dart';

abstract interface class ReminderRepository {
  String newId();

  Stream<List<Reminder>> watchReminders();

  Future<void> addReminder(Reminder reminder);

  Future<void> updateReminder(Reminder reminder);

  Future<void> deleteReminder(String id);
}
