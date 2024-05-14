/// A set of properties used to configure a [PagedDataTable]
final class PagedDataTableConfiguration {
  /// A flag that indicates if the table should copy the list of items returned
  /// by a fetch callback.
  ///
  /// This is useful when you don't want to accidentally modify the returned list.
  final bool copyItems;

  const PagedDataTableConfiguration({this.copyItems = false});
}
