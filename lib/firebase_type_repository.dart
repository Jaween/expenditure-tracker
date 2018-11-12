import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/purchase.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseTypeRepository extends Repository {

  String _baseUri;
  String _purchasesUri;

  final User _user;
  final Firestore _firestore = Firestore.instance;

  final _purchases = BehaviorSubject<List<Purchase>>();

  FirebaseTypeRepository(this._user): super(_user) {
    _baseUri = 'users/${_user.userId}';
    _purchasesUri = '$_baseUri/purchases';

    _firestore.collection(_purchasesUri).snapshots().listen((data) {
      print("User ${_user.userId} has ${data.documents.length} purchase(s)");
      final List<Purchase> purchasesDownloaded = [];
      data.documents.forEach((snapshot) =>
          purchasesDownloaded.add(Purchase.fromJson(snapshot.documentID, snapshot.data)));
      _purchases.add(purchasesDownloaded);
    });
  }

  @override
  Stream<List<Purchase>> get purchases => _purchases;

  @override
  Future<void> createOrUpdatePurchase(Purchase purchase) async {
    final document = purchase.id == null
        ? _firestore.collection(_purchasesUri).document()
        : _firestore.collection(_purchasesUri).document(purchase.id);
    await document.setData(purchase.toMap());
  }

  @override
  Future<void> deletePurchase(Purchase purchase) async {
    print("Want to delete purchase with id ${purchase.id}");
    await _firestore.collection(_purchasesUri)
        .document(purchase.id)
        .delete();
  }
}