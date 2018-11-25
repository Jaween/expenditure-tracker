import 'package:expenditure_tracker/category_icons.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/create/create_bloc.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  final CreateBloc createBloc;

  CreateScreen({
    Key key,
    @required this.createBloc,
  }) : super(key: key);

  @override
  CreateScreenState createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  TextEditingController _descriptionTextController;
  TextEditingController _locationTextController;
  TextEditingController _amountTextController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _descriptionTextController = TextEditingController();
    _locationTextController = TextEditingController();
    _amountTextController = TextEditingController();

    final createBloc = widget.createBloc;
    createBloc.initialExpenditureStream.listen((initialExpenditure) {
        _descriptionTextController.text = initialExpenditure.description;
        _locationTextController.text = initialExpenditure.locationName;
        _amountTextController.text = initialExpenditure.amount;
    });

    createBloc.currentPlaceStream.listen((value) {
      if (value.status == Status.Ok) {
        _locationTextController.text = value.data;
      }
    });

    _descriptionTextController.addListener(() {
      createBloc.descriptionSink.add(_descriptionTextController.text);
    });

    _locationTextController.addListener(() {
      createBloc.locationSink.add(_locationTextController.text);
    });

    _amountTextController.addListener(() {
      createBloc.amountSink.add(_amountTextController.text);
    });

    createBloc.loadingIndicatorStream.listen((loading) {
      if (loading) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final createBloc = BlocProvider.of<CreateBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                createBloc.saveActionSink.add(null);
              },
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
              _createWithIcon(Icons.category, _createCategoryChips(context, createBloc)),
              _createWithIcon(Icons.description, _createDescription(context, createBloc)),
              _createWithIcon(Icons.date_range, _createDate(context, createBloc)),
              _createWithIcon(Icons.place, _createLocation(context, createBloc)),
              _createWithIcon(Icons.monetization_on, _createAmount(context, createBloc)),
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

  Widget _createCategoryChips(BuildContext context, CreateBloc createBloc) {
    return Container(
      height: 56.0,
      child: StreamBuilder<Expenditure>(
        stream: createBloc.initialExpenditureStream,
        builder: (context, snapshot) {
          String selectedCategory = "Food";
          if (snapshot.data != null) {
            selectedCategory = snapshot.data.category;
          }
          return StreamBuilder<String>(
            stream: createBloc.categoryStream,
            builder: (builder, snapshot) {
              if (snapshot.data != null) {
                selectedCategory = snapshot.data;
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _createCategoryChip("Food", createBloc, selectedCategory),
                  _createCategoryChip("Drinks", createBloc, selectedCategory),
                  _createCategoryChip("Transport", createBloc, selectedCategory),
                  _createCategoryChip("Accommodation", createBloc, selectedCategory),
                  _createCategoryChip("Electronics", createBloc, selectedCategory),
                  _createCategoryChip("Presents", createBloc, selectedCategory),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _createCategoryChip(String categoryName, CreateBloc createBloc,
      String selectedCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(categoryName),
        selected: categoryName == selectedCategory,
        avatar: CircleAvatar(child: Icon(iconForCategory(categoryName))),
        onSelected: (selected) => createBloc.categorySink.add(categoryName),
      ),
    );
  }

  Widget _createDescription(BuildContext context, CreateBloc createBloc) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextFormField(
        controller: _descriptionTextController,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Description"
        ),
      ),
    );
  }

  Widget _createDate(BuildContext context, CreateBloc createBloc) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: StreamBuilder<Expenditure>(
        stream: createBloc.initialExpenditureStream,
        builder: (builder, snapshot) {
          DateTime selectedDate;
          if (snapshot.data != null) {
            selectedDate = snapshot.data.date;
          } else {
            selectedDate = DateTime.now();
          }
          return InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2010),
                lastDate: DateTime.now().add(Duration(days: 365 * 10)));
              if (date != null) {
                createBloc.dateSink.add(date);
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
                      stream: createBloc.formattedDateStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("No formatted date data");
                        }
                        return Text(snapshot.data);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createLocation(BuildContext context, CreateBloc createBloc) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextFormField(
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

  Widget _createAmount(BuildContext context, CreateBloc createBloc) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _amountTextController,
              validator: (value) => createBloc.amountValidator(value),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: _createCurrencyDropDown(createBloc),
                labelText: "How much"
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCurrencyDropDown(CreateBloc createBloc) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: StreamBuilder<Expenditure>(
        stream: createBloc.initialExpenditureStream,
        builder: (builder, snapshot) {
          String data;
          if (snapshot.data != null) {
            data = snapshot.data.currency;
          }
          return StreamBuilder<String>(
            stream: createBloc.currencyStream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                data = snapshot.data;
              }
              return DropdownButton<String>(
                value: data == null ? CreateBloc.currencies[0] : data,
                onChanged: (category) => createBloc.currencySink.add(category),
                items: CreateBloc.currencies.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value, child: Text(value));
                }).toList()
              );
            }
          );
        }
      ),
    );
  }
}
