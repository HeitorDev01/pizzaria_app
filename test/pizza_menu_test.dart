import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzaria_app/features/home/data/pizza_catalog.dart';
import 'package:pizzaria_app/features/home/view/details_screen.dart';
import 'package:pizzaria_app/features/home/view/home_screen.dart';
import 'package:pizzaria_app/features/home/widgets/pizza_labels.dart';

void main() {
  final catalog = buildLocalPizzaCatalog();

  test('cada sabor do catalogo tem foto, nome e descricao proprios', () {
    expect(catalog, isNotEmpty);

    final pictures = catalog.map((p) => p.picture).toSet();
    final names = catalog.map((p) => p.name).toSet();
    final descriptions = catalog.map((p) => p.description).toSet();

    expect(pictures.length, catalog.length, reason: 'fotos repetidas');
    expect(names.length, catalog.length, reason: 'nomes repetidos');
    expect(descriptions.length, catalog.length, reason: 'descricoes repetidas');

    for (final pizza in catalog) {
      expect(pizza.picture, startsWith('assets/'));
      expect(pizza.description.length, greaterThan(40));
    }
  });

  test('preco com desconto e menor que o preco cheio', () {
    for (final pizza in catalog) {
      expect(pizza.discountedPrice, lessThan(pizza.price.toDouble()));
      expect(pizza.discountedPrice, greaterThan(0));
    }
  });

  testWidgets('a grade renderiza os sabores sem estourar o layout',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: PizzaGrid(pizzas: catalog),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Burrata Caprese'), findsOneWidget);
    expect(find.text('NON-VEG'), findsWidgets);
  });

  testWidgets('a grade tambem cabe numa tela estreita', (tester) async {
    tester.view.physicalSize = const Size(640, 1136);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: PizzaGrid(pizzas: catalog),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('a tela de detalhes mostra descricao, macros e precos',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final pizza = catalog.first;

    await tester.pumpWidget(MaterialApp(home: DetailsScreen(pizza: pizza)));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(pizza.name), findsOneWidget);
    expect(find.text(pizza.description), findsOneWidget);
    expect(find.text(pizza.formattedPrice), findsOneWidget);
    expect(find.text(pizza.formattedOriginalPrice), findsOneWidget);
    expect(find.text('${pizza.macros.calories} Calories'), findsOneWidget);
  });
}
