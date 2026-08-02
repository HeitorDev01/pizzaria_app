import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

/// Usuario como o app o enxerga.
class MyUser extends Equatable {
  final String userId;
  final String name;
  final String email;
  final bool hasActivityCart;

  const MyUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.hasActivityCart,
  });

  /// Representa "ninguem logado". O AuthenticationBloc compara contra este
  /// valor, por isso MyUser precisa ser Equatable: comparar por identidade
  /// falharia para qualquer usuario vazio vindo de outra origem.
  static const empty = MyUser(
    userId: '',
    name: '',
    email: '',
    hasActivityCart: false,
  );

  MyUser copyWith({
    String? userId,
    String? name,
    String? email,
    bool? hasActivityCart,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      hasActivityCart: hasActivityCart ?? this.hasActivityCart,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      name: name,
      email: email,
      hasActivityCart: hasActivityCart,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      hasActivityCart: entity.hasActivityCart,
    );
  }

  @override
  List<Object?> get props => [userId, name, email, hasActivityCart];
}
