part of 'paged_datatable.dart';

class TableError extends Error {
  final String message;

  TableError(this.message);

  @override
  String toString() => message;
}
