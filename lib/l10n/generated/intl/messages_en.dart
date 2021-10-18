// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(currentPage) => "Page ${currentPage}";

  static String m1(time) => "Refresh. Refreshed ${time}";

  static String m2(time) => "on ${time}";

  static String m3(time) => "today at ${time}";

  static String m4(time) => "yesterday at ${time}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText": MessageLookupByLibrary.simpleMessage("Apply"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("Filter by"),
        "nextPageButtonText": MessageLookupByLibrary.simpleMessage("Next page"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Previous page"),
        "refreshButtonText": m1,
        "refreshTimeFormattingAFewMinutesAgo":
            MessageLookupByLibrary.simpleMessage("a few minutes ago"),
        "refreshTimeFormattingAMinuteAgo":
            MessageLookupByLibrary.simpleMessage("a minute ago"),
        "refreshTimeFormattingAnHourAgo":
            MessageLookupByLibrary.simpleMessage("an hour ago"),
        "refreshTimeFormattingAnotherTime": m2,
        "refreshTimeFormattingJustNow":
            MessageLookupByLibrary.simpleMessage("just now"),
        "refreshTimeFormattingNever":
            MessageLookupByLibrary.simpleMessage("never"),
        "refreshTimeFormattingTodayAt": m3,
        "refreshTimeFormattingYesterdayAt": m4,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Remove"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Remove this filter"),
        "rowsPagePageText":
            MessageLookupByLibrary.simpleMessage("Rows per page"),
        "showFilterMenuTooltip":
            MessageLookupByLibrary.simpleMessage("Show filter menu"),
        "tableResetDueCacheReset": MessageLookupByLibrary.simpleMessage(
            "Table has been reset because local cache has expired."),
        "tableResetDuePreviousPageNotFound": MessageLookupByLibrary.simpleMessage(
            "Table has been reset because the requested page was not found in cache.")
      };
}
