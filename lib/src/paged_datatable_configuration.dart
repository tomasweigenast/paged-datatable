part of 'paged_datatable.dart';

/// Distributes the same [PagedDataTableConfigurationData] across descendants widgets.
class PagedDataTableConfiguration extends InheritedWidget {
  final PagedDataTableConfigurationData data;

  const PagedDataTableConfiguration({required this.data, required super.child, super.key});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => (oldWidget as PagedDataTableConfiguration).data != data;

  static PagedDataTableConfigurationData of(BuildContext context) {
    try {
      return context.dependOnInheritedWidgetOfExactType<PagedDataTableConfiguration>()?.data ?? const PagedDataTableConfigurationData();
    } catch(_) {
      return const PagedDataTableConfigurationData();
    }
  }

}

class PagedDataTableConfigurationData {
  /// A flag that indicates if the current dataset of the table can be refreshed.
  final bool allowRefresh;

  /// The list of available page sizes the user can select.
  /// Set it to null to disable user-selected page size.
  final List<int>? pageSizes;

  /// The initial page size. If [pageSizes] is not null, [initialPageSize] must match
  /// any of the values in the list.
  final int initialPageSize;

  /// Configuration related to the footer of the table.
  final PagedDataTableFooterConfiguration footer;

  const PagedDataTableConfigurationData({
    this.allowRefresh = true,
    this.pageSizes = const [10, 20, 50, 100],
    this.initialPageSize = 100,
    this.footer = const PagedDataTableFooterConfiguration()
  });
}

class PagedDataTableFooterConfiguration {

  /// If true, the footer will show the current total elements of the table, otherwise, it will show
  /// the current page's index.
  final bool showTotalElements;

  const PagedDataTableFooterConfiguration({this.showTotalElements = false});
}