// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a th locale. All the
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
  String get localeName => 'th';

  static String m0(currentPage) => "หน้า ${currentPage}";

  static String m1(time) => "รีเฟรชล่าสุดเมื่อ ${time}";

  static String m2(totalElements) => "แสดง ${totalElements} รายการ";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "applyFilterButtonText": MessageLookupByLibrary.simpleMessage("ใช้งาน"),
        "cancelFilteringButtonText":
            MessageLookupByLibrary.simpleMessage("ยกเลิก"),
        "editableColumnCancelButtonText":
            MessageLookupByLibrary.simpleMessage("ยกเลิก"),
        "editableColumnSaveChangesButtonText":
            MessageLookupByLibrary.simpleMessage("บันทึกการเปลี่ยนแปลง"),
        "filterByTitle": MessageLookupByLibrary.simpleMessage("กรองตาม"),
        "nextPageButtonText": MessageLookupByLibrary.simpleMessage("หน้าถัดไป"),
        "noItemsFoundText": MessageLookupByLibrary.simpleMessage("ไม่พบรายการ"),
        "pageIndicatorText": m0,
        "previousPageButtonText":
            MessageLookupByLibrary.simpleMessage("หน้าก่อนหน้า"),
        "refreshText": MessageLookupByLibrary.simpleMessage("รีเฟรช"),
        "refreshedAtText": m1,
        "removeAllFiltersButtonText":
            MessageLookupByLibrary.simpleMessage("ลบ"),
        "removeFilterButtonText":
            MessageLookupByLibrary.simpleMessage("ลบตัวกรองนี้"),
        "rowsPerPageText": MessageLookupByLibrary.simpleMessage("แถวต่อหน้า"),
        "showFilterMenuTooltip": MessageLookupByLibrary.simpleMessage("กรอง"),
        "totalElementsText": m2
      };
}
