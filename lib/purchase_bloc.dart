import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/purchase.dart';
import 'package:rxdart/rxdart.dart';

/// Control and logic exposing actions and Streams for the expenditure list UI.
class PurchaseBloc {

  final Repository _repository;

  final _items = BehaviorSubject<List<ExpenditureListItem>>();
  Stream<List<ExpenditureListItem>> get items => _items.stream;

  PurchaseBloc(this._repository) {
    _repository.purchases.listen((purchases) {
      var reverseSortedPurchases = List<Purchase>.from(purchases, growable: false);
      reverseSortedPurchases.sort((Purchase a, Purchase b) => -a.date.compareTo(b.date));

      final purchasesSeparatedByDate = _generatePurchasesSeparatedByDate(reverseSortedPurchases);
      _items.add(purchasesSeparatedByDate);
    });
  }

  Future<void> createOrUpdatePurchase(Purchase purchase) async =>
      _repository.createOrUpdatePurchase(purchase);

  Future<void> deletePurchase(Purchase purchase) async =>
      _repository.deletePurchase(purchase);

  /// Creates a list of purchases, separated with items holding the date of those purchases.
  ///
  /// [purchases] must be sorted (ascending or descending) by date.
  List<ExpenditureListItem> _generatePurchasesSeparatedByDate(List<Purchase> purchases) {
    DateTime headingDate;
    final items = <ExpenditureListItem>[];
    purchases.forEach((purchase) {
      if (headingDate == null ||
        !(headingDate.year == purchase.date.year &&
          headingDate.month == purchase.date.month &&
          headingDate.day == purchase.date.day)) {
        headingDate = purchase.date;
        items.add(ExpenditureListItem(headingDate, null));
      }
      items.add(ExpenditureListItem(null, purchase));
    });
    return items;
  }

  void dispose() {
    _items.close();
  }
}

/// Data class for items in the expenditures list (including date headers).
///
/// One of either [date] or [purchase] will be non-null.
class ExpenditureListItem {
  final DateTime date;
  final Purchase purchase;

  ExpenditureListItem(this.date, this.purchase);
}