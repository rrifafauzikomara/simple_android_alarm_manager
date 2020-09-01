import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime format() {
    final now = DateTime.now();
    final dateFormat = DateFormat('y/M/d');
    final timeInString = "07:53:00 PM";
    final todayInString = dateFormat.format(now);
    final completeString = "$todayInString $timeInString";
    final completeFormat = DateFormat('y/M/d h:m:s a');
    var completeDatetimeObject = completeFormat.parseStrict(completeString);
    return completeDatetimeObject;
  }
}