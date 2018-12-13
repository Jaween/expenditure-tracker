import 'package:expenditure_tracker/interface/concrete/firebase_type_repository.dart';
import 'package:expenditure_tracker/interface/concrete/firebase_type_user_auth.dart';
import 'package:expenditure_tracker/interface/concrete/geolocator_type_location.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/screens/account/account_bloc.dart';
import 'package:expenditure_tracker/screens/account/account_screen.dart';
import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/create/create_bloc.dart';
import 'package:expenditure_tracker/screens/create/create_screen.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_bloc.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_screen.dart';
import 'package:expenditure_tracker/screens/login/login_bloc.dart';
import 'package:expenditure_tracker/screens/login/login_screen.dart';
import 'package:expenditure_tracker/widget/restart_widget.dart';
import 'package:flutter/material.dart';
import 'package:quiver/time.dart';

class ExpenditureTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: ExpenditureTrackBody(),
    );
  }
}

class ExpenditureTrackBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpenditureTrackBodyState();
}

class ExpenditureTrackBodyState extends State<ExpenditureTrackBody>
    with SingleTickerProviderStateMixin {
  FirebaseTypeUserAuth _userAuth;
  Repository _repository;

  TabController _tabController;
  int _fabIndex = 0;

  @override
  void initState() {
    super.initState();
    _userAuth = FirebaseTypeUserAuth();
    _repository = FirebaseTypeRepository(null);

    _userAuth.currentUserStream().listen((user) => _repository.user = user);

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _fabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _userAuth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenditure Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Builder(
        builder: (BuildContext context) => _createHub(context),
      ),
    );
  }

  void _navigateToHubScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => _createHub(context),
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
        builder: (BuildContext context) => _createLoginScreen(context),
      ),
    );
  }

  void _restart(BuildContext context) {
    setState(() {
      final RestartWidgetState restartWidgetState =
          context.ancestorStateOfType(const TypeMatcher<RestartWidgetState>());
      restartWidgetState.restart();
    });
  }

  Widget _createHub(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenditrack"),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: "History",),
            Tab(text: "Account"),
          ],
        ),
      ),
      floatingActionButton: _fabIndex != 0 ? null : FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _createExpenditureHistory(context),
          _createAccountScreen(context),
        ],
      ),
    );
  }

  Widget _createExpenditureHistory(BuildContext context) {
    final navigationRouter = _createNavigationRouter(context);
    return BlocProvider<ExpenditureHistoryBloc>(
      blocBuilder: () {
        return ExpenditureHistoryBloc(
          navigationRouter,
          _repository,
        );
      },
      child: ExpenditureHistoryScreen(),
    );
  }

  Widget _createAccountScreen(BuildContext context) {
    final navigationRouter = _createNavigationRouter(context);
    return BlocProvider<AccountBloc>(
      blocBuilder: () {
        return AccountBloc(
          navigationRouter,
          _userAuth
        );
      },
      child: AccountScreen()
    );
  }

  Widget _createLoginScreen(BuildContext context) {
    final navigationRouter = _createNavigationRouter(context);
    return BlocProvider<LoginBloc>(
      blocBuilder: () {
        return LoginBloc(
          _userAuth,
          navigationRouter);
      },
      child: LoginScreen()
    );
  }

  NavigationRouter _createNavigationRouter(BuildContext context) {
    return NavigationRouter(
      onNavigateBack: () => Navigator.of(context).pop(),
      onNavigateToHubScreen: () => _navigateToHubScreen(context),
      onNavigateToCreateScreen: (expenditure) => _navigateToCreateScreen(context, expenditure),
      onNavigateToLoginScreen: () => _navigateToLoginScreen(context),
      onRestart: () => _restart(context),
    );
  }
}
