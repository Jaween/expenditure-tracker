import 'package:intl/intl.dart';

final _dateFormatter = DateFormat.yMMMd();

String formatDDMMYYYY(DateTime dateTime) {
  if (DateTime.now().year == dateTime.year) {
    if (DateTime.now().month == dateTime.month) {
      final difference = DateTime.now().difference(dateTime);
      if (difference.inDays == 0) {
        return "Today";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      }
    }
  }
  return _dateFormatter.format(dateTime);
}

bool notNull(Object o) => o != null;