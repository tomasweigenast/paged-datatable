part of 'paged_datatable.dart';

class _DateTimePicker extends StatefulWidget {
  final InputDecoration? decoration;
  final DateTime firstDate, lastDate;
  final DateTime? initialDate;
  final DateFormat? dateFormat;
  final void Function(DateTime? date) onSaved;

  const _DateTimePicker({
    required this.decoration, 
    required this.initialDate, 
    required this.firstDate, 
    required this.lastDate,
    required this.onSaved,
    required this.dateFormat
  });

  @override
  State<_DateTimePicker> createState() => __DateTimePickerState();
}

class __DateTimePickerState extends State<_DateTimePicker> {
  final textController = TextEditingController();
  late final DateFormat dateFormat;

  DateTime? currentValue;

  @override
  void initState() {
    super.initState();

    dateFormat = widget.dateFormat ?? DateFormat.yMd();
    if(widget.initialDate != null) {
      currentValue = widget.initialDate;
      textController.text = dateFormat.format(currentValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration,
      readOnly: true,
      controller: textController,
      onTap: () async {
        currentValue = await showCalendarDatePicker2Dialog(
          context: context, 
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.single,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            currentDate: widget.initialDate
          ), 
          dialogSize: const Size(496.0, 346.0),
        ).then((value) {
          if(value == null) {
            return null;
          }

          return value.first!;
        });

        if(currentValue != null) {
          textController.text = dateFormat.format(currentValue!);
        }
      },
      onSaved: (_) => widget.onSaved(currentValue),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

class _DateTimeRangePicker extends StatefulWidget {
  final InputDecoration? decoration;
  final DateTime firstDate, lastDate;
  final DateTimeRange? initialValue;
  final DateFormat? dateFormat;
  final void Function(DateTimeRange? date) onSaved;

  const _DateTimeRangePicker({
    required this.decoration, 
    required this.initialValue, 
    required this.firstDate, 
    required this.lastDate,
    required this.onSaved,
    required this.dateFormat
  });

  @override
  State<_DateTimeRangePicker> createState() => __DateTimeRangePickerState();
}

class __DateTimeRangePickerState extends State<_DateTimeRangePicker> {
  final textController = TextEditingController();
  late final DateFormat dateFormat;

  DateTimeRange? currentValue;

  @override
  void initState() {
    super.initState();

    dateFormat = widget.dateFormat ?? DateFormat.yMd();
    if(widget.initialValue != null) {
      currentValue = widget.initialValue;
      textController.text = _format();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration,
      readOnly: true,
      controller: textController,
      onTap: () async {
        currentValue = await showCalendarDatePicker2Dialog(
          context: context, 
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.range,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            currentDate: widget.initialValue?.start,
          ), 
          dialogSize: const Size(496.0, 346.0),
        ).then((value) {
          if(value == null) {
            return null;
          }

          return DateTimeRange(start: value.first!, end: value.last!);
        });

        if(currentValue != null) {
          textController.text = _format();
        }
      },
      onSaved: (_) => widget.onSaved(currentValue),
    );
  }

  String _format() {
    return "${dateFormat.format(currentValue!.start)} - ${dateFormat.format(currentValue!.end)}";
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}