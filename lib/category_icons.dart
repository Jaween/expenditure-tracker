import 'package:flutter/material.dart';

final _map = <String, IconData>{
  "Food": Icons.restaurant,
  "Transport": Icons.drive_eta,
  "Accommodation": Icons.hotel,
  "Drinks": Icons.invert_colors,
  "Electronics": Icons.devices,
  "Presents": Icons.card_giftcard
};

IconData iconForCategory(String category) {
  final icon = _map[category];
  if (icon == null) {
    return Icons.attach_money;
  }
  return icon;
}