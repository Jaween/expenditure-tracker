import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/purchase.dart';

abstract class Repository {

  Stream<List<Purchase>> get purchases;

  Repository(User user);

  Future<void> createPurchase(Purchase purchase);
  Future<void> updatePurchase(Purchase purchase);
  Future<void> deletePurchase(Purchase purchase);
}