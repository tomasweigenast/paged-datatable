import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';

class VerboseDateFormat {
  static String format(BuildContext context, DateTime? dateTime) {
    var intl = PagedDataTableLocalization.maybeOf(context);

    if(dateTime == null) {
      return intl?.refreshTimeFormattingNever ?? "never";
    }

    var diff = DateTime.now().difference(dateTime).abs();
    if(diff.inMinutes <= 1) {
      return intl?.refreshTimeFormattingJustNow ?? "just now";
    } else if(diff.inMinutes > 1 && diff.inMinutes < 3) {
      return intl?.refreshTimeFormattingAMinuteAgo ?? "a minute ago.";
    } else if(diff.inMinutes > 3 && diff.inMinutes < 59) {
      return intl?.refreshTimeFormattingAFewMinutesAgo ?? "a few minutes ago.";
    } else if(diff.inHours <= 1) {
      return intl?.refreshTimeFormattingAnHourAgo ?? "an hour ago.";
    } else if(diff.inHours > 1 && diff.inDays < 1) {
      return intl?.refreshTimeFormattingTodayAt(DateFormat.jm().format(dateTime)) ?? "today at ${DateFormat.jm().format(dateTime)}";
    } else if(diff.inDays >= 1 && diff.inDays < 2) {
      return intl?.refreshTimeFormattingYesterdayAt(DateFormat.jm().format(dateTime)) ?? "yesterday at ${DateFormat.jm().format(dateTime)}"; 
    } else {
      return intl?.refreshTimeFormattingAnotherTime(DateFormat.yMMMd().format(dateTime)) ?? "on ${DateFormat.yMMMd().format(dateTime)}";
    }
  }
}