part of 'paged_datatable.dart';

class _DateTimePicker extends HookWidget {
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
  Widget build(BuildContext context) {
    var textController = useTextEditingController();
    var currentValueRef = useRef<DateTime?>(null);
    var dateFormat = useMemoized(() {
      var df = this.dateFormat ?? DateFormat.yMd();
      if(initialDate != null) {
        currentValueRef.value = initialDate;
        textController.text = df.format(currentValueRef.value!);
      }

      return df;
    });

    return TextFormField(
      decoration: decoration,
      readOnly: true,
      controller: textController,
      onTap: () async {
        currentValueRef.value = await showCalendarDatePicker2Dialog(
          context: context, 
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.single,
            firstDate: firstDate,
            lastDate: lastDate,
            currentDate: initialDate
          ), 
          dialogSize: const Size(496.0, 346.0),
        ).then((value) {
          if(value == null) {
            return null;
          }

          return value.first!;
        });

        if(currentValueRef.value != null) {
          textController.text = dateFormat.format(currentValueRef.value!);
        }
      },
      onSaved: (_) => onSaved(currentValueRef.value),
    );
  }
}

class _DateTimeRangePicker extends HookWidget {
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
  Widget build(BuildContext context) {
    var textController = useTextEditingController();
    var currentValueRef = useRef<DateTimeRange?>(null);
    var dateFormat = useMemoized(() {
      var df = this.dateFormat ?? DateFormat.yMd();
      if(initialValue != null) {
        currentValueRef.value = initialValue;
        textController.text = _format(df, currentValueRef);
      }

      return df;
    });


    return TextFormField(
      decoration: decoration,
      readOnly: true,
      controller: textController,
      onTap: () async {
        currentValueRef.value = await showCalendarDatePicker2Dialog(
          context: context, 
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.range,
            firstDate: firstDate,
            lastDate: lastDate,
            currentDate: initialValue?.start,
          ), 
          dialogSize: const Size(496.0, 346.0),
        ).then((value) {
          if(value == null) {
            return null;
          }

          return DateTimeRange(start: value.first!, end: value.last!);
        });

        if(currentValueRef.value != null) {
          textController.text = _format(dateFormat, currentValueRef);
        }
      },
      onSaved: (_) => onSaved(currentValueRef.value),
    );
  }

   String _format(DateFormat dateFormat, ObjectRef<DateTimeRange?> currentValueRef) {
    return "${dateFormat.format(currentValueRef.value!.start)} - ${dateFormat.format(currentValueRef.value!.end)}";
  }

}