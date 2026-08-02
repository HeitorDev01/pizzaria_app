import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference<Map<String, dynamic>> _usersCollection;

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _usersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('users');

  /// Detalhe do erro so em debug: em release a mensagem crua do Firebase vai
  /// parar no logcat, que outros apps do aparelho conseguem ler.
  void _logError(Object error) {
    if (kDebugMode) log(error.toString(), name: 'user_repository');
  }

  @override
  Stream<MyUser> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
        return;
      }

      final doc = await _usersCollection.doc(firebaseUser.uid).get();
      final data = doc.data();

      // O documento pode nao existir ainda: entre createUser e setUserData ha
      // uma janela em que o usuario esta autenticado sem perfil no Firestore.
      yield data == null
          ? MyUser.empty.copyWith(
              userId: firebaseUser.uid,
              email: firebaseUser.email ?? '',
            )
          : MyUser.fromEntity(MyUserEntity.fromDocument(data));
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _logError(e);
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );
      return myUser.copyWith(userId: credential.user!.uid);
    } catch (e) {
      _logError(e);
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await _usersCollection.doc(user.userId).set(user.toEntity().toDocument());
    } catch (e) {
      _logError(e);
      rethrow;
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}
