import 'dart:async';

import 'package:expenditure_tracker/interface/location.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class CreateBloc {

  String category = "Food";
  String description = "Unset";
  DateTime date = DateTime.now();
  int latitude = 0;
  int longitude = 0;
  String locationType = "Unset";
  String locationName = "Unset";
  int amount = 0;
  String currency = "AUD";

  final Location _location;

  final _dateSink = StreamController<DateTime>();
  Sink<DateTime> get dateSink => _dateSink.sink;

  static final _dateFormat = DateFormat.yMMMd();
  final _formattedDateStream = BehaviorSubject<String>(seedValue: _dateFormat.format(DateTime.now()));
  Stream<String> get formattedDateStream => _formattedDateStream;

  final _currentPlaceStream = BehaviorSubject<Data<String>>();
  Stream<Data<String>> get currentPlaceStream => _currentPlaceStream;

  final _amountSink = StreamController<String>();
  Sink<String> get amountSink => _amountSink.sink;

  final _amountStream = BehaviorSubject<Data<int>>();
  Stream<Data<int>> get amountStream => _amountStream;

  CreateBloc(this._location) {
    _requestLocation();
    _dateSink.stream.listen((date) {
      this.date = date;
      _formattedDateStream.add(_dateFormat.format(date));
    });

    _amountSink.stream.listen((amount) {
      int amountInt = int.tryParse(amount);
      if (amountInt == null) {
        _amountStream.add(Data(Status.Error, amountInt, "Enter an amount greater than or equal to 0"));
      } else {
        _amountStream.add(Data(Status.Ok, amountInt));
      }
    });
  }

  void _requestLocation() {
    _currentPlaceStream.add(Data(Status.Loading, ""));
    _location.getCurrentPlaceName().then((value) {
      _currentPlaceStream.add(Data(value != null ? Status.Ok : Status.Error, value));
    });
  }

  void dispose() {
    _dateSink.close();
    _formattedDateStream.close();
    _currentPlaceStream.close();
    _amountSink.close();
    _amountStream.close();
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