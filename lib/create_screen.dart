import 'package:expenditure_tracker/category_icons.dart';
import 'package:expenditure_tracker/interface/location.dart';
import 'package:expenditure_tracker/purchase.dart';
import 'package:expenditure_tracker/create_bloc.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  final Repository repository;
  final Location location;

  CreateScreen(
    this.repository,
    this.location, {
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

  TextEditingController _locationTextController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _locationTextController = TextEditingController();

    _createBloc = CreateBloc(widget.location);
    _createBloc.currentPlaceStream.listen((value) {
      if (value.status == Status.Ok) {
        _locationTextController.text = value.data;
      }
    });
    _locationTextController.addListener(() {
      _createBloc.locationName = _locationTextController.text;
    });
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
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _createWithIcon(Icons.category, _createCategoryChips(context)),
              _createWithIcon(Icons.description, _createDescription(context)),
              _createWithIcon(Icons.date_range, _createDate(context)),
              _createWithIcon(Icons.place, _createLocation(context)),
              _createWithIcon(Icons.monetization_on, _createAmount(context)),
            ],
          ),
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
            color: Colors.white.withOpacity(0.70),
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
          _createCategoryChip("Drinks"),
          _createCategoryChip("Transport"),
          _createCategoryChip("Accommodation"),
          _createCategoryChip("Electronics"),
          _createCategoryChip("Presents"),
        ],
      ),
    );
  }

  Widget _createCategoryChip(String categoryName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(categoryName),
        selected: _createBloc.category == categoryName,
        avatar: CircleAvatar(child: Icon(iconForCategory(categoryName))),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _createBloc.category = categoryName;
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
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Description"),
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
              _createBloc.dateSink.add(date);
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
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
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

  Widget _createLocation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextField(
        controller: _locationTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Where",
        ),
        textCapitalization: TextCapitalization.sentences,
        enabled: _locationTextController.text != null,
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
            child: TextFormField(
              validator: (value) => _createBloc.amountValidator(value),
              onSaved: (value) { print("Saved!"); },
              keyboardType:
                TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: _createCurrencyDropDown(),
                labelText: "How much"
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCurrencyDropDown() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: DropdownButton<String>(
        value: _createBloc.currency,
        onChanged: (value) => setState(() {
          _createBloc.currency = value;
        }),
        items: <String>["AUD", "USD", "LKR"].map((String value) {
          return DropdownMenuItem<String>(
            value: value, child: Text(value));
        }).toList()),
    );
  }

  void save(BuildContext outerContext) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

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

    var uploadResult = widget.repository.createOrUpdatePurchase(purchase);
    showDialog(
        context: outerContext,
        builder: (BuildContext context) {
          uploadResult.then((_) {
            //Navigator.pop(context);
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
