import 'package:expenditure_tracker/interface/user.dart';

abstract class UserAuth {
  Stream<User> currentUserStream();
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String username, String password);
  Future<User> signInWithGoogle();
  Future<void> signOut();
}