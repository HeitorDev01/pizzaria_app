import 'models/models.dart';

/// Contrato de acesso a usuarios.
///
/// A UI e os blocs dependem so desta interface, nunca do Firebase direto.
abstract class UserRepository {
  /// Emite o usuario logado, ou [MyUser.empty] quando nao ha sessao.
  Stream<MyUser> get user;

  Future<void> signIn(String email, String password);

  /// Cria a conta e devolve o usuario ja com o `userId` preenchido.
  /// Gravar o perfil e responsabilidade separada de [setUserData].
  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<void> signOut();
}
