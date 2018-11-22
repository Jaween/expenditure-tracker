import 'dart:async';

import 'package:expenditure_tracker/base_bloc.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/location.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class CreateBloc extends BlocBase {

  String category = "Food";
  String description = "";
  DateTime date = DateTime.now();
  int latitude = 0;
  int longitude = 0;
  String locationType = "";
  String locationName = "";
  String amount = "";
  String currency = "AUD";

  static final _dateFormat = DateFormat.yMMMd();

  final NavigationRouter _navigationRouter;

  final Location _location;

  final _dateController = BehaviorSubject<DateTime>();
  Sink<DateTime> get dateSink => _dateController.sink;

  final _formattedDateController = BehaviorSubject<String>(seedValue: _dateFormat.format(DateTime.now()));
  Stream<String> get formattedDateStream => _formattedDateController;

  final _currentPlaceController = BehaviorSubject<Data<String>>();
  Stream<Data<String>> get currentPlaceStream => _currentPlaceController;

  CreateBloc(this._navigationRouter, this._location, Expenditure initialExpenditure) {
    if (initialExpenditure != null) {
      print("Received expenditure ${initialExpenditure.description}");
    } else {
      print("Received no initial expenditure");
    }

    _requestLocation();
    _dateController.stream.listen((date) {
      this.date = date;
      _formattedDateController.add(_dateFormat.format(date));
    });
  }

  void _requestLocation() {
    _currentPlaceController.add(Data(Status.Loading, ""));
    _location.getCurrentPlaceName().then((value) {
      _currentPlaceController.add(Data(value != null ? Status.Ok : Status.Error, value));
    });
  }

  String amountValidator(String amount) {
    double amountDouble = double.tryParse(amount);
    if (amountDouble == null) {
      return "Enter a valid amount";
    }
    this.amount = amount;

    return null;
  }

  @override
  void dispose() {
    _dateController.close();
    _formattedDateController.close();
    _currentPlaceController.close();
  }
}

enum Status {
  Ok, Loading, Error
}

class Data<T> {

  final Status status;
  final T data;
  final String errorMessage;

  Data(this.status, this.data, [this.errorMessage]);
}