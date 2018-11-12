import 'package:expenditure_tracker/Purchase.dart';
import 'package:expenditure_tracker/purchase_bloc.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseScreen extends StatefulWidget {

  final Firestore _firestore;

  PurchaseScreen(this._firestore);

  @override State createState() => PurchaseScreenState();
}

class PurchaseScreenState extends State<PurchaseScreen> {

  PurchaseBloc _purchaseBloc;

  @override
  void initState() {
    super.initState();
    _purchaseBloc = PurchaseBloc(widget._firestore);
  }

  @override
  Widget build(BuildContext context) {
    return PurchaseList(_purchaseBloc.purchases);
  }
}

class PurchaseList extends StatelessWidget {

  final Stream<List<Purchase>> _purchases;

  PurchaseList(this._purchases);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Expenditrack"),
      ),
      body: StreamBuilder<List<Purchase>>(
        stream: _purchases,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<Purchase>> snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, position) =>
                  _buildPurchaseItem(context, snapshot.data[position])
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Pressed buton"),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPurchaseItem(BuildContext context, Purchase purchase) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(Icons.fastfood),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(purchase.description),
                Text(purchase.locationName),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(purchase.amount.toString()),
              Text(purchase.currency),
            ],
          )
        ],
      ),
    );
  }

}