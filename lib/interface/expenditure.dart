import 'package:quiver/core.dart';

class Expenditure {
  String id;
  final String category;
  final String description;
  final DateTime date;
  final String locationName;
  final String amount;
  final String currency;

  Expenditure(
    this.category,
    this.description,
    this.date,
    this.locationName,
    this.amount,
    this.currency,
    [this.id]);

  Expenditure.fromJson(this.id, Map<String, dynamic> map):
      category = map['category'],
      description = map['description'],
      date = map['date'],
      locationName = map['locationName'],
      amount = map['amount'],
      currency = map['currency'];

  Map<String, dynamic> toMap() => {
      'category': category,
      'description': description,
      'date': date,
      'locationName': locationName,
      'amount': amount,
      'currency': currency,
    };

  @override
  int get hashCode => hashObjects(
      [id, category, description, date, locationName, amount, currency]);

  @override
  bool operator ==(other) {
    return other is Expenditure &&
        category == other.category &&
        description == other.description &&
        date == other.date &&
        locationName == other.locationName &&
        amount == other.amount &&
        currency == other.currency &&
        id == other.id;
  }
}