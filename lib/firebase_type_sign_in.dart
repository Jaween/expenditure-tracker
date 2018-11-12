import 'package:expenditure_tracker/firebase_type_user.dart';
import 'package:expenditure_tracker/interface/sign_in.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTypeSignIn extends SignIn {

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> signInAnonymously() async {
    final firebaseUser = await _firebaseAuth.signInAnonymously();
    return FirebaseTypeUser(firebaseUser);
  }

  @override
  Future<void> signOut() async => await _firebaseAuth.signOut();
}