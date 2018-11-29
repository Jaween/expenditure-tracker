import 'package:expenditure_tracker/util/input_validators.dart';
import "package:test/test.dart";
import 'package:mockito/mockito.dart';

void main() {
  group("Input Validator", () {
    test("validateAmount() accepts ints", () {
      expect(validateAmount("30"), isNull);
      expect(validateAmount("0"), isNull);
      expect(validateAmount("4000"), isNull);
      expect(validateAmount(" 100"), isNull);
      expect(validateAmount("100 "), isNull);
      expect(validateAmount(" 100 "), isNull);
    });

    test("validateAmount() accepts floating point", () {
      expect(validateAmount("20.5"), isNull);
      expect(validateAmount("3.14159"), isNull);

    });

    test("validateAmount() rejects negative numbers", () {
      expect(validateAmount("-5"), isNotNull);
      expect(validateAmount("-0"), isNull);
    });

    test("validateAmount() rejects non numbers", () {
      expect(validateAmount("banana"), isNotNull);
      expect(validateAmount("zero"), isNotNull);
      expect(validateAmount("2,0"), isNotNull);
      expect(validateAmount("5*2"), isNotNull);
      expect(validateAmount("1.2.4"), isNotNull);
      expect(validateAmount("3 4"), isNotNull);
      expect(validateAmount("#"), isNotNull);
    });

    test("validateAmount() rejects whitespace", () {
      expect(validateAmount(" "), isNotNull);
    });
  });

  group("Validator", () {
    test("validate successfully calls onSucess", () {
      final mock = FunctionMock();
      final validator = () => null;
      final onSuccess = () { mock.call(() {}); };
      verifyNever(mock.call(any));
      validate(validator, onSuccess);
      verify(mock.call(any)).called(1);
    });

    test("validate unsuccessfully returns error", () {
      final validator = () => Error.INVALID_AMOUNT;
      final onSuccess = () => null;
      expect(validate(validator, onSuccess), isNotNull);
    });
  });
}

/// Used to test functions by wrapping them in [Function]'s [call()] interface.
///
/// This class is used in conjunction with [FunctionMock] to allow mocking out
/// of functions.
class FunctionProxy {
  void call(Function function) => function();
}

/// Used to mock out [Functions].
class FunctionMock extends Mock implements FunctionProxy {
  // [mock.verify()] seems to require implementing an interface to be considered
  // a Mockito object, so we use [FunctionProxy]. Though perhaps [call()] could
  // be directly implemented here, allowing us to delete [FunctionProxy].
}