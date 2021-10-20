import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:paged_datatable/src/helpers/date_format.dart';

typedef RefreshButtonDateFormattingFunction = String Function(BuildContext context, DateTime? dateTime);

class PagedDataTableConfigurationData extends Equatable {
  
  /// The type of loader shown in the app.
  final PagedDataTableLoader loader;
  
  /// If true, it will enable transition animations.
  final bool enableTransitions;

  /// A function that returns a widget depending on an animation when [enableTransitions] is true.
  final Widget Function(Widget, Animation<double>)? transitionBuilder;
  
  /// The configuration theme.
  final PagedDataTableTheme? theme;

  /// A function that gets called when an event is fired and a message is shown.
  /// Use it to customise how messages are shown.
  final MessageEventNotifier? messageEventNotifier;

  /// A function that formats a given date to be displayed in the Refresh button.
  final RefreshButtonDateFormattingFunction refreshButtonDateFormatting;
  
  /// Indicates if the refresh button is enabled
  final bool refreshButtonEnabled;

  final PagedDataTableInternalization? internalization;

  const PagedDataTableConfigurationData({
    this.loader = const PagedDataTableLoader.linear(),
    this.enableTransitions = false,
    this.transitionBuilder,
    this.theme,
    this.messageEventNotifier,
    this.refreshButtonDateFormatting = VerboseDateFormat.format,
    this.refreshButtonEnabled = true,
    this.internalization});

  @override
  List<Object?> get props => throw UnimplementedError();

}

class PagedDataTableInternalization {
  final String showFilterMenuTooltipText;
  final String filterByTitle;
  final String applyFilterButtonText;
  final String cancelFilteringButtonText;
  final String removeAllFiltersButtonText;
  final String removeFilterButtonText;
  final String refreshButtonText;
  final String rowsPerPageText;
  final String pageIndicatorText;
  final String nextPageButtonText;
  final String previousPageButtonText;
  final String tableResetDuePreviousPageNotFound;
  final String tableResetDueCacheReset;

  const PagedDataTableInternalization({
    required this.showFilterMenuTooltipText,
    required this.filterByTitle,
    required this.applyFilterButtonText,
    required this.cancelFilteringButtonText,
    required this.removeAllFiltersButtonText,
    required this.removeFilterButtonText,
    required this.refreshButtonText,
    required this.rowsPerPageText,
    required this.pageIndicatorText,
    required this.nextPageButtonText,
    required this.previousPageButtonText,
    required this.tableResetDueCacheReset,
    required this.tableResetDuePreviousPageNotFound
  });
}

class PagedDataTableLoader {

  final Widget child;

  const PagedDataTableLoader.circular() : child = const Center(child: CircularProgressIndicator());
  const PagedDataTableLoader.linear() : child = const Align(child: LinearProgressIndicator(), alignment: Alignment.topCenter);
  const PagedDataTableLoader.custom({required this.child});
  
}

class MessageEventNotifier {
  final void Function(String message)? function;

  const MessageEventNotifier.disabled() : function = null;
  // ignore: prefer_initializing_formals
  const MessageEventNotifier.function(void Function(String message) function) : function = function;
}