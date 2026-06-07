import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pizzaria_app/app.dart';
import 'package:user_repository/user_repository.dart';
import 'package:pizzaria_app/simple_bloc_observer.dart'; // Ajuste o caminho se tiver colocado em outra pasta

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp( MyApp(FirebaseUserRepo()));
}

