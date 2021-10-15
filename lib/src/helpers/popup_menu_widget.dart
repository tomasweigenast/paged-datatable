import 'package:flutter/material.dart';

class PopupMenuWidget<T> extends PopupMenuEntry<T> {
  final Widget child;
  final double _height;
  
  const PopupMenuWidget({required this.child, double? height, Key? key }) : _height = height ?? kMinInteractiveDimension, super(key: key);

  @override
  State<StatefulWidget> createState() => _PopupMenuWidgetState();

  @override
  double get height => _height;

  @override
  bool represents(T? value) => false;
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) => widget.child;
}