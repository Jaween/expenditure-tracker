import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/login/login_bloc.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
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
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 180,
                child: RaisedButton(
                  child: Text("Sign in with Facebook"),
                  color: Colors.blue,
                  onPressed: () {},
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 180,
                child: RaisedButton(
                  child: Text("Sign in with Google"),
                  color: Colors.red,
                  onPressed: () => bloc.actionSignInWithGoogle.add(null),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}