import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/firestore_event_repository.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    throw StateError('eventRepositoryProvider só pode ser lido com usuário autenticado');
  }
  return FirestoreEventRepository(FirebaseFirestore.instance, userId: user.id);
});

final eventsProvider = StreamProvider<List<Event>>((ref) {
  return ref.watch(eventRepositoryProvider).watchEvents();
});

DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

/// Agrupa a lista plana de eventos por dia (chave normalizada, sem hora)
/// — é o formato que o `table_calendar` espera do seu `eventLoader`.
final eventsByDayProvider = Provider<Map<DateTime, List<Event>>>((ref) {
  final events = ref.watch(eventsProvider).value ?? const [];
  final map = <DateTime, List<Event>>{};
  for (final event in events) {
    map.putIfAbsent(_dayKey(event.start), () => []).add(event);
  }
  return map;
});
