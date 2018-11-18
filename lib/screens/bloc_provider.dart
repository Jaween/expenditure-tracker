import 'package:expenditure_tracker/base_bloc.dart';
import 'package:flutter/widgets.dart';

/// Retrieves and provides access to an ancestor [Widget] containing a BLOC.
///
/// Based on the ideas and implementation outlined here:
/// https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T bloc;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  State createState() => _BlocProviderState();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    final BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
