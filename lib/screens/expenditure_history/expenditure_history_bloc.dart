import 'dart:async';

import 'package:expenditure_tracker/base_bloc.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:rxdart/rxdart.dart';

/// Control and logic exposing actions and Streams for the expenditure list UI.
class ExpenditureHistoryBloc extends BlocBase {
  final Repository _repository;

  final _items = BehaviorSubject<List<ExpenditureListItem>>();
  Stream<List<ExpenditureListItem>> get items => _items.stream;

  final _updateExpenditureAction = StreamController<Expenditure>();
  Sink<Expenditure> get updateExpenditureAction => _updateExpenditureAction;

  final _deleteExpenditureAction = StreamController<Expenditure>();
  Sink<Expenditure> get deleteExpenditureAction => _deleteExpenditureAction;

  ExpenditureHistoryBloc(this._repository) {
    _repository.expenditures.listen((expenditures) {
      var reverseSortedExpenditures = List<Expenditure>.from(expenditures, growable: false);
      reverseSortedExpenditures.sort((Expenditure a, Expenditure b) => -a.date.compareTo(b.date));

      final expendituresSeparatedByDate =
          _generateExpendituresSeparatedByDate(reverseSortedExpenditures);
      _items.add(expendituresSeparatedByDate);
    });

    _updateExpenditureAction.stream.listen(
        (expenditure) => _repository.createOrUpdateExpenditure(expenditure));

    _deleteExpenditureAction.stream.listen(
        (expenditure) => _repository.deleteExpenditure(expenditure));
  }

  /// Creates a list of expenditures, separated with items holding the date of those expenditures.
  ///
  /// [expenditures] must be sorted (ascending or descending) by date.
  List<ExpenditureListItem> _generateExpendituresSeparatedByDate(List<Expenditure> expenditures) {
    DateTime headingDate;
    final items = <ExpenditureListItem>[];
    expenditures.forEach((expenditure) {
      if (headingDate == null ||
        !(headingDate.year == expenditure.date.year &&
          headingDate.month == expenditure.date.month &&
          headingDate.day == expenditure.date.day)) {
        headingDate = expenditure.date;
        items.add(ExpenditureListItem(headingDate, null));
      }
      items.add(ExpenditureListItem(null, expenditure));
    });
    return items;
  }

  @override
  void dispose() {
    _items.close();
    _updateExpenditureAction.close();
    _deleteExpenditureAction.close();
  }
}

/// Data class for items in the expenditures list (including date headers).
///
/// One of either [date] or [expenditure] will be non-null.
class ExpenditureListItem {
  final DateTime date;
  final Expenditure expenditure;

  ExpenditureListItem(this.date, this.expenditure);
}
