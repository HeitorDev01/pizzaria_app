import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(const SignUpInitial()) {
    on<SignUpRequired>(_onSignUpRequired);
  }

  Future<void> _onSignUpRequired(
    SignUpRequired event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpInProgress());
    try {
      final user = await _userRepository.signUp(event.user, event.password);
      await _userRepository.setUserData(user);
      emit(const SignUpSuccess());
    } catch (_) {
      emit(const SignUpFailure('Nao foi possivel criar a conta'));
    }
  }
}
