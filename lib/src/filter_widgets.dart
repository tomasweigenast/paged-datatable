part of 'paged_datatable.dart';

class _DateTimePicker extends StatefulWidget {
  final DateTime firstDate, lastDate;
  final DateTime? initialDate;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final bool Function(DateTime)? selectableDayPredicate;
  final DateFormat dateFormat;
  final DateTime? value;
  final void Function(DateTime) onChanged;
  final InputDecoration inputDecoration;
  final String name;

  const _DateTimePicker({
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    required this.initialDatePickerMode,
    required this.initialEntryMode,
    required this.selectableDayPredicate,
    required this.dateFormat,
    required this.value,
    required this.onChanged,
    required this.inputDecoration,
    required this.name,
  });

  @override
  State<StatefulWidget> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<_DateTimePicker> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(
        text: widget.value == null
            ? null
            : widget.dateFormat.format(widget.value!));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: textController,
      decoration: widget.inputDecoration.copyWith(
        labelText: widget.name,
      ),
      onTap: () async {
        final DateTime? result = await showDatePicker(
          context: context,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initialDate: widget.initialDate,
          initialDatePickerMode: widget.initialDatePickerMode,
          currentDate: widget.value,
          initialEntryMode: widget.initialEntryMode,
          selectableDayPredicate: widget.selectableDayPredicate,
        );

        if (result != null) {
          textController.text = widget.dateFormat.format(result);
          widget.onChanged(result);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}

class _DateRangePicker extends StatefulWidget {
  final DateTime firstDate, lastDate;
  final DateTimeRange? initialDateRange;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final String Function(DateTimeRange) formatter;
  final DateTimeRange? value;
  final void Function(DateTimeRange) onChanged;
  final String name;
  final InputDecoration inputDecoration;
  final TransitionBuilder? dialogBuilder;

  const _DateRangePicker({
    required this.firstDate,
    required this.lastDate,
    required this.initialDateRange,
    required this.value,
    required this.initialDatePickerMode,
    required this.initialEntryMode,
    required this.formatter,
    required this.onChanged,
    required this.name,
    required this.inputDecoration,
    required this.dialogBuilder,
  });

  @override
  State<StatefulWidget> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<_DateRangePicker> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(
        text: widget.value == null ? null : widget.formatter(widget.value!));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: textController,
      decoration: widget.inputDecoration.copyWith(
        labelText: widget.name,
      ),
      onTap: () async {
        final DateTimeRange? result = await showDateRangePicker(
          context: context,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          currentDate: widget.value?.start,
          initialEntryMode: widget.initialEntryMode,
          initialDateRange: widget.initialDateRange,
          builder: widget.dialogBuilder,
        );

        if (result != null) {
          textController.text = widget.formatter(result);
          widget.onChanged(result);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}
