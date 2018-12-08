import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseTypeRepository extends Repository {

  final Firestore _firestore = Firestore.instance;
  final _expenditures = BehaviorSubject<List<Expenditure>>();

  String _baseUri;
  String _expendituresUri;

  FirebaseTypeRepository(User user) : super(user) {
    _updateSignedInUser(user);
  }

  @override
  set user(User user) => _updateSignedInUser(user);

  @override
  Stream<List<Expenditure>> get expenditures => _expenditures;

  @override
  Future<void> createExpenditure(Expenditure expenditure) async {
    await _firestore.collection(_expendituresUri)
      .document()
      .setData(expenditure.toMap());
  }

  @override
  Future<void> updateExpenditure(Expenditure expenditure) async {
    await _firestore.collection(_expendituresUri)
      .document(expenditure.id)
      .updateData(expenditure.toMap());
  }

  @override
  Future<void> deleteExpenditure(Expenditure expenditure) async {
    await _firestore.collection(_expendituresUri)
        .document(expenditure.id)
        .delete();
  }

  _updateSignedInUser(User user) {
    if (user == null) {
      return;
    }

    _baseUri = 'users/${user.userId}';
    _expendituresUri = '$_baseUri/expenditures';

    _firestore.collection(_expendituresUri).snapshots().listen((data) {
      final expendituresDownloaded = <Expenditure>[];
      data.documents.forEach((snapshot) =>
        expendituresDownloaded.add(Expenditure.fromJson(snapshot.documentID, snapshot.data)));
      _expenditures.add(expendituresDownloaded);
    });
  }

  void dispose() {
    _expenditures.close();
  }
}