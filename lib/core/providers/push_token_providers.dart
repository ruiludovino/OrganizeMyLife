import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../services/notification_service.dart';

/// Mantém `users/{uid}.fcmTokens` sincronizado com o token de push do
/// dispositivo — é o que a Cloud Function `dailyTaskDigest` usa para saber
/// para onde mandar a notificação. Escuta login/logout e troca de token
/// (reinstalação, novo dispositivo) e vai só somando tokens (um usuário
/// pode ter vários dispositivos); nunca removemos no cliente — quem limpa
/// tokens inválidos é a própria Cloud Function, quando o envio falha.
final pushTokenSyncProvider = Provider<void>((ref) {
  Future<void> saveToken(String userId, String? token) async {
    if (token == null) return;
    await FirebaseFirestore.instance.collection('users').doc(userId).set(
      {'fcmTokens': FieldValue.arrayUnion([token])},
      SetOptions(merge: true),
    );
  }

  ref.listen(authStateProvider, (previous, next) {
    final user = next.value;
    if (user == null) return;
    NotificationService.instance.getToken().then((token) => saveToken(user.id, token));
  }, fireImmediately: true);

  final refreshSubscription = NotificationService.instance.onTokenRefresh.listen((token) {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;
    saveToken(user.id, token);
  });
  ref.onDispose(refreshSubscription.cancel);
});
