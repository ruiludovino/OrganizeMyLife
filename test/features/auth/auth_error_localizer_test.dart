import 'package:flutter_test/flutter_test.dart';
import 'package:organize_my_life/core/l10n/generated/app_localizations_en.dart';
import 'package:organize_my_life/core/l10n/generated/app_localizations_pt.dart';
import 'package:organize_my_life/features/auth/domain/repositories/auth_repository.dart';
import 'package:organize_my_life/features/auth/presentation/auth_error_localizer.dart';

void main() {
  final en = AppLocalizationsEn();
  final pt = AppLocalizationsPt();

  test('traduz cada AuthErrorCode para a string localizada correta (en)', () {
    expect(
      localizeAuthError(en, const AuthException(AuthErrorCode.invalidCredentials)),
      en.authErrorInvalidCredentials,
    );
    expect(
      localizeAuthError(en, const AuthException(AuthErrorCode.emailAlreadyInUse)),
      en.authErrorEmailAlreadyInUse,
    );
    expect(
      localizeAuthError(en, const AuthException(AuthErrorCode.weakPassword)),
      en.authErrorWeakPassword,
    );
    expect(
      localizeAuthError(en, const AuthException(AuthErrorCode.userNotFound)),
      en.authErrorUserNotFound,
    );
    expect(
      localizeAuthError(en, const AuthException(AuthErrorCode.network)),
      en.authErrorNetwork,
    );
  });

  test('traduz para pt também', () {
    expect(
      localizeAuthError(pt, const AuthException(AuthErrorCode.invalidCredentials)),
      pt.authErrorInvalidCredentials,
    );
  });

  test('erros não tipados caem no fallback "unknown"', () {
    expect(localizeAuthError(en, Exception('boom')), en.authErrorUnknown);
  });
}
