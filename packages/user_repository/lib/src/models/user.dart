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
