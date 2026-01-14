// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static String m0(currentPage) => "Pagina ${currentPage}";

  static String m1(time) => "Ultimo aggiornamento alle ${time}";

  static String m2(totalElements) =>
      "Visualizzazione di ${totalElements} elementi";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "applyFilterButtonText": MessageLookupByLibrary.simpleMessage("Applica"),
    "cancelFilteringButtonText": MessageLookupByLibrary.simpleMessage(
      "Annulla",
    ),
    "editableColumnCancelButtonText": MessageLookupByLibrary.simpleMessage(
      "Annulla",
    ),
    "editableColumnSaveChangesButtonText": MessageLookupByLibrary.simpleMessage(
      "Salva",
    ),
    "filterByTitle": MessageLookupByLibrary.simpleMessage("Filtra per"),
    "nextPageButtonText": MessageLookupByLibrary.simpleMessage(
      "Pagina successiva",
    ),
    "noItemsFoundText": MessageLookupByLibrary.simpleMessage(
      "Nessun elemento trovato",
    ),
    "pageIndicatorText": m0,
    "previousPageButtonText": MessageLookupByLibrary.simpleMessage(
      "Pagina precedente",
    ),
    "refreshText": MessageLookupByLibrary.simpleMessage("Aggiorna"),
    "refreshedAtText": m1,
    "removeAllFiltersButtonText": MessageLookupByLibrary.simpleMessage(
      "Rimuovi",
    ),
    "removeFilterButtonText": MessageLookupByLibrary.simpleMessage(
      "Rimuovi filtro",
    ),
    "rowsPerPageText": MessageLookupByLibrary.simpleMessage("Righe per pagina"),
    "showFilterMenuTooltip": MessageLookupByLibrary.simpleMessage("Filtro"),
    "totalElementsText": m2,
  };
}
