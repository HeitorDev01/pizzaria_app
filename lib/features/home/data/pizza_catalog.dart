import 'package:pizza_repository/pizza_repository.dart';

/// Menu embutido no app, usado enquanto o Firestore nao devolve nada.
///
/// Cada sabor aponta para a sua propria foto em `assets/`, entao a grade da
/// home e a tela de detalhes mostram a imagem certa sem depender da rede.
const List<String> _pictures = [
  'assets/1.png',
  'assets/2.png',
  'assets/3.png',
  'assets/4.png',
  'assets/5.png',
  'assets/6.png',
  'assets/7.png',
];

/// Foto usada quando um sabor vindo do Firestore nao tem `picture` valido.
const String fallbackPizzaPicture = 'assets/8.png';

/// Resolve o asset de um sabor, caindo em uma foto do catalogo quando o
/// documento do Firestore traz um caminho vazio ou inexistente.
String pizzaPictureFor(Pizza pizza, int index) {
  if (pizza.picture.startsWith('assets/')) {
    return pizza.picture;
  }
  if (_pictures.isEmpty) {
    return fallbackPizzaPicture;
  }
  return _pictures[index % _pictures.length];
}

List<Pizza> buildLocalPizzaCatalog() {
  return [
    Pizza(
      pizzaId: '1',
      picture: 'assets/1.png',
      isVeg: true,
      spicy: 1,
      name: 'Burrata Caprese',
      description:
          'Creamy burrata torn over slow-fermented Neapolitan dough, with '
          'red and yellow heirloom cherry tomatoes, hand-picked basil and a '
          'finish of cold-pressed olive oil.',
      price: 18,
      discount: 15,
      macros: Macros(calories: 272, proteins: 14, fat: 11, carbs: 30),
    ),
    Pizza(
      pizzaId: '2',
      picture: 'assets/2.png',
      isVeg: false,
      spicy: 3,
      name: 'Pepperoni Supreme',
      description:
          'Spicy pepperoni piled on sauteed mushrooms, black olives and '
          'green bell peppers, all held together by a double layer of melted '
          'mozzarella.',
      price: 21,
      discount: 20,
      macros: Macros(calories: 341, proteins: 18, fat: 17, carbs: 32),
    ),
    Pizza(
      pizzaId: '3',
      picture: 'assets/3.png',
      isVeg: true,
      spicy: 1,
      name: 'Quattro Formaggi',
      description:
          'Mozzarella, gorgonzola, provolone and aged parmesan melted into a '
          'single golden layer, seasoned with oregano and crowned with fresh '
          'basil.',
      price: 19,
      discount: 10,
      macros: Macros(calories: 318, proteins: 17, fat: 16, carbs: 29),
    ),
    Pizza(
      pizzaId: '4',
      picture: 'assets/4.png',
      isVeg: false,
      spicy: 2,
      name: 'Chicken Ranch',
      description:
          'Grilled chicken and smoked bacon with roasted red peppers and red '
          'onion, drizzled with creamy ranch and showered in fresh dill.',
      price: 22,
      discount: 18,
      macros: Macros(calories: 305, proteins: 24, fat: 13, carbs: 27),
    ),
    Pizza(
      pizzaId: '5',
      picture: 'assets/5.png',
      isVeg: true,
      spicy: 1,
      name: 'Classic Margherita',
      description:
          'San Marzano tomato sauce and fior di latte mozzarella on a '
          'wood-fired charred crust, topped with rocket leaves right out of '
          'the oven.',
      price: 16,
      discount: 12,
      macros: Macros(calories: 254, proteins: 12, fat: 9, carbs: 33),
    ),
    Pizza(
      pizzaId: '6',
      picture: 'assets/6.png',
      isVeg: false,
      spicy: 3,
      name: 'Meat Feast',
      description:
          'Calabrese sausage, ham, bacon and pepperoni with black olives and '
          'roasted peppers, baked on a cheese-stuffed crust for the hungriest '
          'nights.',
      price: 24,
      discount: 25,
      macros: Macros(calories: 396, proteins: 26, fat: 21, carbs: 34),
    ),
    Pizza(
      pizzaId: '7',
      picture: 'assets/7.png',
      isVeg: false,
      spicy: 2,
      name: 'Cheesy Marvel',
      description:
          'Pan-baked deep dish loaded with ham and triple mozzarella, pulled '
          'straight from the oven for a cheese stretch that never seems to '
          'end.',
      price: 20,
      discount: 15,
      macros: Macros(calories: 372, proteins: 20, fat: 19, carbs: 36),
    ),
  ];
}
