import 'package:flutter/material.dart';

abstract interface class ColumnFormat {
  const ColumnFormat();

  Widget transform(Widget cell);
}

/// Applies a numeric format to the column. That is, the cell content is aligned to the right.
class NumericColumnFormat implements ColumnFormat {
  const NumericColumnFormat();

  @override
  Widget transform(Widget cell) => Align(alignment: Alignment.centerRight, child: cell);
}

/// Applies [alignment] to the cell content.
class AlignColumnFormat implements ColumnFormat {
  final AlignmentGeometry alignment;

  const AlignColumnFormat({required this.alignment});

  @override
  Widget transform(Widget cell) => Align(alignment: alignment, child: cell);
}
