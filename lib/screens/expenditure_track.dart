import 'package:expenditure_tracker/interface/concrete/firebase_type_repository.dart';
import 'package:expenditure_tracker/interface/concrete/firebase_type_sign_in.dart';
import 'package:expenditure_tracker/interface/concrete/geolocator_type_location.dart';
import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/create/create_bloc.dart';
import 'package:expenditure_tracker/screens/create/create_screen.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_bloc.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_screen.dart';
import 'package:expenditure_tracker/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

class ExpenditureTrack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpenditureTrackState();
}

class ExpenditureTrackState extends State<ExpenditureTrack> {
  FirebaseTypeSignIn _signIn;

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
        brightness: Brightness.dark,
      ),
      home: SignInScreen(_signIn),
      routes: <String, WidgetBuilder>{
        '/sign-in': (BuildContext context) => SignInScreen(_signIn),
        '/expenditure-history': (BuildContext context) {
          return BlocProvider<ExpenditureHistoryBloc>(
            bloc: ExpenditureHistoryBloc(FirebaseTypeRepository(_signIn.user)),
            child: ExpenditureHistoryScreen(),
          );
        },
        '/create': (BuildContext context) {
          return BlocProvider<CreateBloc>(
            bloc: CreateBloc(GeolocatorTypeLocation()),
            child: CreateScreen(FirebaseTypeRepository(_signIn.user)),
          );
        }
      },
    );
  }
}
