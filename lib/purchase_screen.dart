import 'dart:math';

import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/purchase.dart';
import 'package:expenditure_tracker/purchase_bloc.dart';
import 'package:flutter/material.dart';

class PurchaseScreen extends StatefulWidget {

  final Repository _repository;

  PurchaseScreen(this._repository);

  @override State createState() => PurchaseScreenState();
}

class PurchaseScreenState extends State<PurchaseScreen> {

  PurchaseBloc _purchaseBloc;

  @override
  void initState() {
    super.initState();
    _purchaseBloc = PurchaseBloc(widget._repository);
  }

  @override
  Widget build(BuildContext context) {
    return PurchaseList(_purchaseBloc);
  }
}

class PurchaseList extends StatelessWidget {

  final PurchaseBloc _purchaseBloc;

  PurchaseList(this._purchaseBloc);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Expenditrack"),
      ),
      body: StreamBuilder<List<Purchase>>(
        stream: _purchaseBloc.purchases,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<Purchase>> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              final purchase = snapshot.data[position];
              return Dismissible(
                key: Key(purchase.id),
                child: _buildPurchaseItem(context, purchase),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  _purchaseBloc.deletePurchase(purchase);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("Removed ${purchase.description}")));
                }
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/create'),
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