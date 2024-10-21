// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
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
  String get localeName => 'pt';

  static String m0(currentPage) => "Página ${currentPage}";

  static String m1(time) => "Atualizado às ${time}";

  static String m2(totalElements) => "Mostrando ${totalElements} elementos";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Aplicar"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("Cancelar"),
        "editableColumnCancelButtonText":
            MessageLookupByLibrary.simpleMessage("Cancelar"),
        "editableColumnSaveChangesButtonText":
            MessageLookupByLibrary.simpleMessage("Guardar alterações"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("Filtrar por"),
        "nextPageButtonText":
            MessageLookupByLibrary.simpleMessage("Próxima página"),
        "noItemsFoundText":
            MessageLookupByLibrary.simpleMessage("Nenhum item encontrado"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Página anterior"),
        "refreshText": MessageLookupByLibrary.simpleMessage("Atualizar"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Remover"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Remover este filtro"),
        "rowsPerPageText":
            MessageLookupByLibrary.simpleMessage("Linhas por página"),
        "showFilterMenuTooltip":
            MessageLookupByLibrary.simpleMessage("Filtrar"),
        "totalElementsText": m2
      };
}
