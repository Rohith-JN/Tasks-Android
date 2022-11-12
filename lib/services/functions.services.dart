import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class Functions {
  static tz.TZDateTime parse(date, time) {
    String value = '$date $time';
    String currentFormat = "MM/dd/yyyy hh:mm a";
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        bool isUtc = false;
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {}
    }
    String parsed = dateTime!.toString();
    return tz.TZDateTime.parse(tz.local, parsed);
  }
}
