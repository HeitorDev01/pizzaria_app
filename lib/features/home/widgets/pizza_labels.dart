import 'package:flutter/material.dart';
import 'package:pizza_repository/pizza_repository.dart';

/// Preco final e rotulos derivados do sabor, compartilhados entre a home e a
/// tela de detalhes para as duas nunca mostrarem valores diferentes.
extension PizzaPresentation on Pizza {
  /// Preco ja com o desconto aplicado (`discount` e uma porcentagem).
  double get discountedPrice => price - (price * discount / 100);

  String get formattedPrice => '\$${discountedPrice.toStringAsFixed(2)}';

  String get formattedOriginalPrice => '\$${price.toStringAsFixed(2)}';

  bool get hasDiscount => discount > 0;
}

/// Etiqueta "VEG" / "NON-VEG".
class VegBadge extends StatelessWidget {
  final bool isVeg;

  const VegBadge({super.key, required this.isVeg});

  @override
  Widget build(BuildContext context) {
    return _Badge(
      label: isVeg ? 'VEG' : 'NON-VEG',
      color: isVeg ? Colors.green : Colors.red,
      filled: true,
    );
  }
}

/// Etiqueta de picancia: 1 = BLAND, 2 = BALANCE, 3 = SPICY.
class SpicyBadge extends StatelessWidget {
  final int spicy;

  const SpicyBadge({super.key, required this.spicy});

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (spicy) {
      <= 1 => ('BLAND', Colors.green),
      2 => ('BALANCE', Colors.orange),
      _ => ('SPICY', Colors.redAccent),
    };

    return _Badge(label: '🌶️ $label', color: color, filled: false);
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;

  const _Badge({
    required this.label,
    required this.color,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : color,
            fontWeight: FontWeight.w800,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
