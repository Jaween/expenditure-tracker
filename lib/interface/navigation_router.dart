import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:meta/meta.dart';

class NavigationRouter {
  final void Function() onNavigateBack;
  final void Function() onNavigateToHubScreen;
  final void Function(Expenditure expenditure) onNavigateToCreateScreen;
  final void Function() onNavigateToLoginScreen;
  final void Function() onRestart;

  NavigationRouter({
    @required this.onNavigateBack,
    @required this.onNavigateToHubScreen,
    @required this.onNavigateToCreateScreen,
    @required this.onNavigateToLoginScreen,
    @required this.onRestart,
  });

  void navigateBack() => onNavigateBack;
  void navigateToHubScreen() => onNavigateToHubScreen();
  void navigateToCreateScreen({Expenditure expenditure}) => onNavigateToCreateScreen(expenditure);
  void navigateToLoginScreen() => onNavigateToLoginScreen();
  void restartApp() => onRestart();
}
