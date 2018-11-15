import 'dart:async';

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

  final _dateSink = StreamController<DateTime>();
  Sink<DateTime> get dateSink => _dateSink.sink;

  static final _dateFormat = DateFormat.yMMMd();
  final _formattedDateStream = BehaviorSubject<String>(seedValue: _dateFormat.format(DateTime.now()));
  Stream<String> get formattedDateStream => _formattedDateStream;

  final _amountSink = StreamController<String>();
  Sink<String> get amountSink => _amountSink.sink;

  final _amountStream = BehaviorSubject<Data<int>>();
  Stream<Data<int>> get amountStream => _amountStream;

  CreateBloc() {
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

  void dispose() {
    _dateSink.close();
    _amountSink.close();
  }
}

enum Status {
  Ok, Error
}

class Data<T> {

  final Status status;
  final T data;
  final String errorMessage;

  Data(this.status, this.data, [this.errorMessage]);
}