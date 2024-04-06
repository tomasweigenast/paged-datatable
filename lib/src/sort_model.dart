part of 'paged_datatable.dart';

/// SortModel indicates the current field the table is using to sort values.
final class SortModel {
  final String fieldName;
  final bool descending;

  const SortModel._({required this.fieldName, required this.descending});

  @override
  int get hashCode => Object.hash(fieldName, descending);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is SortModel && other.fieldName == fieldName && other.descending == descending);
}
