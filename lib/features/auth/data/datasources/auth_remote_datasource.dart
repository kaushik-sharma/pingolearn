import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<String> signUp(String email, String password, String name);

  Future<void> saveUserInDb(String email, String name);

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
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await userCredential.user!.updateDisplayName(name);

    return (await userCredential.user!.getIdToken())!;
  }

  @override
  Future<String> signIn(String email, String password) async {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return (await userCredential.user!.getIdToken())!;
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> saveUserInDb(String email, String name) async {
    final user = UserModel(email: email, name: name);
    await firebaseFirestore.collection('users').add(user.toJson());
  }
}
