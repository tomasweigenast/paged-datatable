part of 'paged_datatable.dart';

/// Contains a set of elements and optionally a next page token
class PaginationResult<TKey extends Object, TResult extends Object> {
  final TKey? _nextPageToken;
  final List<TResult>? _elements;
  final Object? _error;
  final int? _length;

  bool get hasError => _error != null;
  bool get hasNextPageToken => _nextPageToken != null;
  bool get hasElements => _elements != null;
  int get length => _length ?? _elements!.length;

  Object get error => _error!;
  List<TResult> get elements => _elements!;
  TKey? get nextPageToken => _nextPageToken;

  PaginationResult.items({required List<TResult> elements, TKey? nextPageToken, int? size}) 
    : _nextPageToken = nextPageToken,
      _elements = elements,
      _length = size,
      _error = null;

  PaginationResult.error({required Object? error}) 
    : _nextPageToken = null, 
      _elements = null,
      _length = null,
      _error = error;
}