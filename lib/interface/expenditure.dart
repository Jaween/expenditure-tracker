class Expenditure {

  String id;
  final String category;
  final String description;
  final DateTime date;
  final int latitude;
  final int longitude;
  final String locationType;
  final String locationName;
  final String amount;
  final String currency;

  Expenditure(
    this.category,
    this.description,
    this.date,
    this.latitude,
    this.longitude,
    this.locationType,
    this.locationName,
    this.amount,
    this.currency);

  Expenditure.fromJson(this.id, Map<String, dynamic> map):
      category = map['category'],
      description = map['description'],
      date = map['date'],
      latitude = map['latitude'],
      longitude = map['longitude'],
      locationType = map['locationType'],
      locationName = map['locationName'],
      amount = map['amount'],
      currency = map['currency'];

  Map<String, dynamic> toMap() => {
      'category': category,
      'description': description,
      'date': date,
      'latitude': latitude,
      'logitude': longitude,
      'locationtype': locationType,
      'locationName': locationName,
      'amount': amount,
      'currency': currency,
    };
}