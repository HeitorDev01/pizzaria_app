import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<MyUser> get user {
    // switchMap (e nao flatMap): se o estado de auth mudar duas vezes seguidas,
    // a leitura antiga e descartada em vez de competir com a nova.
    return _firebaseAuth.authStateChanges().switchMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
      } else {
        yield await _loadProfile(firebaseUser);
      }
    });
  }

  /// Le o perfil em `users/{uid}`.
  ///
  /// Este stream comanda qual tela o app mostra, entao ele nunca pode lancar:
  /// um erro aqui derruba a assinatura inteira e o app trava na tela de login.
  /// Quando o documento ainda nao existe (logo apos o cadastro, antes do
  /// [setUserData]) ou o Firestore esta inacessivel, devolvemos o usuario
  /// montado a partir do proprio Firebase Auth - o suficiente para entrar.
  Future<MyUser> _loadProfile(User firebaseUser) async {
    final fromAuth = MyUser(
      userId: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
      hasActiveCart: false,
    );

    try {
      final snapshot = await usersCollection.doc(firebaseUser.uid).get();
      final data = snapshot.data();
      if (data == null) {
        log('Perfil ${firebaseUser.uid} ainda nao existe no Firestore.');
        return fromAuth;
      }
      return MyUser.fromEntity(MyUserEntity.fromDocument(data));
    } catch (e) {
      log('Falha ao ler o perfil ${firebaseUser.uid}: $e');
      return fromAuth;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );

      myUser = myUser.copyWith(userId: user.user!.uid);
      return myUser;
    } on FirebaseAuthException catch (e) {
      log('Falha no cadastro (${e.code}): ${e.message}');
      throw AuthFailure(_messageForSignUp(e.code));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  String _messageForSignUp(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este e-mail ja esta cadastrado';
      case 'invalid-email':
        return 'E-mail invalido';
      case 'weak-password':
        return 'Senha muito fraca';
      case 'operation-not-allowed':
        return 'Cadastro por e-mail e senha esta desativado no Firebase';
      case 'network-request-failed':
        return 'Sem conexao com o servidor';
      default:
        return 'Nao foi possivel criar a conta';
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
