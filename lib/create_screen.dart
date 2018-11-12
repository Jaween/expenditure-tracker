import 'package:expenditure_tracker/purchase.dart';
import 'package:expenditure_tracker/create_bloc.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {

  final Repository _repository;

  CreateScreen(this._repository);

  @override
  CreateScreenState createState() {
    return new CreateScreenState();
  }
}

class CreateScreenState extends State<CreateScreen> {

  CreateBloc _createBloc;

  @override
  void initState() {
    super.initState();
    _createBloc = CreateBloc();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Create"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => save(context),
              child: Text("SAVE"),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Container(
              height: 40.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _createCategoryChip("Food"),
                  _createCategoryChip("Transport"),
                  _createCategoryChip("Drinks"),
                  _createCategoryChip("Accommodation"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() { _createBloc.description = value; }),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(_createBloc.date.toString())
                ),
                RaisedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _createBloc.date,
                      firstDate: DateTime(2010),
                      lastDate: DateTime.now());
                    setState(() {
                      _createBloc.date = date;
                    });
                  },
                  child: Text("When"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() { _createBloc.locationName = value; }),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Where"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() { _createBloc.amount = num.parse(value).toInt(); }),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Amount"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    value: _createBloc.currency,
                    onChanged: (value) => setState(() { _createBloc.currency = value; }),
                    items: <String>["AUD", "USD", "LKR"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value)
                      );
                    }).toList()
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCategoryChip(String text) {
    return ChoiceChip(
      label: Text(text),
      selected: _createBloc.category == text,
      avatar: CircleAvatar(
        child: FlutterLogo(),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _createBloc.category = text;
          });
        }
      },
    );
  }

  void save(BuildContext outerContext) async {
    final purchase = Purchase(
      _createBloc.category,
      _createBloc.description,
      _createBloc.date,
      _createBloc.latitude,
      _createBloc.longitude,
      _createBloc.locationType,
      _createBloc.locationName,
      _createBloc.amount,
      _createBloc.currency
    );

    var wait = widget._repository.createOrUpdatePurchase(purchase);
    showDialog(context: outerContext, builder: (BuildContext context) {
      wait.then((_) {
        Navigator.pop(context);
        Navigator.of(outerContext).pop();
      });
      return Dialog(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator()
              ),
            ),
          ],
        ),
      );
    });
  }
}