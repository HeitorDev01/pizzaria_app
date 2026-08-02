/// Regras de validacao compartilhadas pelos formularios de autenticacao.
///
/// Antes cada tela repetia as mesmas expressoes regulares; centralizar aqui
/// garante que login e cadastro cobrem exatamente os mesmos criterios.
class Validators {
  const Validators._();

  static const int minPasswordLength = 8;
  static const int maxNameLength = 30;

  static final RegExp _email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _upperCase = RegExp(r'[A-Z]');
  static final RegExp _lowerCase = RegExp(r'[a-z]');
  static final RegExp _number = RegExp(r'[0-9]');
  static final RegExp _specialChar =
      RegExp(r'''[!@#$&*~`)%\-(_+=;:,.<>/?"\[{\]}|^]''');

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Preencha este campo';
    if (!_email.hasMatch(value)) return 'Informe um e-mail valido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Preencha este campo';
    if (!PasswordRequirements.of(value).isValid) {
      return 'A senha nao atende aos requisitos';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Preencha este campo';
    if (value.length > maxNameLength) return 'Nome muito longo';
    return null;
  }
}

/// Quais requisitos uma senha ja cumpre.
///
/// A tela de cadastro usa isso para o checklist que fica verde conforme o
/// usuario digita, e [Validators.password] usa para decidir se o campo passa.
/// Uma unica fonte de verdade para as duas coisas.
class PasswordRequirements {
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool hasMinLength;

  const PasswordRequirements({
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecialChar,
    required this.hasMinLength,
  });

  static const empty = PasswordRequirements(
    hasUpperCase: false,
    hasLowerCase: false,
    hasNumber: false,
    hasSpecialChar: false,
    hasMinLength: false,
  );

  factory PasswordRequirements.of(String value) => PasswordRequirements(
        hasUpperCase: Validators._upperCase.hasMatch(value),
        hasLowerCase: Validators._lowerCase.hasMatch(value),
        hasNumber: Validators._number.hasMatch(value),
        hasSpecialChar: Validators._specialChar.hasMatch(value),
        hasMinLength: value.length >= Validators.minPasswordLength,
      );

  bool get isValid =>
      hasUpperCase &&
      hasLowerCase &&
      hasNumber &&
      hasSpecialChar &&
      hasMinLength;
}
