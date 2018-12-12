import 'package:expenditure_tracker/interface/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTypeUser extends User {
  final FirebaseUser _firebaseUser;

  FirebaseTypeUser(this._firebaseUser);

  @override
  String get displayName => _firebaseUser.displayName;

  @override
  String get userId => _firebaseUser.uid;

  @override
  bool get isAnonymous => _firebaseUser.isAnonymous;

  @override
  String get photoUrl => _firebaseUser.photoUrl;

  @override
  List<String> get linkedProviderIds =>
      _firebaseUser.providerData
        .map((userInfo) => userInfo.providerId)
        .where((provider) => provider != "firebase")
        .toList();
}
