import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/interface/purchase.dart';

abstract class Repository {

  Stream<List<Purchase>> get purchases;

  Repository(User user);

  Future<void> createOrUpdatePurchase(Purchase purchase);
  Future<void> deletePurchase(Purchase purchase);
}