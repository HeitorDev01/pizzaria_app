import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

/// Registra o ciclo de vida dos blocs no console.
///
/// Silencioso em release: os eventos podem carregar dados do usuario e nao
/// devem ir parar no log do aparelho.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  void _log(String message) {
    if (kDebugMode) log(message, name: 'bloc');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _log('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _log('onEvent -- ${bloc.runtimeType}, event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _log('onChange -- ${bloc.runtimeType}, change: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _log('onTransition -- ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _log('onError -- ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _log('onClose -- ${bloc.runtimeType}');
  }
}
