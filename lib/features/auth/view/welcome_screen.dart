import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzaria_app/features/auth/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizzaria_app/features/auth/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:pizzaria_app/features/auth/view/sign_in_screen.dart';
import 'package:pizzaria_app/features/auth/view/sign_up_screen.dart';
import 'package:user_repository/user_repository.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final userRepository = context.read<UserRepository>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              _BlurredCircle(
                alignment: const AlignmentDirectional(20, -1.2),
                diameter: size.width,
                color: colorScheme.tertiary,
              ),
              _BlurredCircle(
                alignment: const AlignmentDirectional(2.7, -1.2),
                diameter: size.width / 1.3,
                color: colorScheme.primary,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: size.height / 1.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: colorScheme.onSurface,
                          unselectedLabelColor:
                              colorScheme.onSurface.withValues(alpha: 0.5),
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Entrar',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Cadastrar',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            BlocProvider(
                              create: (_) => SignInBloc(userRepository),
                              child: const SignInScreen(),
                            ),
                            BlocProvider(
                              create: (_) => SignUpBloc(userRepository),
                              child: const SignUpScreen(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  final AlignmentDirectional alignment;
  final double diameter;
  final Color color;

  const _BlurredCircle({
    required this.alignment,
    required this.diameter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        height: diameter,
        width: diameter,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
