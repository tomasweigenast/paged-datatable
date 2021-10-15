import 'package:intl/intl.dart';

class VerboseDateFormat {
  static String format(DateTime? dateTime) {
    if(dateTime == null) {
      return "never";
    }

    var diff = DateTime.now().difference(dateTime).abs();
    if(diff.inMinutes <= 1) {
      return "just now";
    } else if(diff.inMinutes > 1 && diff.inMinutes < 3) {
      return "a minute ago.";
    } else if(diff.inMinutes > 3 && diff.inMinutes < 59) {
      return "a few minutes ago.";
    } else if(diff.inHours <= 1) {
      return "an hour ago.";
    } else if(diff.inHours > 1 && diff.inDays < 1) {
      return "today at ${DateFormat.jm().format(dateTime)}";
    } else if(diff.inDays >= 1 && diff.inDays < 2) {
      return "yesterday"; 
    } else {
      return DateFormat.yMMMd().format(dateTime);
    }
  }
}