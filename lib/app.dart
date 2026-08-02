import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzaria_app/app_view.dart';
import 'package:pizzaria_app/features/auth/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

/// Raiz da arvore: injeta o repositorio e o bloc de autenticacao.
///
/// O repositorio fica disponivel via `context.read<UserRepository>()`, para as
/// telas nao precisarem alcanca-lo por dentro do AuthenticationBloc.
class App extends StatelessWidget {
  final UserRepository userRepository;

  const App({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(userRepository: userRepository),
        child: const MyAppView(),
      ),
    );
  }
}
