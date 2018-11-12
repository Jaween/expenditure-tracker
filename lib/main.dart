import 'package:expenditure_tracker/purchase_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  final firestore = Firestore.instance;
  runApp(MyApp(firestore));
}

class MyApp extends StatelessWidget {

  final Firestore _firestore;

  MyApp(this._firestore);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenditure Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PurchaseScreen(_firestore),
    );
  }
}
