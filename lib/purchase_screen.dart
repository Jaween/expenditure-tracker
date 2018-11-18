import 'package:expenditure_tracker/category_icons.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/purchase.dart';
import 'package:expenditure_tracker/purchase_bloc.dart';
import 'package:expenditure_tracker/util.dart';
import 'package:flutter/material.dart';

class PurchaseScreen extends StatefulWidget {
  final Repository repository;

  PurchaseScreen(this.repository, {Key key})
      : assert(repository != null),
        super(key: key);

  @override
  State createState() => PurchaseScreenState();
}

class PurchaseScreenState extends State<PurchaseScreen> {
  PurchaseBloc _purchaseBloc;

  @override
  void initState() {
    super.initState();
    _purchaseBloc = PurchaseBloc(widget.repository);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenditrack"),
      ),
      body: StreamBuilder<List<ExpenditureListItem>>(
          stream: _purchaseBloc.items,
          initialData: [],
          builder:
              (BuildContext context, AsyncSnapshot<List<ExpenditureListItem>> snapshot) {
            if (!snapshot.hasData) return _buildLoadingWidget();
            if (snapshot.data.isEmpty) return _buildEmptyListWidget();
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, pos) =>
                snapshot.data[pos].date != null
                  ? _buildDateItem(context, snapshot.data[pos].date)
                  : _buildPurchaseItem(context, snapshot.data[pos].purchase)
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/create'),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyListWidget() {
    return Center(
      child: SizedBox(
        width: 280.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              color: Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 16.0),
              child: Text(
                "Nothing spent",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                ),
              ),
            ),
            Text(
              "Add a purchase that you made and it will show up here",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.2,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(BuildContext context, DateTime date) {
    return Container(
      height: 24.0,
      color: Colors.grey.shade800,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 32.0),
            child: Text(formatDDMMYYYY(date)),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseItem(BuildContext context, Purchase purchase) {
    return Dismissible(
      key: Key(purchase.id),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        _purchaseBloc.deletePurchase(purchase);
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Removed ${purchase.description}")));
      },
      child: SizedBox(
        height: 64.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 32.0),
              child: Icon(iconForCategory(purchase.category)),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    purchase.description.isEmpty ? purchase.category : purchase.description,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(purchase.locationName),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    purchase.amount.toString(),
                    style: TextStyle(
                      fontSize: 18.0
                    ),
                  ),
                  Text(purchase.currency),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
