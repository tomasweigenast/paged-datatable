part of 'paged_datatable.dart';

/// Contains a set of elements and optionally a next page token
class PaginationResult<TResult extends Object> {
  final String? _nextPageToken;
  final Iterable<TResult>? _elements;
  final Object? _error;

  bool get hasError => _error != null;
  bool get hasNextPageToken => _nextPageToken != null && _nextPageToken!.isNotEmpty;
  bool get hasElements => _elements != null;

  Object get error => _error!;
  Iterable<TResult> get elements => _elements!;
  String get nextPageToken => _nextPageToken!;
  

  PaginationResult.items({required Iterable<TResult> elements, String? nextPageToken}) 
    : _nextPageToken = nextPageToken,
      _elements = elements,
      _error = null;

  PaginationResult.error({required Object? error}) 
    : _nextPageToken = null, 
      _elements = null,
      _error = error;
}