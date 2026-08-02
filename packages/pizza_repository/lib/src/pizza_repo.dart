import 'models/models.dart';
export 'models/models.dart';

abstract class PizzaRepo {
    Future<List<Pizza>> getPizzas();

}