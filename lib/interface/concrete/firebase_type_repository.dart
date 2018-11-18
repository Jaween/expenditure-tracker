import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/interface/user.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseTypeRepository extends Repository {

  String _baseUri;
  String _expendituresUri;

  final User _user;
  final Firestore _firestore = Firestore.instance;

  final _expenditures = BehaviorSubject<List<Expenditure>>();

  FirebaseTypeRepository(this._user): super(_user) {
    _baseUri = 'users/${_user.userId}';
    _expendituresUri = '$_baseUri/expenditures';

    _firestore.collection(_expendituresUri).snapshots().listen((data) {
      print("User ${_user.userId} has ${data.documents.length} expenditure(s)");
      final expendituresDownloaded = <Expenditure>[];
      data.documents.forEach((snapshot) =>
          expendituresDownloaded.add(Expenditure.fromJson(snapshot.documentID, snapshot.data)));
      _expenditures.add(expendituresDownloaded);
    });
  }

  @override
  Stream<List<Expenditure>> get expenditures => _expenditures;

  @override
  Future<void> createOrUpdateExpenditure(Expenditure expenditure) async {
    final document = expenditure.id == null
        ? _firestore.collection(_expendituresUri).document()
        : _firestore.collection(_expendituresUri).document(expenditure.id);
    await document.setData(expenditure.toMap());
  }

  @override
  Future<void> deleteExpenditure(Expenditure expenditure) async {
    print("Want to delete expenditure with id ${expenditure.id}");
    await _firestore.collection(_expendituresUri)
        .document(expenditure.id)
        .delete();
  }
}