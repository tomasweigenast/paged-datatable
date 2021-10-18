import 'package:paged_datatable/l10n/generated/l10n.dart';
import 'package:paged_datatable/src/datatable/configuration/paged_datatable_configuration_data.dart';

class PagedDataTableCodedIntl implements PagedDataTableLocalization {

  final PagedDataTableInternalization intl;

  const PagedDataTableCodedIntl({required this.intl});

  @override
  String get applyFilterButtonText => intl.applyFilterButtonText;

  @override
  String get cancelFilteringButtonText => intl.cancelFilteringButtonText;

  @override
  String get filterByTitle => intl.filterByTitle;

  @override
  String get nextPageButtonText => intl.nextPageButtonText;

  @override
  String pageIndicatorText(Object currentPage) => intl.pageIndicatorText.replaceAll("{currentPage}", currentPage.toString());

  @override
  String get previousPageButtonText => intl.previousPageButtonText;

  @override
  String refreshButtonText(Object time) => intl.refreshButtonText;

  @override
  String get refreshTimeFormattingAFewMinutesAgo => throw UnimplementedError();

  @override
  String get refreshTimeFormattingAMinuteAgo => throw UnimplementedError();

  @override
  String get refreshTimeFormattingAnHourAgo => throw UnimplementedError();

  @override
  String refreshTimeFormattingAnotherTime(Object time) {
    throw UnimplementedError();
  }

  @override
  String get refreshTimeFormattingJustNow => throw UnimplementedError();

  @override
  String get refreshTimeFormattingNever => throw UnimplementedError();

  @override
  String refreshTimeFormattingTodayAt(Object time) {
    throw UnimplementedError();
  }

  @override
  String refreshTimeFormattingYesterdayAt(Object time) {
    throw UnimplementedError();
  }

  @override
  String get removeAllFiltersButtonText => intl.removeAllFiltersButtonText;

  @override
  String get removeFilterButtonText => intl.removeFilterButtonText;

  @override
  String get rowsPagePageText => intl.rowsPerPageText;

  @override
  String get showFilterMenuTooltip => intl.showFilterMenuTooltipText;

  static PagedDataTableCodedIntl? maybeFrom(PagedDataTableConfigurationData? configuration) {
    if(configuration?.internalization != null) {
      return PagedDataTableCodedIntl(intl: configuration!.internalization!);
    }
  }

  @override
  String get tableResetDueCacheReset => intl.tableResetDueCacheReset;

  @override
  String get tableResetDuePreviousPageNotFound => intl.tableResetDuePreviousPageNotFound;

}