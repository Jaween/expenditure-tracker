import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_tracker/Purchase.dart';
import 'package:rxdart/rxdart.dart';

class PurchaseBloc {

  final _purchases = BehaviorSubject<List<Purchase>>(seedValue: []);
  Stream<List<Purchase>> get purchases => _purchases;

  PurchaseBloc(Firestore firestore) {
    firestore.collection('users/CjNbwFWffJfUD8354Vm1/purchases').snapshots().listen((data) {
      print("Have ${data.documents.length} purchases");
      final List<Purchase> purchasesDownloaded = [];
      data.documents.forEach((snapshot) {
        print("Purchase ID is ${snapshot.documentID}");
        purchasesDownloaded.add(Purchase.fromJson(snapshot.data));
      });
      _purchases.add(purchasesDownloaded);
    });
  }
}