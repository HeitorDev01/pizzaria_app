import 'package:user_repository/src/entities/entities.dart';

class MyUser {
  final String userId;
  final String name;
  final String email;
  final bool hasActivityCart;

  MyUser({
    required this.userId, 
    required this.name, 
    required this.email, 
    required this.hasActivityCart, 
    });

    static final empty = MyUser(
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
  String toString() {
   return 'MyUser: $userId, $name, $email, $hasActivityCart';
}
}
