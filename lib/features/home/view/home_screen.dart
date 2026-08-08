import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:pizzaria_app/features/auth/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizzaria_app/features/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizzaria_app/features/home/data/pizza_catalog.dart';
import 'package:pizzaria_app/features/home/widgets/pizza_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Image.asset('assets/8.png', scale: 14),
            const SizedBox(width: 8),
            const Text(
              'PIZZA',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.cart),
          ),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ],
      ),
      body: BlocBuilder<GetPizzaBloc, GetPizzaState>(
        builder: (context, state) {
          if (state is GetPizzaLoading || state is GetPizzaInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // O Firestore pode estar vazio (ou fora do ar) enquanto o menu ainda
          // nao foi cadastrado: nesse caso mostramos o catalogo local para a
          // vitrine nunca aparecer em branco.
          final remotePizzas =
              state is GetPizzaSuccess ? state.pizzas : const <Pizza>[];
          final pizzas =
              remotePizzas.isNotEmpty ? remotePizzas : buildLocalPizzaCatalog();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: PizzaGrid(pizzas: pizzas),
          );
        },
      ),
    );
  }
}

/// Grade de sabores. Extraida da [HomeScreen] para poder ser testada sozinha.
class PizzaGrid extends StatelessWidget {
  final List<Pizza> pizzas;

  const PizzaGrid({super.key, required this.pizzas});

  static const double _crossAxisSpacing = 16;

  /// Altura reservada para o texto do card (etiquetas, nome, descricao e
  /// preco). E um valor absoluto: a foto ocupa um quadrado do tamanho da
  /// coluna, mas o bloco de texto nao pode encolher junto em telas estreitas,
  /// senao o conteudo estoura.
  static const double _contentHeight = 165;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - _crossAxisSpacing) / 2;
        final tileHeight = tileWidth + _contentHeight;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: _crossAxisSpacing,
            mainAxisSpacing: 16,
            childAspectRatio: tileWidth / tileHeight,
          ),
          itemCount: pizzas.length,
          itemBuilder: (context, i) {
            final pizza = pizzas[i];
            return PizzaCard(pizza: pizza, picture: pizzaPictureFor(pizza, i));
          },
        );
      },
    );
  }
}
