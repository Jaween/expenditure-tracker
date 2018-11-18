import 'package:expenditure_tracker/interface/concrete/firebase_type_user.dart';
import 'package:expenditure_tracker/interface/sign_in.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTypeSignIn extends SignIn {

  final _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  @override
  User get user => FirebaseTypeUser(_firebaseUser);

  @override
  Future<User> signInAnonymously() async {
    final firebaseUser = await _firebaseAuth.signInAnonymously();
    _firebaseUser = firebaseUser;
    return FirebaseTypeUser(firebaseUser);
  }

  @override
  Future<void> signOut() async => await _firebaseAuth.signOut();
}