typedef Error Validator();

/// Errors generated from user input.
enum Error {
  INVALID_AMOUNT,
}

/// Validates user input of a monetary amount.
Error validateAmount(String amount) {
  double amountDouble = double.tryParse(amount);
  if (amountDouble == null || amountDouble < 0) {
    return Error.INVALID_AMOUNT;
  }

  return null;
}

/// Converts an [Error] to a user facing string.
///
/// TODO(jaween): Use locale and retrieve localised strings.
String errorToString(Error error) {
  switch (error) {
    case Error.INVALID_AMOUNT:
      return "Enter a valid amount";
      break;
    default:
      return "Error";
  }
}

/// Runs [validator] then [onSuccess] if successful, returns any error or null.
String validate(Validator validator, Function onSuccess) {
  final error = validator();
  if (error != null) {
    return errorToString(error);
  }
  onSuccess();
  return null;
}