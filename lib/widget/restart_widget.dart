import 'package:flutter/widgets.dart';

/// Widget that can force the child subtree to be rebuilt from scratch.
///
/// Calling [restart()] causes the [child] subtree to be rebuilt with new state.
/// When placed near the top of the Widget tree, [restart()] will effectively
/// "restart" the app.
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child}) : super(key: key);

  @override
  RestartWidgetState createState() => RestartWidgetState();
}

class RestartWidgetState extends State<RestartWidget> {
  Key _restartKey = UniqueKey();

  void restart() => setState(() => _restartKey = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _restartKey,
      child: widget.child,
    );
  }
}