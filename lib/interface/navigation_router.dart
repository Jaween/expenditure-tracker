import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:meta/meta.dart';

class NavigationRouter {
  final void Function() onNavigateBack;
  final void Function() onNavigateToExpenditureHistoryScreen;
  final void Function(Expenditure) onNavigateToCreateScreen;

  NavigationRouter({
    @required this.onNavigateBack,
    @required this.onNavigateToExpenditureHistoryScreen,
    @required this.onNavigateToCreateScreen,
  });

  void navigateBack() => onNavigateBack;
  void navigateToExpenditureHistoryScreen() => onNavigateToExpenditureHistoryScreen();
  void navigateToCreateScreen({Expenditure expenditure}) => onNavigateToCreateScreen(expenditure);
}
