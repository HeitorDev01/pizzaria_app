class MyUserEntity {
  final String userId;
  final String name;
  final String email;
  final bool hasActivityCart;

  MyUserEntity ({
    required this.userId, 
    required this.name, 
    required this.email, 
    required this.hasActivityCart, 
    });

    Map <String, Object?> toDocument() {
      return {
        'userId': userId,
        'name': name,
        'email': email,
        'hasActivityCart': hasActivityCart,
      };
    }
    static MyUserEntity fromDocument(Map<String, Object?> document) {
      return MyUserEntity(
        userId: document['userId'] as String,
        name: document['name'] as String,
        email: document['email'] as String,
        hasActivityCart: document['hasActivityCart'] as bool,
      );
    }
}