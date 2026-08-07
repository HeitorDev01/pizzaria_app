import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzaria_app/pizza_repository.dart';
import 'package:pizzaria_app/src/entities/models/models.dart';

class FirebasePizzaRepo implements PizzaRepo {
  final pizzaCollection = FirebaseFirestore.instance.collection('pizzas');

  Future<List<Pizza>> getPizzas() async {
    try {
      return await pizzaCollection
        .get()
        .then((value) => value.docs.map((e) => 
          Pizza.fromEntity(PizzaEntity.fromDocument(e.data()))
        ).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}