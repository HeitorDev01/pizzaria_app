import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pizzaria_app/features/auth/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pizzaria_app/features/auth/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:user_repository/user_repository.dart';

/// Repositorio de mentira controlado pelo teste, para exercitar os blocs sem
/// subir Firebase.
class FakeUserRepository implements UserRepository {
  final StreamController<MyUser> controller =
      StreamController<MyUser>.broadcast();

  Object? signUpError;
  Object? setUserDataError;
  bool setUserDataCalled = false;

  @override
  Stream<MyUser> get user => controller.stream;

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    if (signUpError != null) throw signUpError!;
    return myUser.copyWith(userId: 'uid-123');
  }

  @override
  Future<void> setUserData(MyUser user) async {
    setUserDataCalled = true;
    if (setUserDataError != null) throw setUserDataError!;
  }

  @override
  Future<void> signOut() async {}
}

MyUser _user({String id = 'uid-123'}) => MyUser(
      userId: id,
      email: 'teste@gmail.com',
      name: 'Teste',
      hasActiveCart: false,
    );

void main() {
  group('AuthenticationBloc', () {
    test('autentica quando o repositorio emite um usuario', () async {
      final repo = FakeUserRepository();
      final bloc = AuthenticationBloc(userRepository: repo);
      addTearDown(() async {
        await bloc.close();
        await repo.controller.close();
      });

      repo.controller.add(_user());
      await bloc.stream.firstWhere(
        (s) => s.status == AuthenticationStatus.authenticated,
      );

      expect(bloc.state.user?.userId, 'uid-123');
    });

    test('um erro no stream nao trava o app: cai em unauthenticated e o '
        'bloc continua respondendo', () async {
      final repo = FakeUserRepository();
      final bloc = AuthenticationBloc(userRepository: repo);
      addTearDown(() async {
        await bloc.close();
        await repo.controller.close();
      });

      repo.controller.addError(StateError('Firestore fora do ar'));
      await bloc.stream.firstWhere(
        (s) => s.status == AuthenticationStatus.unauthenticated,
      );

      // O ponto da correcao: antes o erro cancelava a assinatura e nenhum
      // login posterior chegava ao bloc.
      repo.controller.add(_user());
      await bloc.stream.firstWhere(
        (s) => s.status == AuthenticationStatus.authenticated,
      );

      expect(bloc.state.status, AuthenticationStatus.authenticated);
    });

    test('usuario vazio conta como deslogado mesmo sem ser MyUser.empty',
        () async {
      final repo = FakeUserRepository();
      final bloc = AuthenticationBloc(userRepository: repo);
      addTearDown(() async {
        await bloc.close();
        await repo.controller.close();
      });

      repo.controller.add(
        MyUser(userId: '', email: '', name: '', hasActiveCart: false),
      );
      await bloc.stream.firstWhere(
        (s) => s.status == AuthenticationStatus.unauthenticated,
      );

      expect(bloc.state.status, AuthenticationStatus.unauthenticated);
    });
  });

  group('SignUpBloc', () {
    test('cadastro bem-sucedido grava o perfil e emite SignUpSuccess',
        () async {
      final repo = FakeUserRepository();
      final bloc = SignUpBloc(repo);
      addTearDown(bloc.close);

      final states = <SignUpState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(SignUpRequired(_user(id: ''), 'Senha@123'));
      await bloc.stream.firstWhere((s) => s is SignUpSuccess);
      await sub.cancel();

      expect(repo.setUserDataCalled, isTrue);
      expect(states.first, isA<SignUpProcess>());
      expect(states.last, isA<SignUpSuccess>());
    });

    test('falha do Firebase vira SignUpFailure com mensagem, e nao spinner '
        'eterno', () async {
      final repo = FakeUserRepository()
        ..signUpError = const AuthFailure('Este e-mail ja esta cadastrado');
      final bloc = SignUpBloc(repo);
      addTearDown(bloc.close);

      bloc.add(SignUpRequired(_user(id: ''), 'Senha@123'));
      final state = await bloc.stream.firstWhere((s) => s is SignUpFailure);

      expect((state as SignUpFailure).message, 'Este e-mail ja esta cadastrado');
    });

    test('erro ao gravar o perfil tambem encerra o carregamento', () async {
      final repo = FakeUserRepository()
        ..setUserDataError = StateError('permission-denied');
      final bloc = SignUpBloc(repo);
      addTearDown(bloc.close);

      bloc.add(SignUpRequired(_user(id: ''), 'Senha@123'));
      final state = await bloc.stream.firstWhere((s) => s is SignUpFailure);

      expect(state, isA<SignUpFailure>());
    });
  });
}
