import 'dart:async';

import 'package:expenditure_tracker/base_bloc.dart';
import 'package:expenditure_tracker/interface/location.dart';
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

  final Location _location;

  final _dateSink = StreamController<DateTime>();
  Sink<DateTime> get dateSink => _dateSink.sink;

  static final _dateFormat = DateFormat.yMMMd();
  final _formattedDateStream = BehaviorSubject<String>(seedValue: _dateFormat.format(DateTime.now()));
  Stream<String> get formattedDateStream => _formattedDateStream;

  final _currentPlaceStream = BehaviorSubject<Data<String>>();
  Stream<Data<String>> get currentPlaceStream => _currentPlaceStream;

  CreateBloc(this._location) {
    _requestLocation();
    _dateSink.stream.listen((date) {
      this.date = date;
      _formattedDateStream.add(_dateFormat.format(date));
    });
  }

  void _requestLocation() {
    _currentPlaceStream.add(Data(Status.Loading, ""));
    _location.getCurrentPlaceName().then((value) {
      _currentPlaceStream.add(Data(value != null ? Status.Ok : Status.Error, value));
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

  void dispose() {
    _dateSink.close();
    _formattedDateStream.close();
    _currentPlaceStream.close();
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