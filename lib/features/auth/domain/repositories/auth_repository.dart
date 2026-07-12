import '../entities/app_user.dart';

/// Códigos de erro estáveis, independentes do provedor (Firebase, etc.),
/// para a UI decidir qual string localizada mostrar.
enum AuthErrorCode {
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  userNotFound,
  network,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.code);
  final AuthErrorCode code;
}

/// Contrato de autenticação. A presentation layer depende só desta
/// interface — trocar Firebase por outro provedor no futuro não toca
/// nas telas nem nos providers.
abstract interface class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> signUp({required String email, required String password});

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}
