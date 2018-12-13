import 'package:expenditure_tracker/interface/concrete/firebase_type_user.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/interface/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

typedef Future<FirebaseUser> _UserUpdater();

/// Firebase implementation of the user authentication service.
class FirebaseTypeUserAuth extends UserAuth {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleAuth = _GoogleAuth();

  final _currentUserController = BehaviorSubject<User>();

  FirebaseTypeUserAuth() {
    init();
  }

  void dispose() {
    _currentUserController.close();
  }

  void init() async {
    _updateUser(() async {
      final firebaseUser = await _firebaseAuth.currentUser();
      if (firebaseUser == null) {
        await signInAnonymously();
      }
      return await _firebaseAuth.currentUser();
    });
  }

  Future<User> _updateUser(_UserUpdater userUpdater) async {
    await userUpdater();
    final firebaseUser = await _firebaseAuth.currentUser();
    _currentUserController.sink.add(FirebaseTypeUser(firebaseUser));
    return FirebaseTypeUser(firebaseUser);
  }

  @override
  Stream<User> currentUserStream() => _currentUserController.stream;

  @override
  Future<User> signInAnonymously() {
    return _updateUser(() => _firebaseAuth.signInAnonymously());
  }

  @override
  Future<User> signInWithEmailAndPassword(String username, String password) {
    // TODO
    return null;
  }

  @override
  Future<User> signInWithGoogle() {
    // TODO(jaween): Merge anonymous account if expenditures available
    return _updateUser(() => _googleAuth.signIn(_firebaseAuth));
  }

  @override
  Future<User> linkWithGoogle() {
    return _updateUser(() async {
      final credentials = await _googleAuth.credentials(_firebaseAuth);
      return await _firebaseAuth.linkWithGoogleCredential(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken
      );
    });
  }

  @override
  Future<void> signOut() async {
    return _updateUser(() async {
      await _firebaseAuth.signOut();
      await _googleAuth.signOut();
    });
  }

  @override
  Future<void> deleteAccount() async {
    return _updateUser(() async {
      // TODO(jaween): Delete associated user content too
      final currentUser = await _firebaseAuth.currentUser();
      await currentUser.delete();
    });
  }


}

/// Handles Google specific account management.
class _GoogleAuth {
  final _googleSignIn = GoogleSignIn(
    scopes:[
      "email",
      "profile",
      "https://www.googleapis.com/auth/userinfo.profile",
    ]
  );

  /// Signs in to a Google account and returns the associated FirebaseUser.
  Future<FirebaseUser> signIn(FirebaseAuth _firebaseAuth) async {
    FirebaseUser user;
    try {
      final authentication = await credentials(_firebaseAuth);
      user = await _firebaseAuth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken
      );
    } catch (error) {
      print(error);
    }
    return user;
  }

  Future<GoogleSignInAuthentication> credentials(FirebaseAuth _firebaseAuth) async {
    final googleSignInAccount = await _googleSignIn.signIn();
    return await googleSignInAccount.authentication;
  }

  /// Signs out of the current signed in Google account.
  Future<void> signOut() async => await _googleSignIn.signOut();
}