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

class CreateBloc extends BlocBase {
  String _expenditureId;
  String _category = "";
  String _description = "";
  DateTime _date;
  int _latitude = 0;
  int _longitude = 0;
  String _locationType = "";
  String _locationName = "";
  String _amount = "";
  String _currency = "";

  static final _dateFormat = DateFormat.yMMMd();

  static final currencies = <String>["AUD", "USD", "LKR"];

  final NavigationRouter _navigationRouter;

  final Repository _repository;

  final Location _location;

  final _initialExpenditureController = BehaviorSubject<Expenditure>();
  Stream<Expenditure> get initialExpenditureStream => _initialExpenditureController.stream;

  final _categoryController = BehaviorSubject<String>();
  Stream<String> get categoryStream => _categoryController.stream;
  Sink<String> get categorySink => _categoryController.sink;

  final _descriptionController = BehaviorSubject<String>();
  Sink<String> get descriptionSink => _descriptionController.sink;

  final _dateController = BehaviorSubject<DateTime>(seedValue: DateTime.now());
  Stream<DateTime> get dateStream => _dateController.stream;
  Sink<DateTime> get dateSink => _dateController.sink;

  final _formattedDateController =
      BehaviorSubject<String>(seedValue: _dateFormat.format(DateTime.now()));
  Stream<String> get formattedDateStream => _formattedDateController.stream;

  final _locationController = BehaviorSubject<String>();
  Stream<String> get locationStream => _locationController.stream;
  Sink<String> get locationSink => _locationController.sink;

  final _currentPlaceController = BehaviorSubject<Data<String>>();
  Stream<Data<String>> get currentPlaceStream => _currentPlaceController.stream;

  final _amountController = BehaviorSubject<String>();
  Sink<String> get amountSink => _amountController.sink;

  final _currencyController = BehaviorSubject<String>(seedValue: currencies[0]);
  Stream<String> get currencyStream => _currencyController.stream;
  Sink<String> get currencySink => _currencyController.sink;

  final _saveActionController = StreamController<void>();
  Sink<void> get saveActionSink => _saveActionController.sink;

  final _loadingIndicatorController = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get loadingIndicatorStream => _loadingIndicatorController.stream;

  CreateBloc(this._navigationRouter, this._repository, this._location, Expenditure initialExpenditure) {
    if (initialExpenditure != null) {
      _initialExpenditureController.sink.add(initialExpenditure);
      _expenditureId = initialExpenditure.id;
      _category = initialExpenditure.category;
      _description = initialExpenditure.description;
      _date = initialExpenditure.date;
      _latitude = initialExpenditure.latitude;
      _longitude = initialExpenditure.longitude;
      _locationType = initialExpenditure.locationType;
      _locationName = initialExpenditure.locationName;
      _amount = initialExpenditure.amount;
      _currency = initialExpenditure.currency;

      _dateController.sink.add(initialExpenditure.date);
    } else {
      categorySink.add(getCategory(0));
      _requestLocation();
    }

    categoryStream.listen((category) => _category = category);

    _descriptionController.stream.listen(
        (description) => _description = description);

    dateStream.listen((date) {
      _date = date;
      _formattedDateController.add(_dateFormat.format(date));
    });

    locationStream.listen((location) => _locationName = location);

    _amountController.stream.listen((amount) => _amount = amount);

    currencyStream.listen((currency) => _currency = currency);

    _saveActionController.stream.listen((_) => _save());
  }

  void _requestLocation() {
    _currentPlaceController.add(Data(Status.Loading, ""));
    _location.getCurrentPlaceName().then((value) {
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

    final expenditure = Expenditure(
        _category,
        _description,
        _date,
        _latitude,
        _longitude,
        _locationType,
        _locationName,
        _amount,
        _currency);

    _loadingIndicatorController.sink.add(true);
    if (_expenditureId == null) {
      await _repository.createExpenditure(expenditure);
    } else {
      await _repository.updateExpenditure(expenditure, _expenditureId);
    }
    _loadingIndicatorController.sink.add(false);
    _navigationRouter.navigateToExpenditureHistoryScreen();
  }

  @override
  void dispose() {
    _initialExpenditureController.close();
    _categoryController.close();
    _descriptionController.close();
    _dateController.close();
    _formattedDateController.close();
    _locationController.close();
    _currentPlaceController.close();
    _amountController.close();
    _currencyController.close();
    _saveActionController.close();
    _loadingIndicatorController.close();
  }
}

enum Status { Ok, Loading, Error }

class Data<T> {
  final Status status;
  final T data;
  final String errorMessage;

  Data(this.status, this.data, [this.errorMessage]);
}
