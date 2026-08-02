import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pizzaria_app/app/app.dart';
import 'package:pizzaria_app/app/bloc_observer.dart';
import 'package:pizzaria_app/core/config/firebase_options.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = const AppBlocObserver();

  runApp(App(userRepository: FirebaseUserRepo()));
}
