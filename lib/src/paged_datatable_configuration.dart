part of 'paged_datatable.dart';

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
  /// The interval between allowed table refreshes
  final Duration? refreshInterval;

  /// The list of available page sizes the user can select.
  /// Set it to null to disable user-selected page size.
  final List<int>? pageSizes;

  /// Configuration related to the footer of the table.
  final PagedDataTableFooterConfiguration footer;

  const PagedDataTableConfigurationData({
    this.refreshInterval,
    this.pageSizes = const [10, 20, 50, 100],
    this.footer = const PagedDataTableFooterConfiguration()
  });
}

class PagedDataTableFooterConfiguration {

  /// If true, the footer will show the current total elements of the table, otherwise, it will show
  /// the current page's index.
  final bool showTotalElements;

  const PagedDataTableFooterConfiguration({this.showTotalElements = false});
}