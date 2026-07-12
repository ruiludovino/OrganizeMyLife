import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_reminder_repository.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    throw StateError('reminderRepositoryProvider só pode ser lido com usuário autenticado');
  }
  return FirestoreReminderRepository(FirebaseFirestore.instance, userId: user.id);
});

final remindersProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(reminderRepositoryProvider).watchReminders();
});
