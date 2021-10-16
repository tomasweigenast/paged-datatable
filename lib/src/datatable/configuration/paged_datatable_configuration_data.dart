import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paged_datatable/paged_datatable.dart';

class PagedDataTableConfigurationData extends Equatable {
  
  /// The type of loader shown in the app.
  final PagedDataTableLoader loader;
  
  /// If true, it will enable transition animations.
  final bool enableTransitions;
  
  /// The configuration theme.
  final PagedDataTableTheme? theme;

  /// A function that gets called when an event is fired and a message is shown.
  /// Use it to customise how messages are shown.
  final MessageEventNotifier? messageEventNotifier;
  
  const PagedDataTableConfigurationData({
    this.loader = const PagedDataTableLoader.linear(),
    this.enableTransitions = false,
    this.theme,
    this.messageEventNotifier});

  @override
  List<Object?> get props => throw UnimplementedError();

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