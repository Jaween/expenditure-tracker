import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/purchase.dart';

class PurchaseBloc {

  final Repository _repository;

  Stream<List<Purchase>> get purchases => _repository.purchases;

  PurchaseBloc(this._repository);

  Future<void> createOrUpdatePurchase(Purchase purchase) async =>
      _repository.createOrUpdatePurchase(purchase);

  Future<void> deletePurchase(Purchase purchase) async =>
      _repository.deletePurchase(purchase);
}