import 'dart:async';

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

    _userSubscription = _userRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
  }

  void _onUserChanged(
    AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(
      event.user == MyUser.empty
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
