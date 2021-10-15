import 'package:flutter/material.dart';

class CheckboxTableColumnWidget extends StatefulWidget {

  final Future Function(bool newValue)? onChange;
  final bool initialValue;

  const CheckboxTableColumnWidget({required this.onChange, required this.initialValue, Key? key }) : super(key: key);

  @override
  _CheckboxTableColumnWidgetState createState() => _CheckboxTableColumnWidgetState();
}

class _CheckboxTableColumnWidgetState extends State<CheckboxTableColumnWidget> {

  late bool currentValue;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(), 
        ),
      );
    } else {
      return Checkbox(
        value: currentValue,
        tristate: false,
        onChanged: widget.onChange != null ? (newValue) {
          setState(() {
            isLoading = true;
          });

          widget.onChange!.call(newValue!).then((_) {
            setState(() {
              currentValue = newValue;
              isLoading = false;
            });
          });
        } : null,
      );
    }
  }
}