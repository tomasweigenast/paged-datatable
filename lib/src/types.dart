// ignore_for_file: prefer_final_fields

part of 'paged_datatable.dart';

typedef FetchCallback<TKey extends Object, TResult extends Object> = FutureOr<PaginationResult<TResult>> Function(TKey pageToken, int pageSize, SortBy? sortBy);

class SortBy {
  String _columnId;
  bool _descending;

  String get columnId => _columnId;
  bool get descending => _descending;

  SortBy._internal({required String columnId, required bool descending})
    : _columnId = columnId, _descending = descending;
}