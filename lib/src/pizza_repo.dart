import 'package:pizzaria_app/src/entities/models/models.dart';


abstract class PizzaRepo {
    Future<List<Pizza>> getPizzas();

}