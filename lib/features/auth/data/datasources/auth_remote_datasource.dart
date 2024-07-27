import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<String> signUp(String email, String password, String name);

  Future<String> signIn(String email, String password);

  Future<void> signOut();
}

class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<String> signUp(String email, String password, String name) async {
    final UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    final user = UserModel(email: email, name: name);
    await firebaseFirestore.collection('users').add(user.toJson());

    return (await userCredential.user!.getIdToken())!;
  }

  @override
  Future<String> signIn(String email, String password) async {
    final UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    return (await userCredential.user!.getIdToken())!;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
