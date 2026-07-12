/// Usuário autenticado — versão enxuta do que a UI precisa,
/// desacoplada do `User` do firebase_auth (a camada data faz o mapeamento).
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;
}
