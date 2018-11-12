import 'package:expenditure_tracker/firebase_type_repository.dart';
import 'package:expenditure_tracker/firebase_type_sign_in.dart';
import 'package:expenditure_tracker/purchase_screen.dart';
import 'package:expenditure_tracker/sign_in_screen.dart';
import 'package:flutter/material.dart';

class ExpenditureTrack extends StatefulWidget {
  @override State<StatefulWidget> createState() => ExpenditureTrackState();
}

class ExpenditureTrackState extends State<ExpenditureTrack> {

  FirebaseTypeSignIn _signIn;
  FirebaseTypeRepository _repository;

  @override
  void initState() {
    super.initState();
    _signIn = FirebaseTypeSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenditure Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(_signIn),
      routes: <String, WidgetBuilder>{
        '/sign-in': (BuildContext context) => SignInScreen(_signIn),
        '/purchase-list': (BuildContext context) {
          _repository = FirebaseTypeRepository(_signIn.user);
          return PurchaseScreen(_repository);
        },
      },
    );
  }
}