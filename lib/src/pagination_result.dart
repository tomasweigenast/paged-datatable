part of 'paged_datatable.dart';

/// Contains a set of elements and optionally a next page token
class PaginationResult<TPaginationKey extends Object, TResult extends Object> {
  final TPaginationKey? _nextPageToken;
  final List<TResult>? _elements;
  final Object? _error;
  final int? _length;

  bool get hasError => _error != null;
  bool get hasNextPageToken => _nextPageToken != null;
  bool get hasElements => _elements != null;
  int get length => _length ?? _elements!.length;

  Object get error => _error!;
  List<TResult> get elements => _elements!;
  TPaginationKey? get nextPageToken => _nextPageToken;

  PaginationResult.items(
      {required List<TResult> elements,
      TPaginationKey? nextPageToken,
      int? size})
      : _nextPageToken = nextPageToken,
        _elements = List.from(
            elements), // Creates a new list because we need to maintain our own cache in order to allow row deletion
        _length = size,
        _error = null;

  PaginationResult.error({required Object? error})
      : _nextPageToken = null,
        _elements = null,
        _length = null,
        _error = error;
}
