import 'package:expenditure_tracker/interface/user.dart';
import 'package:expenditure_tracker/screens/account/account_bloc.dart';
import 'package:expenditure_tracker/screens/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:expenditure_tracker/util.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountBloc>(context);
    return StreamBuilder<User>(
      stream: bloc.currentUserStream,
      initialData: null,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Container(
          child: user == null
            ? Center(child: CircularProgressIndicator())
            : _buildProfile(context, user),
        );
      },
    );
  }

  Widget _buildProfile(BuildContext context, User user) {
    final photoUrl = user.photoUrl == null
      ? "http://fortunetech.com.bd/wp-content/uploads/2018/02/testmonial-default.png"
      : user.photoUrl;
    final displayName = user.displayName == null || user.displayName.isEmpty
      ? "Expenditrack user"
      : user.displayName;
    final name = "${user.isAnonymous ? "Guest user" : displayName}";
    final accountBloc = BlocProvider.of<AccountBloc>(context);

    final widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: ClipOval(
              child: Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.headline,
          ),
        ),
      ),
      user.isAnonymous
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: RaisedButton(
                child: Text("Sign in".toUpperCase()),
                onPressed: () => accountBloc.actionSignIn.add(null),
              ),
            ),
          )
        : null,
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 16),
          child: Text(
            user.userId,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
      ),
      _buildHeader(context, "Linked accounts")
    ];

    if (user.isAnonymous) {
      widgets.addAll([
        _buildRow(context, Icons.link, "Link account", "", () {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("Link account"),
                children: <Widget>[
                  _LinkAccountDialog(accountBloc, () => Navigator.pop(context)),
                ],
              );
            }
          );
          //accountBloc.actionLinkAccount.add(null);
        }),
      ]);
    } else {
      widgets.addAll(_buildLinkedAccounts(context, user.linkedProviderIds));
    }

    widgets.add(_buildHeader(context, "General"));
    if (!user.isAnonymous) {
      widgets.addAll(
        <Widget>[
          _buildRow(context, Icons.exit_to_app, "Sign out", "", () {
            return accountBloc.actionSignOut.add(null);
          }),
        ]
      );
    }

    final deleteRowMessage = user.isAnonymous
      ? "Delete guest account"
      : "Delete account";
    widgets.add(_buildRow(context, Icons.remove_circle, deleteRowMessage, "", () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete account"),
            content: Text("You will lose your expenditure history."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop();
                  accountBloc.actionDeleteAccount.add(null);
                },
              )
            ],
          );
        }
      );
    }));

    return ListView(
      shrinkWrap: true,
      children: widgets.where((widget) => notNull(widget)).toList(),
    );
  }

  Widget _buildHeader(BuildContext context, String text) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 6, bottom: 6),
        child: Text(
          text,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
    );
  }

  List<Widget> _buildLinkedAccounts(BuildContext context, List<String> providers) {
    return providers.map((provider) {
      return _buildLinkedAccount(context, provider);
    }).toList();
  }

  Widget _buildLinkedAccount(BuildContext context, String provider) {
    return Container(
      height: 56.0,
      padding: EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.call),
          ),
          Expanded(
            child: Text(
              provider,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          //_buildUnlinkAccountButton(context, provider),
        ],
      ),
    );
  }

  Widget _buildUnlinkAccountButton(BuildContext context, String provider) {
    final bloc = BlocProvider.of<AccountBloc>(context);
    return FlatButton(
      child: Text("Unlink account"),
      onPressed: () {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text("Unlink from $provider"),
            content: Text("You wont be able to sign in with $provider anymore."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Unlink"),
                onPressed: () => bloc.actionUnlinkAccount.add(null),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildRow(BuildContext context, IconData iconData, String text, String caption, Function action) {
    return SizedBox(
      height: 56,
      child: InkWell(
        onTap: action,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(iconData),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.body2,
                ),
                caption.isEmpty ? null :Text(
                    caption,
                    style: Theme.of(context).textTheme.caption,
                ),
              ].where(notNull).toList(),
            ),
          ],
        )
      ),
    );
  }
}

class _LinkAccountDialog extends StatelessWidget {
  final AccountBloc _accountBloc;
  final Function _dismiss;

  _LinkAccountDialog(this._accountBloc, this._dismiss);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center ,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 164,
            child: RaisedButton(
              child: Text("Link with Facebook"),
              color: Colors.blue,
              onPressed: () {},
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 164,
            child: RaisedButton(
              child: Text("Link with Google"),
              color: Colors.red,
              onPressed: () {
                _accountBloc.actionLinkAccountGoogle.add(null);
                _dismiss();
              }
            ),
          ),
        ),
      ],
    );
  }
}