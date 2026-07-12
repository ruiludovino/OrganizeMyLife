import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final fb.FirebaseAuth _firebaseAuth;

  AppUser _mapUser(fb.User user) => AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );

  @override
  Stream<AppUser?> authStateChanges() =>
      _firebaseAuth.authStateChanges().map((u) => u == null ? null : _mapUser(u));

  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : _mapUser(user);
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapErrorCode(e.code));
    }
  }

  @override
  Future<AppUser> signUp({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapErrorCode(e.code));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapErrorCode(e.code));
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  AuthErrorCode _mapErrorCode(String code) => switch (code) {
        'wrong-password' || 'invalid-credential' => AuthErrorCode.invalidCredentials,
        'email-already-in-use' => AuthErrorCode.emailAlreadyInUse,
        'weak-password' => AuthErrorCode.weakPassword,
        'user-not-found' => AuthErrorCode.userNotFound,
        'network-request-failed' => AuthErrorCode.network,
        _ => AuthErrorCode.unknown,
      };
}
