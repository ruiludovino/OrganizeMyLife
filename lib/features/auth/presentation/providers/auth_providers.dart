import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/firebase_auth_repository.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(fb.FirebaseAuth.instance);
});

/// Fonte única de verdade de "quem está logado" — o router (redirect guard)
/// e qualquer tela podem observar isto para reagir a login/logout.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// Controllers por formulário (login/signup/forgot-password) em vez de um
/// único controller genérico: cada tela tem seu próprio ciclo de
/// loading/erro, sem estado cruzado entre fluxos diferentes.
class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repo.signIn(email: email, password: password),
    );
    state = result.hasError ? AsyncError(result.error!, result.stackTrace!) : const AsyncData(null);
    return !state.hasError;
  }
}

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(LoginController.new);

class SignUpController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repo.signUp(email: email, password: password),
    );
    state = result.hasError ? AsyncError(result.error!, result.stackTrace!) : const AsyncData(null);
    return !state.hasError;
  }
}

final signUpControllerProvider = AsyncNotifierProvider<SignUpController, void>(SignUpController.new);

class ForgotPasswordController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit(String email) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(() => repo.sendPasswordResetEmail(email));
    state = result.hasError ? AsyncError(result.error!, result.stackTrace!) : const AsyncData(null);
    return !state.hasError;
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, void>(ForgotPasswordController.new);
