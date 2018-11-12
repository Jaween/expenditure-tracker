import 'package:expenditure_tracker/interface/user.dart';

abstract class SignIn {
  Future<User> signInAnonymously() async {
    return null;
  }

  Future<void> signOut() async { }
}