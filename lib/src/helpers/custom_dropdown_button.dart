import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatefulWidget {

  final List<DropdownItem<T>> items;
  final InputDecoration decoration;
  final T defaultValue;
  final String Function(T value) valueFormatter;
  final void Function(T value)? onChanged;

  const CustomDropdownButton({required this.items, required this.defaultValue, required this.decoration, required this.valueFormatter, required this.onChanged, Key? key }) : super(key: key);

  @override
  CustomDropdownButtonState<T> createState() => CustomDropdownButtonState<T>();
}

class CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      enabled: widget.onChanged != null,
      tooltip: "Open dropdown",
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      padding: EdgeInsets.zero,
      // offset: const Offset(0, -150),
      child: InputDecorator(
        decoration: widget.decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.valueFormatter(widget.defaultValue)),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
      itemBuilder: (context) => widget.items.map((e) => PopupMenuItem(
        child: e.presenter,
        value: e.value,
      )).toList(),
      onSelected: (item) {
        widget.onChanged?.call(item);
      },
    );
  }
}

class DropdownItem<T> {
  final Widget presenter;
  final T value;

  DropdownItem({required this.presenter, required this.value});
}