import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paged_datatable/paged_datatable.dart';

void main() {
  group('PagedDataTableThemeData', () {
    test('exposes filter dialog shell styling knobs', () {
      const borderRadius = BorderRadius.all(Radius.circular(12));
      const boxShadow = [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];

      const theme = PagedDataTableThemeData(
        filterDialogBorderRadius: borderRadius,
        filterDialogBoxShadow: boxShadow,
      );

      expect(theme.filterDialogBorderRadius, borderRadius);
      expect(theme.filterDialogBoxShadow, boxShadow);
    });

    test('includes filter dialog shell styling in equality', () {
      const base = PagedDataTableThemeData();
      const custom = PagedDataTableThemeData(
        filterDialogBorderRadius: BorderRadius.all(Radius.circular(12)),
        filterDialogBoxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      );

      expect(base, isNot(custom));
    });
  });
}
