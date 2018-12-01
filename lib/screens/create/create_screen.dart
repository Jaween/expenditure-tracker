import 'package:expenditure_tracker/util/category_icons.dart';
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

    final createBloc = widget.createBloc;

    _descriptionTextController = TextEditingController();
    _descriptionTextController.addListener(
        () => createBloc.actionDescriptionUpdate.add(_descriptionTextController.text));
    createBloc.descriptionStream.listen(
        (description) => _descriptionTextController.text = description);

    _locationTextController = TextEditingController();
    _locationTextController.addListener(
        () => createBloc.actionLocationUpdate.add(_locationTextController.text));
    createBloc.locationStream.listen(
        (location) => _locationTextController.text = location);

    _amountTextController = TextEditingController();
    _amountTextController.addListener(
        () => createBloc.actionAmountUpdate.add(_amountTextController.text));
    createBloc.amountStream.listen(
        (amount) => _amountTextController.text = amount);

    createBloc.loadingIndicatorStream.listen((loading) {
      if (loading) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator()
              ),
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
                createBloc.actionSave.add(null);
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
      child: StreamBuilder<String>(
        stream: createBloc.categoryStream,
        initialData: createBloc.category,
        builder: (context, snapshot) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryNameIconList.length,
            itemBuilder: (context, position) {
              final name = categoryNameIconList[position].item1;
              final selected = name == snapshot.data;
              return _createCategoryChip(name, createBloc, selected);
            },
          );
        }
      )
    );
  }

  Widget _createCategoryChip(String categoryName, CreateBloc createBloc,
      bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(categoryName),
        selected: selected,
        avatar: CircleAvatar(child: Icon(iconForCategory(categoryName))),
        onSelected: (selected) => createBloc.actionCategorySelect.add(categoryName),
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
      child: StreamBuilder<DateTime>(
        stream: createBloc.dateStream,
        initialData: createBloc.date,
        builder: (builder, snapshot) {
          return InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: snapshot.data,
                firstDate: DateTime(2010),
                lastDate: DateTime.now().add(Duration(days: 365 * 10)));
              if (date != null) {
                createBloc.actionDateUpdateController.add(date);
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
                      initialData: createBloc.formattedDate,
                      stream: createBloc.formattedDateStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
      child: StreamBuilder<String>(
        initialData: createBloc.currency,
        stream: createBloc.currencyStream,
        builder: (context, snapshot) {
          return DropdownButton<String>(
            value: snapshot.data,
            onChanged: (category) => createBloc.actionCurrencyUpdate.add(category),
            items: CreateBloc.currencies.map((String value) {
              return DropdownMenuItem<String>(
                value: value, child: Text(value));
            }).toList()
          );
        }
      ),
    );
  }
}
