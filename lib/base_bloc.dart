/// Abstract base class for Business Logic Components.
///
/// Use this class so that resources (Streams) can be closed at the appropriate time when used with
/// a [BlocProvider].
abstract class BlocBase {
  void dispose();
}
