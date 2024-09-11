// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
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
  String get localeName => 'nl';

  static String m0(currentPage) => "Pagina ${currentPage}";

  static String m1(time) => "Laatst vernieuwd om ${time}";

  static String m2(totalElements) => "${totalElements} elementen";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Toepassen"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("Annuleren"),
        "editableColumnCancelButtonText":
            MessageLookupByLibrary.simpleMessage("Annuleren"),
        "editableColumnSaveChangesButtonText":
            MessageLookupByLibrary.simpleMessage("Wijzigingen opslaan"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("Filter op"),
        "nextPageButtonText":
            MessageLookupByLibrary.simpleMessage("Volgende pagina"),
        "noItemsFoundText":
            MessageLookupByLibrary.simpleMessage("Geen items gevonden"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Vorige pagina"),
        "refreshText": MessageLookupByLibrary.simpleMessage("Vernieuwen"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Alles verwijderen"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Verwijder dit filter"),
        "rowsPerPageText":
            MessageLookupByLibrary.simpleMessage("Rijen per pagina"),
        "showFilterMenuTooltip": MessageLookupByLibrary.simpleMessage("Filter"),
        "totalElementsText": m2
      };
}
