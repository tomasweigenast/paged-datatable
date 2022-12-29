part of 'paged_datatable.dart';

typedef FetchCallback<TKey extends Object, TResult extends Object> = FutureOr<PaginationResult<TResult>> Function(TKey pageToken, int pageSize);