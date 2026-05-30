import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/src/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' ;

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');
  
  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
      
        @override
        Future<void> setUserData(user) {
          // TODO: implement setUserData
          throw UnimplementedError();
        }
      
        @override
        Future<void> signIn(String email, String password) {
          // TODO: implement signIn
          throw UnimplementedError();
        }
      
        @override
        Future<void> signOut() {
          // TODO: implement signOut
          throw UnimplementedError();
        }
      
        @override
        singUp(MyUser, String password) {
          // TODO: implement singUp
          throw UnimplementedError();
        }
      
        @override
        // TODO: implement user
        get user => throw UnimplementedError();
  }