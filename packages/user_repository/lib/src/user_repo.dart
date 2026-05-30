abstract class UserRepository {
  Stream<MyUser> get user;
  Future<MyUser> singUp (MyUser, String password);
  Future<void> setUserData(MyUser user);
  Future<void> signIn (String email, String password);
  Future<void> signOut();
  

  
}