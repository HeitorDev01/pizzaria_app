import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

part 'get_pizza_event.dart';
part 'get_pizza_state.dart';

class GetPizzaBloc extends Bloc<GetPizzaEvent, GetPizzaState> {
  final PizzaRepo _pizzaRepo;

  GetPizzaBloc(this._pizzaRepo) : super(GetPizzaInitial()) {
    on<GetPizza>((event, emit) async {
      emit(GetPizzaLoading());
      try {
        // Sem timeout o Firestore fica tentando reconectar indefinidamente
        // quando esta inacessivel, e a home trava no indicador de progresso.
        // Falhando rapido, a tela cai no catalogo local.
        List<Pizza> pizzas =
            await _pizzaRepo.getPizzas().timeout(const Duration(seconds: 10));
        emit(GetPizzaSuccess(pizzas));
      } catch (e) {
        log('Falha ao carregar as pizzas: $e');
        emit(GetPizzaFailure());
      }
    });
  }
}