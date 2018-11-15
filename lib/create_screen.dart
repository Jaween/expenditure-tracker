import 'package:expenditure_tracker/purchase.dart';
import 'package:expenditure_tracker/create_bloc.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  final Repository repository;

  CreateScreen(
    this.repository, {
    Key key,
  })  : assert(repository != null),
        super(key: key);

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
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _createWithIcon(Icons.category, _createCategoryChips(context)),
            _createWithIcon(Icons.description, _createDescription(context)),
            _createWithIcon(Icons.date_range, _createDate(context)),
            _createWithIcon(Icons.place, _createWhere(context)),
            _createWithIcon(Icons.monetization_on, _createAmount(context)),
          ],
        ),
      ),
    );
  }

  Widget _createWithIcon(IconData data, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 32, top: 32, bottom: 8),
          child: Icon(
            data,
            color: Colors.black.withOpacity(0.38),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _createCategoryChips(BuildContext context) {
    return Container(
      height: 56.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _createCategoryChip("Food"),
          _createCategoryChip("Transport"),
          _createCategoryChip("Drinks"),
          _createCategoryChip("Accommodation"),
        ],
      ),
    );
  }

  Widget _createCategoryChip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(text),
        selected: _createBloc.category == text,
        avatar: CircleAvatar(child: Icon(Icons.directions_transit)),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _createBloc.category = text;
            });
          }
        },
      ),
    );
  }

  Widget _createDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextField(
        onChanged: (value) => setState(() {
              _createBloc.description = value;
            }),
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: "Description"),
      ),
    );
  }

  Widget _createDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _createBloc.date,
            firstDate: DateTime(2010),
            lastDate: DateTime.now().add(Duration(days: 365 * 10)));
          if (date != null) {
            setState(() {
              _createBloc.date = date;
            });
          }
        },
        child: Container(
          height: 56.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<String>(
                  stream: _createBloc.formattedDateStream,
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return Text("No data");
                    }
                    return Text(snapshot.data);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createWhere(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextField(
        onChanged: (value) => setState(() {
              _createBloc.locationName = value;
            }),
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: "Where"),
      ),
    );
  }

  Widget _createAmount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<Data<int>>(
                stream: _createBloc.amountStream,
                builder:
                    (BuildContext context, AsyncSnapshot<Data<int>> snapshot) {
                  return TextField(
                    onChanged: (value) => setState(() {
                          _createBloc.amountSink.add(value);
                        }),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: snapshot.data?.errorMessage,
                        hintText: "Amount"),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButton<String>(
                value: _createBloc.currency,
                onChanged: (value) => setState(() {
                      _createBloc.currency = value;
                    }),
                items: <String>["AUD", "USD", "LKR"].map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()),
          ),
        ],
      ),
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
        _createBloc.currency);

    var wait = widget.repository.createOrUpdatePurchase(purchase);
    showDialog(
        context: outerContext,
        builder: (BuildContext context) {
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
                      child: CircularProgressIndicator()),
                ),
              ],
            ),
          );
        });
  }
}
