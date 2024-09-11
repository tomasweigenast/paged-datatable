// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(currentPage) => "Page ${currentPage}";

  static String m1(time) => "Dernière actualisation le ${time}";

  static String m2(totalElements) => "Affichage de ${totalElements} éléments";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Appliquer"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("Annuler"),
        "editableColumnCancelButtonText":
            MessageLookupByLibrary.simpleMessage("Annuler"),
        "editableColumnSaveChangesButtonText":
            MessageLookupByLibrary.simpleMessage(
                "Enregistrer les modifications"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("Filtrer par"),
        "nextPageButtonText":
            MessageLookupByLibrary.simpleMessage("Page suivante"),
        "noItemsFoundText":
            MessageLookupByLibrary.simpleMessage("Aucun élément trouvé"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Page précédente"),
        "refreshText": MessageLookupByLibrary.simpleMessage("Actualiser"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Supprimer"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Supprimer les filtres"),
        "rowsPerPageText":
            MessageLookupByLibrary.simpleMessage("Lignes par page"),
        "showFilterMenuTooltip":
            MessageLookupByLibrary.simpleMessage("Filtrer"),
        "totalElementsText": m2
      };
}
