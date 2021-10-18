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

  /// `Show filter menu`
  String get showFilterMenuTooltip {
    return Intl.message(
      'Show filter menu',
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

  /// `Refresh. Refreshed {time}`
  String refreshButtonText(Object time) {
    return Intl.message(
      'Refresh. Refreshed $time',
      name: 'refreshButtonText',
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

  /// `never`
  String get refreshTimeFormattingNever {
    return Intl.message(
      'never',
      name: 'refreshTimeFormattingNever',
      desc: '',
      args: [],
    );
  }

  /// `just now`
  String get refreshTimeFormattingJustNow {
    return Intl.message(
      'just now',
      name: 'refreshTimeFormattingJustNow',
      desc: '',
      args: [],
    );
  }

  /// `a minute ago`
  String get refreshTimeFormattingAMinuteAgo {
    return Intl.message(
      'a minute ago',
      name: 'refreshTimeFormattingAMinuteAgo',
      desc: '',
      args: [],
    );
  }

  /// `a few minutes ago`
  String get refreshTimeFormattingAFewMinutesAgo {
    return Intl.message(
      'a few minutes ago',
      name: 'refreshTimeFormattingAFewMinutesAgo',
      desc: '',
      args: [],
    );
  }

  /// `an hour ago`
  String get refreshTimeFormattingAnHourAgo {
    return Intl.message(
      'an hour ago',
      name: 'refreshTimeFormattingAnHourAgo',
      desc: '',
      args: [],
    );
  }

  /// `today at {time}`
  String refreshTimeFormattingTodayAt(Object time) {
    return Intl.message(
      'today at $time',
      name: 'refreshTimeFormattingTodayAt',
      desc: '',
      args: [time],
    );
  }

  /// `yesterday at {time}`
  String refreshTimeFormattingYesterdayAt(Object time) {
    return Intl.message(
      'yesterday at $time',
      name: 'refreshTimeFormattingYesterdayAt',
      desc: '',
      args: [time],
    );
  }

  /// `on {time}`
  String refreshTimeFormattingAnotherTime(Object time) {
    return Intl.message(
      'on $time',
      name: 'refreshTimeFormattingAnotherTime',
      desc: '',
      args: [time],
    );
  }

  /// `Table has been reset because local cache has expired.`
  String get tableResetDueCacheReset {
    return Intl.message(
      'Table has been reset because local cache has expired.',
      name: 'tableResetDueCacheReset',
      desc: '',
      args: [],
    );
  }

  /// `Table has been reset because the requested page was not found in cache.`
  String get tableResetDuePreviousPageNotFound {
    return Intl.message(
      'Table has been reset because the requested page was not found in cache.',
      name: 'tableResetDuePreviousPageNotFound',
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
