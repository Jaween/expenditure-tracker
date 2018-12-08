import 'package:expenditure_tracker/base_bloc.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/interface/user_auth.dart';
import 'package:rxdart/rxdart.dart';

typedef Future<User> _SignInMethod();

class LoginBloc extends BlocBase {
  final UserAuth _userAuth;
  final NavigationRouter _navigationRouter;

  final _userController = BehaviorSubject<User>();
  Stream<User> get userStream => _userController.stream;

  final _actionSignInAnonymouslyController = BehaviorSubject<void>();
  Sink<void> get actionSignInAnonymously => _actionSignInAnonymouslyController.sink;

  final _actionSignInWithGoogleController = BehaviorSubject<void>();
  Sink<void> get actionSignInWithGoogle => _actionSignInAnonymouslyController.sink;

  final _actionSignOutController = BehaviorSubject<void>();
  Sink<void> get actionSignOut => _actionSignOutController.sink;

  LoginBloc(this._userAuth, this._navigationRouter) {
    _actionSignInAnonymouslyController.listen((_) {
      _performSignIn(_userAuth.signInAnonymously);
    });

    _actionSignInWithGoogleController.listen((_) {
      _performSignIn(_userAuth.signInWithGoogle);
    });

    _actionSignOutController.listen((_) {
      _userAuth.signOut();
    });
  }

  void _performSignIn(_SignInMethod signInMethod) async {
    final user = await signInMethod();
    if (user != null) {
      _userController.sink.add(user);
      _navigationRouter.navigateToExpenditureHistoryScreen();
    }
  }

  @override
  void dispose() {
    _userController.close();
    _actionSignInAnonymouslyController.close();
    _actionSignInWithGoogleController.close();
    _actionSignOutController.close();
  }
}