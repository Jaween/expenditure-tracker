import 'package:expenditure_tracker/category_icons.dart';
import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:expenditure_tracker/screens/expenditure_history/expenditure_history_bloc.dart';
import 'package:expenditure_tracker/util.dart';
import 'package:flutter/material.dart';

/// Screen which shows a list of past expenditures with associated actions.
class ExpenditureHistoryScreen extends StatelessWidget {
  ExpenditureHistoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpenditureList();
  }
}

class ExpenditureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenditureBloc = BlocProvider.of<ExpenditureHistoryBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenditrack"),
      ),
      body: StreamBuilder<List<ExpenditureListItem>>(
          stream: expenditureBloc.items,
          builder: (BuildContext context, AsyncSnapshot<List<ExpenditureListItem>> snapshot) {
            if (!snapshot.hasData) return _buildLoadingWidget();
            if (snapshot.data.isEmpty) return _buildEmptyListWidget(context);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, pos) => snapshot.data[pos].date != null
                  ? _buildDateItem(context, snapshot.data[pos].date)
                  : _buildExpenditureItem(context, snapshot.data[pos].expenditure),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => expenditureBloc.createExpenditureAction.add(null),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyListWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              color: Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32.0),
              child: Text(
                "Nothing spent",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Text(
              "Add an expenditure and it will show up here",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
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

  Widget _buildExpenditureItem(BuildContext context, Expenditure expenditure) {
    final expenditureBloc = BlocProvider.of<ExpenditureHistoryBloc>(context);
    return Dismissible(
      key: Key(expenditure.id),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        expenditureBloc.deleteExpenditureAction.add(expenditure);
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Removed ${expenditure.description}")));
      },
      child: GestureDetector(
        onTap: () => expenditureBloc.updateExpenditureAction.add(expenditure),
        child: SizedBox(
          height: 64.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(iconForCategory(expenditure.category)),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        expenditure.description.isEmpty
                            ? expenditure.category
                            : expenditure.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    Text(
                      expenditure.locationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      expenditure.amount.toString(),
                      style: Theme.of(context).textTheme.body2,
                    ),
                    Text(
                      expenditure.currency,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
