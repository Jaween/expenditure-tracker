import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

final categoryNameIconList = <Tuple2<String, IconData>>[
  Tuple2("Food", Icons.restaurant),
  Tuple2("Transport", Icons.drive_eta),
  Tuple2("Accommodation", Icons.hotel),
  Tuple2("Drinks", Icons.invert_colors),
  Tuple2("Electronics", Icons.devices),
  Tuple2("Presents", Icons.card_giftcard)
];

IconData iconForCategory(String category) {
  for (final pair in categoryNameIconList) {
    if (pair.item1 == category) {
      return pair.item2;
    }
  }
  return Icons.attach_money;
}