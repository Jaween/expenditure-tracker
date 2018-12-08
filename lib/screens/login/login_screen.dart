import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/login/login_bloc.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer(),
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
                prefixIcon: Icon(Icons.person),
                hintText: "User name"
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.0, bottom: 32.0, right: 32.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                hintText: "Password"
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 32, right: 16),
                  child: FlatButton(
                    child: Text("Sign Up"),
                    onPressed: () {},
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 32),
                  child: MaterialButton(
                    textTheme: ButtonTextTheme.primary,
                    color: Theme.of(context).accentColor,
                    child: Text("Sign In"),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "or",
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 32, right: 16),
                        child: RaisedButton(
                          child: Text("Facebook"),
                          onPressed: () => bloc.actionSignOut.add(null),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 32),
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text("Google"),
                          onPressed: () => bloc.actionSignInWithGoogle.add(null),
                        ),
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  textTheme: ButtonTextTheme.accent,
                  onPressed: () => bloc.actionSignInAnonymously.add(null),
                  child: Text("Continue without signing in"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}