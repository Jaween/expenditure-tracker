import 'package:expenditure_tracker/interface/concrete/firebase_type_repository.dart';
import 'package:expenditure_tracker/interface/concrete/firebase_type_sign_in.dart';
import 'package:expenditure_tracker/interface/concrete/geolocator_type_location.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/create/create_bloc.dart';
import 'package:expenditure_tracker/screens/create/create_screen.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_bloc.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_screen.dart';
import 'package:expenditure_tracker/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:quiver/time.dart';

class ExpenditureTrack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpenditureTrackState();
}

class ExpenditureTrackState extends State<ExpenditureTrack> {
  FirebaseTypeSignIn _signIn;
  NavigationRouter _navigationRouter;

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
      home: Builder(
        builder: (BuildContext context) {
          _navigationRouter = NavigationRouter(
            onNavigateBack: () => Navigator.of(context).pop(),
            onNavigateToExpenditureHistoryScreen: () => _navigateToExpenditureHistory(context),
            onNavigateToCreateScreen: (expenditure) => _navigateToCreateScreen(context, expenditure)
          );
          return SignInScreen(_signIn, _navigationRouter);
        },
      ),
    );
  }

  void _navigateToExpenditureHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BlocProvider<ExpenditureHistoryBloc>(
            blocBuilder: () {
              return ExpenditureHistoryBloc(
                _navigationRouter,
                FirebaseTypeRepository(_signIn.user)
              );
            },
            child: ExpenditureHistoryScreen(),
          );
        }
      ),
    );
  }

  void _navigateToCreateScreen(BuildContext context, [Expenditure expenditure]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BlocProvider<CreateBloc>(
            blocBuilder: () {
              return CreateBloc(
                _navigationRouter,
                FirebaseTypeRepository(_signIn.user),
                GeolocatorTypeLocation(),
                Clock(),
                expenditure
              );
            },
            child: Builder(
              builder: (context) {
                final createBloc = BlocProvider.of<CreateBloc>(context);
                return CreateScreen(createBloc: createBloc);
              }
            ),
          );
        }
      ),
    );
  }
}
