import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        MyUser myUser = await _userRepository.signUp(event.user, event.password);
        await _userRepository.setUserData(myUser);
        emit(SignUpSuccess());
      } on AuthFailure catch (e) {
        emit(SignUpFailure(e.message));
      } catch (e) {
        log('Falha no cadastro: $e');
        // A conta no Auth pode ter sido criada e so a gravacao do perfil ter
        // falhado. O stream de autenticacao ja monta o usuario a partir do
        // Auth, entao o app continua utilizavel.
        emit(const SignUpFailure());
      }
    });
  }
}