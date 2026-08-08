import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Observa o usuario logado e define qual tela o app mostra.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  late final StreamSubscription<MyUser> _userSubscription;

  UserRepository get userRepository => _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationUserChanged>(_onUserChanged);

    // Sem onError, um unico erro no stream cancela a assinatura para sempre e
    // o app fica preso em AuthenticationStatus.unknown, sem sair da tela de
    // login. Tratar o erro como "deslogado" mantem o app utilizavel.
    _userSubscription = _userRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
      onError: (Object error, StackTrace stackTrace) {
        log('Stream de autenticacao falhou: $error', stackTrace: stackTrace);
        add(AuthenticationUserChanged(MyUser.empty));
      },
    );
  }

  void _onUserChanged(
    AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    // Compara pelo userId em vez de por identidade: MyUser nao implementa
    // ==, entao `user == MyUser.empty` so acerta na instancia exata.
    emit(
      event.user.userId.isEmpty
          ? const AuthenticationState.unauthenticated()
          : AuthenticationState.authenticated(event.user),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
