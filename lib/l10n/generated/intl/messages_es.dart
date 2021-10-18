// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(currentPage) => "Página ${currentPage}";

  static String m1(time) => "Actualizar. Actualizado ${time}";

  static String m2(time) => "el ${time}";

  static String m3(time) => "hoy a las ${time}";

  static String m4(time) => "ayer a las ${time}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Aplicar"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("Cancelar"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("Filtrar por"),
        "nextPageButtonText":
            MessageLookupByLibrary.simpleMessage("Siguiente página"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Página anterior"),
        "refreshButtonText": m1,
        "refreshTimeFormattingAFewMinutesAgo":
            MessageLookupByLibrary.simpleMessage("hace unos minutos"),
        "refreshTimeFormattingAMinuteAgo":
            MessageLookupByLibrary.simpleMessage("hace un minuto"),
        "refreshTimeFormattingAnHourAgo":
            MessageLookupByLibrary.simpleMessage("hace una hora"),
        "refreshTimeFormattingAnotherTime": m2,
        "refreshTimeFormattingJustNow":
            MessageLookupByLibrary.simpleMessage("justo ahora"),
        "refreshTimeFormattingNever":
            MessageLookupByLibrary.simpleMessage("nunca"),
        "refreshTimeFormattingTodayAt": m3,
        "refreshTimeFormattingYesterdayAt": m4,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Borrar"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Quitar este filtro"),
        "rowsPagePageText":
            MessageLookupByLibrary.simpleMessage("Filas por página"),
        "showFilterMenuTooltip":
            MessageLookupByLibrary.simpleMessage("Mostrar filtros"),
        "tableResetDueCacheReset": MessageLookupByLibrary.simpleMessage(
            "La table ha sido reestablecida desde el inicio debido a que caché expiró."),
        "tableResetDuePreviousPageNotFound": MessageLookupByLibrary.simpleMessage(
            "La table ha sido reestablecida desde el inicio debido a que la página solicitada no se encontró en caché.")
      };
}
