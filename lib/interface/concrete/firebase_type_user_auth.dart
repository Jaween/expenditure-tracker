import 'package:expenditure_tracker/interface/concrete/firebase_type_user.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/interface/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

/// Firebase implementation of the user authentication service.
class FirebaseTypeUserAuth extends UserAuth {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleAuth = _GoogleAuth();

  @override
  Stream<User> currentUserStream() => currentUser().asStream();

  @override
  Future<User> currentUser() async => FirebaseTypeUser(await _firebaseAuth.currentUser());

  @override
  Future<User> signInAnonymously() async {
    final firebaseUser = await _firebaseAuth.signInAnonymously();
    return FirebaseTypeUser(firebaseUser);
  }

  @override
  Future<User> signInWithEmailAndPassword(String username, String password) {
    // TODO
    return null;
  }

  @override
  Future<User> signInWithGoogle() async {
    final firebaseUser = await _googleAuth.signIn(_firebaseAuth);
    return FirebaseTypeUser(firebaseUser);
  }

  @override
  Future<User> linkWithGoogle() async {
    final credentials = await _googleAuth.credentials(_firebaseAuth);
    final firebaseUser = await _firebaseAuth.linkWithGoogleCredential(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken
    );
    return FirebaseTypeUser(firebaseUser);
  }

  @override
  Future<void> signOut() async {
    final firebaseUser = await _firebaseAuth.currentUser();
    print("${firebaseUser.providerId}");
    await _firebaseAuth.signOut();
    await _googleAuth.signOut();
  }
}

/// Handles Google specific account management.
class _GoogleAuth {
  final _googleSignIn = GoogleSignIn(
    scopes:[
    'email',
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