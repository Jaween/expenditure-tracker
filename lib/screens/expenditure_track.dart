import 'package:expenditure_tracker/interface/concrete/firebase_type_repository.dart';
import 'package:expenditure_tracker/interface/concrete/firebase_type_user_auth.dart';
import 'package:expenditure_tracker/interface/concrete/geolocator_type_location.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/interface/user_auth.dart';
import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/create/create_bloc.dart';
import 'package:expenditure_tracker/screens/create/create_screen.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_bloc.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_screen.dart';
import 'package:expenditure_tracker/screens/login/login_bloc.dart';
import 'package:expenditure_tracker/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:quiver/time.dart';

class ExpenditureTrack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpenditureTrackState();
}

class ExpenditureTrackState extends State<ExpenditureTrack> {
  UserAuth _userAuth;
  Repository _repository;
  @override
  void initState() {
    super.initState();
    _userAuth = FirebaseTypeUserAuth();
    _repository = FirebaseTypeRepository(null);

    _userAuth.currentUserStream().listen((user) => _repository.user = user);
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
          final navigationRouter = _createNavigationRouter(context);
          return BlocProvider<LoginBloc>(
            blocBuilder: () {
              return LoginBloc(_userAuth, navigationRouter);
            },
            child: LoginScreen()
          );
        },
      ),
    );
  }

  void _navigateToExpenditureHistory(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          final navigationRouter = _createNavigationRouter(context);
          return BlocProvider<ExpenditureHistoryBloc>(
            blocBuilder: () {
              return ExpenditureHistoryBloc(
                navigationRouter,
                _repository,
                _userAuth,
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
              final navigationRouter = _createNavigationRouter(context);
              return CreateBloc(
                navigationRouter,
                _repository,
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

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BlocProvider<LoginBloc>(
            blocBuilder: () {
              final navigationRouter = _createNavigationRouter(context);
              return LoginBloc(
                _userAuth,
                navigationRouter,
              );
            },
            child: LoginScreen(),
          );
        },
      ),
    );
  }

  NavigationRouter _createNavigationRouter(BuildContext context) {
    return NavigationRouter(
      onNavigateBack: () => Navigator.of(context).pop(),
      onNavigateToExpenditureHistoryScreen: () => _navigateToExpenditureHistory(context),
      onNavigateToCreateScreen: (expenditure) => _navigateToCreateScreen(context, expenditure),
      onNavigateToLoginScreen: () => _navigateToLoginScreen(context),
    );
  }
}
