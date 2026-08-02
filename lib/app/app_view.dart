import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzaria_app/app/theme.dart';
import 'package:pizzaria_app/features/auth/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:pizzaria_app/features/auth/view/welcome_screen.dart';
import 'package:pizzaria_app/features/home/view/home_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Delivery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return switch (state.status) {
            AuthenticationStatus.authenticated => const HomeScreen(),
            AuthenticationStatus.unauthenticated => const WelcomeScreen(),
            // Enquanto o primeiro evento do stream nao chega nao da para
            // saber se ha sessao ativa; mostrar a tela de login aqui faria
            // ela piscar para quem ja esta logado.
            AuthenticationStatus.unknown => const _SplashScreen(),
          };
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
