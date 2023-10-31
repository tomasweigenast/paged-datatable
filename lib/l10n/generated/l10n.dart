// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class PagedDataTableLocalization {
  PagedDataTableLocalization();

  static PagedDataTableLocalization? _current;

  static PagedDataTableLocalization get current {
    assert(_current != null,
        'No instance of PagedDataTableLocalization was loaded. Try to initialize the PagedDataTableLocalization delegate before accessing PagedDataTableLocalization.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<PagedDataTableLocalization> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = PagedDataTableLocalization();
      PagedDataTableLocalization._current = instance;

      return instance;
    });
  }

  static PagedDataTableLocalization of(BuildContext context) {
    final instance = PagedDataTableLocalization.maybeOf(context);
    assert(instance != null,
        'No instance of PagedDataTableLocalization present in the widget tree. Did you add PagedDataTableLocalization.delegate in localizationsDelegates?');
    return instance!;
  }

  static PagedDataTableLocalization? maybeOf(BuildContext context) {
    return Localizations.of<PagedDataTableLocalization>(
        context, PagedDataTableLocalization);
  }

  /// `Filter`
  String get showFilterMenuTooltip {
    return Intl.message(
      'Filter',
      name: 'showFilterMenuTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Filter by`
  String get filterByTitle {
    return Intl.message(
      'Filter by',
      name: 'filterByTitle',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get applyFilterButtonText {
    return Intl.message(
      'Apply',
      name: 'applyFilterButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelFilteringButtonText {
    return Intl.message(
      'Cancel',
      name: 'cancelFilteringButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get removeAllFiltersButtonText {
    return Intl.message(
      'Remove',
      name: 'removeAllFiltersButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Remove this filter`
  String get removeFilterButtonText {
    return Intl.message(
      'Remove this filter',
      name: 'removeFilterButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refreshText {
    return Intl.message(
      'Refresh',
      name: 'refreshText',
      desc: '',
      args: [],
    );
  }

  /// `Last refreshed at {time}`
  String refreshedAtText(Object time) {
    return Intl.message(
      'Last refreshed at $time',
      name: 'refreshedAtText',
      desc: '',
      args: [time],
    );
  }

  /// `Rows per page`
  String get rowsPagePageText {
    return Intl.message(
      'Rows per page',
      name: 'rowsPagePageText',
      desc: '',
      args: [],
    );
  }

  /// `Page {currentPage}`
  String pageIndicatorText(Object currentPage) {
    return Intl.message(
      'Page $currentPage',
      name: 'pageIndicatorText',
      desc: '',
      args: [currentPage],
    );
  }

  /// `Showing {totalElements} elements`
  String totalElementsText(Object totalElements) {
    return Intl.message(
      'Showing $totalElements elements',
      name: 'totalElementsText',
      desc: '',
      args: [totalElements],
    );
  }

  /// `Next page`
  String get nextPageButtonText {
    return Intl.message(
      'Next page',
      name: 'nextPageButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Previous page`
  String get previousPageButtonText {
    return Intl.message(
      'Previous page',
      name: 'previousPageButtonText',
      desc: '',
      args: [],
    );
  }

  /// `No items found`
  String get noItemsFoundText {
    return Intl.message(
      'No items found',
      name: 'noItemsFoundText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<PagedDataTableLocalization> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<PagedDataTableLocalization> load(Locale locale) =>
      PagedDataTableLocalization.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
