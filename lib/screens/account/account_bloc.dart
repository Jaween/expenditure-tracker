import 'package:expenditure_tracker/base_bloc.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/interface/user_auth.dart';
import 'package:rxdart/rxdart.dart';

/// Business logic for the user's account screen.
class AccountBloc extends BlocBase {
  final NavigationRouter _navigationRouter;
  final UserAuth _userAuth;

  Stream<User> get currentUserStream => _userAuth.currentUserStream();

  final _actionSignIn = BehaviorSubject<void>();
  Sink<void> get actionSignIn => _actionSignIn.sink;

  final _actionLinkAccountGoogle = BehaviorSubject<void>();
  Sink<void> get actionLinkAccountGoogle => _actionLinkAccountGoogle.sink;

  final _actionUnlinkAccount = BehaviorSubject<void>();
  Sink<void> get actionUnlinkAccount => _actionUnlinkAccount.sink;

  final _actionSignOut = BehaviorSubject<void>();
  Sink<void> get actionSignOut => _actionSignOut.sink;

  final _actionDeleteAccount = BehaviorSubject<void>();
  Sink<void> get actionDeleteAccount => _actionDeleteAccount.sink;

  AccountBloc(this._navigationRouter, this._userAuth) {
    _actionSignIn.stream.listen((_) {
      _navigationRouter.navigateToLoginScreen();
    });

    _actionLinkAccountGoogle.stream.listen((_) async {
      await _userAuth.linkWithGoogle();
    });

    _actionUnlinkAccount.stream.listen((_) {
      /*_userAuth.currentUser().then((user) {
        // TODO(jaween): firebase_auth doesn't yet support unlinking from providers
      });*/
    });

    _actionSignOut.stream.listen((_) async {
      await _userAuth.signOut();
      _navigationRouter.restartApp();
    });

    _actionDeleteAccount.stream.listen((_) async {
      await _userAuth.deleteCurrentUser();
      _navigationRouter.restartApp();
    });
  }

  @override
  void dispose() {
    _actionSignIn.close();
    _actionLinkAccountGoogle.close();
    _actionUnlinkAccount.close();
    _actionSignOut.close();
    _actionDeleteAccount.close();
  }
}