import 'dart:async';

import 'package:expenditure_tracker/base_bloc.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/location.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/util/category_icons.dart';
import 'package:expenditure_tracker/util/input_validators.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quiver/time.dart';

class CreateBloc extends BlocBase {
  String _expenditureId;
  String get expenditureId => _expenditureId;

  String _category;
  String get category => _category;

  String _description;

  DateTime _date;
  DateTime get date => _date;

  String _formattedDate;
  String get formattedDate => _formattedDate;

  String _locationName;

  String _amount;

  String _currency;
  String get currency => _currency;

  static final _dateFormat = DateFormat.yMMMd();

  static final currencies = <String>["AUD", "USD", "LKR"];

  // Dependencies
  final NavigationRouter _navigationRouter;
  final Repository _repository;
  final Location _location;
  final Clock _clock;

  final _categoryController = BehaviorSubject<String>();
  Stream<String> get categoryStream => _categoryController.stream;

  final _descriptionController = BehaviorSubject<String>();
  Stream<String> get descriptionStream => _descriptionController.stream;

  final _dateController = BehaviorSubject<DateTime>();
  Stream<DateTime> get dateStream => _dateController.stream;

  final _formattedDateController = BehaviorSubject<String>();
  Stream<String> get formattedDateStream => _formattedDateController.stream;

  final _locationController = BehaviorSubject<String>();
  Stream<String> get locationStream => _locationController.stream;

  final _currentPlaceController = BehaviorSubject<Data<String>>();
  Stream<Data<String>> get currentPlaceStream => _currentPlaceController.stream;

  final _amountController = BehaviorSubject<String>();
  Stream<String> get amountStream => _amountController.stream;

  final _currencyController = BehaviorSubject<String>();
  Stream<String> get currencyStream => _currencyController.stream;

  final _loadingIndicatorController = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get loadingIndicatorStream => _loadingIndicatorController.stream;

  // User input actions
  final _actionCategorySelectController = BehaviorSubject<String>();
  Sink<String> get actionCategorySelect => _actionCategorySelectController.sink;

  final _actionDescriptionUpdateController = BehaviorSubject<String>();
  Sink<String> get actionDescriptionUpdate =>
      _actionDescriptionUpdateController.sink;

  final _actionDateUpdateController = BehaviorSubject<DateTime>();
  Sink<DateTime> get actionDateUpdate => _actionDateUpdateController.sink;

  final _actionLocationUpdateController = BehaviorSubject<String>();
  Sink<String> get actionLocationUpdate => _actionLocationUpdateController.sink;

  final _actionAmountUpdateController = BehaviorSubject<String>();
  Sink<String> get actionAmountUpdate => _actionAmountUpdateController.sink;

  final _actionCurrencyUpdateController = BehaviorSubject<String>();
  Sink<String> get actionCurrencyUpdate => _currencyController.sink;

  final _actionSaveController = StreamController<void>();
  Sink<void> get actionSave => _actionSaveController.sink;

  CreateBloc(this._navigationRouter, this._repository, this._location,
      this._clock, Expenditure initialExpenditure) {
    if (initialExpenditure == null) {
      _category = categoryNameIconList[0].item1;
      _description = "";
      _date = _clock.now();
      _formattedDate = _dateFormat.format(_date);
      _locationName = "";
      _amount = "";
      _currency = currencies[0];

      _categoryController.sink.add(_category);
      _descriptionController.sink.add(_description);
      _dateController.sink.add(_date);
      _formattedDateController.sink.add(_formattedDate);
      _locationController.sink.add(_locationName);
      _amountController.sink.add(_amount);
      _currencyController.sink.add(_currency);

      _requestLocation();
    } else {
      _expenditureId = initialExpenditure.id;
      _category = initialExpenditure.category;
      _description = initialExpenditure.description;
      _date = initialExpenditure.date;
      _formattedDate = _dateFormat.format(initialExpenditure.date);
      _locationName = initialExpenditure.locationName;
      _amount = initialExpenditure.amount;
      _currency = initialExpenditure.currency;

      _categoryController.sink.add(_category);
      _descriptionController.sink.add(_description);
      _dateController.sink.add(_date);
      _formattedDateController.sink.add(_formattedDate);
      _locationController.sink.add(_locationName);
      _amountController.sink.add(_amount);
      _currencyController.sink.add(_currency);
    }

    _actionCategorySelectController.stream.listen((category) {
      _category = category;
      _categoryController.sink.add(_category);
    });

    _actionDescriptionUpdateController.listen((description) {
      _description = description;
      _descriptionController.sink.add(_description);
    });

    _actionDateUpdateController.listen((date) {
      _date = date;
      _dateController.sink.add(_date);
      _formattedDateController.add(_dateFormat.format(_date));
    });

    _actionLocationUpdateController.listen((location) {
      _locationName = location;
      _locationController.sink.add(_locationName);
    });

    _actionAmountUpdateController.listen((amount) {
      _amount = amount;
      _amountController.sink.add(_amount);
    });

    _actionCurrencyUpdateController.listen((currency) {
      _currency = currency;
      _currencyController.sink.add(_currency);
    });

    _actionSaveController.stream.listen((_) => _save());
  }

  void _requestLocation() {
    _currentPlaceController.add(Data(Status.Loading, ""));
    _location.getCurrentPlaceName().then((value) {
      _locationController.sink.add(value);
      _currentPlaceController
          .add(Data(value != null ? Status.Ok : Status.Error, value));
    });
  }

  String amountValidator(String amount) {
    return validate(() => validateAmount(amount), () => _amount = amount);
  }

  void _save() async {
    //if (!_formKey.currentState.validate()) {
    //  return;
    //}

    final expenditure = Expenditure(_category, _description, _date,
        _locationName, _amount, _currency, _expenditureId);

    _loadingIndicatorController.sink.add(true);
    if (_expenditureId == null) {
      await _repository.createExpenditure(expenditure);
    } else {
      await _repository.updateExpenditure(expenditure);
    }
    _loadingIndicatorController.sink.add(false);
    _navigationRouter.navigateToExpenditureHistoryScreen();
  }

  @override
  void dispose() {
    _categoryController.close();
    _descriptionController.close();
    _dateController.close();
    _formattedDateController.close();
    _locationController.close();
    _currentPlaceController.close();
    _amountController.close();
    _currencyController.close();
    _loadingIndicatorController.close();

    _actionCategorySelectController.close();
    _actionDescriptionUpdateController.close();
    _actionDateUpdateController.close();
    _actionLocationUpdateController.close();
    _actionAmountUpdateController.close();
    _actionCurrencyUpdateController.close();
    _actionSaveController.close();
  }
}

enum Status { Ok, Loading, Error }

class Data<T> {
  final Status status;
  final T data;
  final String errorMessage;

  Data(this.status, this.data, [this.errorMessage]);
}
