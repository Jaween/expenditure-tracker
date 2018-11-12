import 'package:expenditure_tracker/interface/user.dart';

abstract class SignIn {

  User get user;
  Future<User> signInAnonymously();
  Future<void> signOut();
}