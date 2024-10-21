// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr locale. All the
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
  String get localeName => 'tr';

  static String m0(currentPage) => "Sayfa ${currentPage}";

  static String m1(time) => "Son yenileme ${time}";

  static String m2(totalElements) => "${totalElements} öğe gösteriliyor";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText": MessageLookupByLibrary.simpleMessage("Uygula"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("İptal"),
        "editableColumnCancelButtonText":
            MessageLookupByLibrary.simpleMessage("Vazgeç"),
        "editableColumnSaveChangesButtonText":
            MessageLookupByLibrary.simpleMessage("Değişiklikleri Kaydet"),
        "filterByTitle":
            MessageLookupByLibrary.simpleMessage("Başlık ile filtrele"),
        "nextPageButtonText":
            MessageLookupByLibrary.simpleMessage("Sonraki sayfa"),
        "noItemsFoundText":
            MessageLookupByLibrary.simpleMessage("Kayıt bulunamadı"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Önceki Sayfa"),
        "refreshText": MessageLookupByLibrary.simpleMessage("Yenile"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Temizle"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Filtreleri kaldır"),
        "rowsPerPageText":
            MessageLookupByLibrary.simpleMessage("Sayfa başına satır sayısı"),
        "showFilterMenuTooltip":
            MessageLookupByLibrary.simpleMessage("Filtrele"),
        "totalElementsText": m2
      };
}
