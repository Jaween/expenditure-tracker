import 'package:expenditure_tracker/purchase.dart';

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

  CreateBloc();

}