import 'package:flutter/material.dart';

class DropdownTableColumnWidget<T> extends StatefulWidget {

  final Future Function(T newValue)? onChange;
  final T initialValue;
  final List<T> items;
  final String Function(T value) valueFormatter;

  const DropdownTableColumnWidget({required this.onChange, required this.initialValue, required this.valueFormatter, required this.items, Key? key }) : super(key: key);

  @override
  _DropdownTableColumnWidgetState<T> createState() => _DropdownTableColumnWidgetState<T>();
}

class _DropdownTableColumnWidgetState<T> extends State<DropdownTableColumnWidget<T>> {

  late T currentValue;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: widget.items.map((value) => DropdownMenuItem(
        child: Text(widget.valueFormatter(value), style: Theme.of(context).textTheme.bodyText2!.copyWith(color: isLoading ? Colors.grey : null)),
        value: value,
      )).toList(),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero
      ),
      value: currentValue,
      isExpanded: true,
      onChanged: widget.onChange == null || isLoading ? null : (newValue) async {
        if(newValue == null || newValue == currentValue) {
          return;
        }

        setState(() {
          isLoading = true;
        });

        currentValue = newValue;
        await widget.onChange!(newValue);

        setState(() {
          isLoading = false;
        });
      },
    );
  }
}