import 'package:flutter/material.dart';
import 'package:pizzaria_app/core/validators/validators.dart';

/// Checklist que fica verde conforme a senha digitada cumpre cada requisito.
class PasswordChecklist extends StatelessWidget {
  final PasswordRequirements requirements;

  const PasswordChecklist({super.key, required this.requirements});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Item('1 letra maiuscula', met: requirements.hasUpperCase),
            _Item('1 letra minuscula', met: requirements.hasLowerCase),
            _Item('1 numero', met: requirements.hasNumber),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Item('1 caractere especial', met: requirements.hasSpecialChar),
            _Item(
              'minimo ${Validators.minPasswordLength} caracteres',
              met: requirements.hasMinLength,
            ),
          ],
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final bool met;

  const _Item(this.label, {required this.met});

  @override
  Widget build(BuildContext context) {
    final color =
        met ? Colors.green : Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
