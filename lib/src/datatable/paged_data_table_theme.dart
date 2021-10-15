import 'package:flutter/cupertino.dart';

class PagedDataTableTheme {
  /// The color of the pagination buttons.
  final Color? paginationButtonsColor;

  /// A function that gets called when an event is fired and a message is shown.
  /// Use it to customise how messages are shown.
  final MessageEventNotifier? messageEventNotifier;

  const PagedDataTableTheme({this.paginationButtonsColor, this.messageEventNotifier});
}

class MessageEventNotifier {
  final void Function(String message)? function;

  const MessageEventNotifier.disabled() : function = null;
  // ignore: prefer_initializing_formals
  const MessageEventNotifier.function(void Function(String message) function) : function = function;
}