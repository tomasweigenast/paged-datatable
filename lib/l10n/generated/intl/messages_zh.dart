// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(currentPage) => "当前 ${currentPage} 页";

  static String m1(time) => "最后刷新于 ${time}";

  static String m2(totalElements) => "显示 ${totalElements} 条";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText": MessageLookupByLibrary.simpleMessage("应用"),
        "cancelFilteringButtonText": MessageLookupByLibrary.simpleMessage("取消"),
        "editableColumnCancelButtonText":
            MessageLookupByLibrary.simpleMessage("取消"),
        "editableColumnSaveChangesButtonText":
            MessageLookupByLibrary.simpleMessage("保存更改"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("过滤自..."),
        "nextPageButtonText": MessageLookupByLibrary.simpleMessage("下一页"),
        "noItemsFoundText": MessageLookupByLibrary.simpleMessage("未找到项目"),
        "pageIndicatorText": m0,
        "previousPageButtonText": MessageLookupByLibrary.simpleMessage("上一页"),
        "refreshText": MessageLookupByLibrary.simpleMessage("刷新"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("删除"),
        "removeFilterButtonText": MessageLookupByLibrary.simpleMessage("删除过滤项"),
        "rowsPerPageText": MessageLookupByLibrary.simpleMessage("每页行数"),
        "showFilterMenuTooltip": MessageLookupByLibrary.simpleMessage("过滤"),
        "totalElementsText": m2
      };
}
