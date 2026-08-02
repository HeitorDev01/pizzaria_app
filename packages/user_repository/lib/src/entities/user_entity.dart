import 'package:equatable/equatable.dart';

/// Formato do usuario como ele e gravado no Firestore.
class MyUserEntity extends Equatable {
  final String userId;
  final String name;
  final String email;
  final bool hasActivityCart;

  const MyUserEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.hasActivityCart,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'hasActivityCart': hasActivityCart,
    };
  }

  /// Le o documento tolerando campos ausentes: um `as String` direto em
  /// documento antigo ou incompleto derruba o stream de autenticacao inteiro.
  static MyUserEntity fromDocument(Map<String, Object?> document) {
    return MyUserEntity(
      userId: document['userId'] as String? ?? '',
      name: document['name'] as String? ?? '',
      email: document['email'] as String? ?? '',
      hasActivityCart: document['hasActivityCart'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [userId, name, email, hasActivityCart];
}
