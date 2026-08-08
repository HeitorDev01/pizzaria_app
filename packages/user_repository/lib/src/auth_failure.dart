/// Erro de autenticacao ja traduzido para o usuario final.
///
/// Existe para o app (blocs e telas) nao precisar importar `firebase_auth` so
/// para ler `FirebaseAuthException.code`: a traducao acontece aqui, na unica
/// camada que sabe que o backend e o Firebase.
class AuthFailure implements Exception {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}
