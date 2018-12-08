import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';

abstract class Repository {
  Repository(User user);
  set user(User user);
  Stream<List<Expenditure>> get expenditures;
  Future<void> createExpenditure(Expenditure expenditure);
  Future<void> updateExpenditure(Expenditure expenditure);
  Future<void> deleteExpenditure(Expenditure expenditure);
}