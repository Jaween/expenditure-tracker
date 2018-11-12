import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/purchase.dart';

class PurchaseBloc {

  final Repository _repository;

  Stream<List<Purchase>> get purchases => _repository.purchases;

  PurchaseBloc(this._repository);

  Future<void> addPurchase(Purchase purchase) async =>
      _repository.createPurchase(purchase);

  Future<void> updatePurchase(Purchase purchase) async =>
      _repository.updatePurchase(purchase);

  Future<void> deletePurchase(Purchase purchase) async =>
      _repository.deletePurchase(purchase);
}