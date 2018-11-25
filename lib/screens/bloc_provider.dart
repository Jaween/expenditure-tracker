import 'package:expenditure_tracker/base_bloc.dart';
import 'package:flutter/widgets.dart';

typedef X BlocBuilder<X extends BlocBase>();

/// Retrieves and provides access to an ancestor [Widget] containing a BLOC.
///
/// The BLoC is provided as a builder to lazily instantiate it once (since
/// [BlocProvider] may be rebuilt numerous times).
///
/// Based on the ideas and implementation outlined here:
/// https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/
/// and here: https://stackoverflow.com/a/49492495/1702627
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final BlocBuilder<T> blocBuilder;
  final Widget child;

  BlocProvider({
    Key key,
    @required this.blocBuilder,
    @required this.child,
  }) : super(key: key);

  @override
  State createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<_InheritedBlocProvider<T>>();
    final _InheritedBlocProvider<T> provider = context.inheritFromWidgetOfExactType(type);
    return provider.data.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider> {
  BlocBase bloc;

  _BlocProviderState();

  @override
  void initState() {
    bloc = widget.blocBuilder();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedBlocProvider<T>(
      data: this,
      child: widget.child,
    );
  }
}

/// Allows a descendant widget to get a reference to the [State] of our
/// [BlocProvider] widget.
class _InheritedBlocProvider<T extends BlocBase> extends InheritedWidget {
  final _BlocProviderState<T> data;

  _InheritedBlocProvider({
    Key key,
    this.data,
    Widget child
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}