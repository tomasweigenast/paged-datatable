// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(currentPage) => "Страница ${currentPage}";

  static String m1(time) => "Последнее обновление в ${time}";

  static String m2(totalElements) => "Показано элементов: ${totalElements}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Применить"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("Отмена"),
        "editableColumnCancelButtonText":
            MessageLookupByLibrary.simpleMessage("Отмена"),
        "editableColumnSaveChangesButtonText":
            MessageLookupByLibrary.simpleMessage("Сохранить изменения"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("Фильтр по"),
        "nextPageButtonText":
            MessageLookupByLibrary.simpleMessage("Следующая страница"),
        "noItemsFoundText":
            MessageLookupByLibrary.simpleMessage("Объектов не найдено"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("Предыдущая страница"),
        "refreshText": MessageLookupByLibrary.simpleMessage("Обновить"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("Удалить"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("Убрать этот фильтр"),
        "rowsPerPageText":
            MessageLookupByLibrary.simpleMessage("Строк на странице"),
        "showFilterMenuTooltip": MessageLookupByLibrary.simpleMessage("Фильтр"),
        "totalElementsText": m2
      };
}
