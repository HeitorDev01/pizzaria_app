import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(this._userRepository) : super(const SignInInitial()) {
    on<SignInRequired>(_onSignInRequired);
    on<SignOutRequired>(_onSignOutRequired);
  }

  Future<void> _onSignInRequired(
    SignInRequired event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SignInInProgress());
    try {
      await _userRepository.signIn(event.email, event.password);
      emit(const SignInSuccess());
    } catch (_) {
      // A mensagem crua do Firebase nao vai para a UI de proposito: ela
      // revela se o e-mail existe cadastrado.
      emit(const SignInFailure('E-mail ou senha invalidos'));
    }
  }

  Future<void> _onSignOutRequired(
    SignOutRequired event,
    Emitter<SignInState> emit,
  ) async {
    await _userRepository.signOut();
    emit(const SignInInitial());
  }
}
