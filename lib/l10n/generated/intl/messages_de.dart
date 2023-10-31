// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(currentPage) => "Seite ${currentPage}";

  static String m1(time) => "Zuletzt aktualisiert um ${time}";

  static String m2(totalElements) => "Zeigt ${totalElements} Elemente an";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Anwenden"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("Filtern nach"),
        "nextPageButtonText":
            MessageLookupByLibrary.simpleMessage("Nächste Seite"),
        "noItemsFoundText":
            MessageLookupByLibrary.simpleMessage("Keine Elemente gefunden"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Vorherige Seite"),
        "refreshText": MessageLookupByLibrary.simpleMessage("Aktualisieren"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Entfernen"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Diesen Filter entfernen"),
        "rowsPagePageText":
            MessageLookupByLibrary.simpleMessage("Zeilen pro Seite"),
        "showFilterMenuTooltip": MessageLookupByLibrary.simpleMessage("Filter"),
        "totalElementsText": m2
      };
}
