import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/repositories/auth_repository.dart';

/// Traduz o erro tipado do domain (AuthException) para a string
/// localizada correta — mantém as telas livres de switch/case repetido.
String localizeAuthError(AppLocalizations l10n, Object error) {
  final code = error is AuthException ? error.code : AuthErrorCode.unknown;
  return switch (code) {
    AuthErrorCode.invalidCredentials => l10n.authErrorInvalidCredentials,
    AuthErrorCode.emailAlreadyInUse => l10n.authErrorEmailAlreadyInUse,
    AuthErrorCode.weakPassword => l10n.authErrorWeakPassword,
    AuthErrorCode.userNotFound => l10n.authErrorUserNotFound,
    AuthErrorCode.network => l10n.authErrorNetwork,
    AuthErrorCode.unknown => l10n.authErrorUnknown,
  };
}
