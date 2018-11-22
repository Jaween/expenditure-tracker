import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/interface/sign_in.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {

  final NavigationRouter _navigationRouter;
  final SignIn _signIn;

  SignInScreen(this._signIn, this._navigationRouter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 64.0),
            child: Text(
              "Expenditure Tracker",
              style: TextStyle(
                fontSize: 30
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.0, bottom: 32.0, right: 32.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "User name"
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.0, bottom: 32.0, right: 32.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password"
              )
            ),
          ),
          RaisedButton(
            textTheme: ButtonTextTheme.primary,
            color: Theme.of(context).accentColor,
            onPressed: () {},
            child: Text("Sign in"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: FlatButton(
              textTheme: ButtonTextTheme.accent,
              onPressed: () async {
                var user = await _signIn.signInAnonymously();
                print("User name is ${user.displayName}, id is ${user.userId}, anon? ${user.isAnonymous}");
                //Navigator.of(context).pushNamed('/expenditure-history');
                _navigationRouter.onNavigateToExpenditureHistoryScreen();
              },
              child: Text("Continue without signing in"),
            ),
          )
        ],
      ),
    );
  }
}