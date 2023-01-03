part of 'paged_datatable.dart';

abstract class TableFilter<TValue> {
  final String title;
  final String id;
  final String Function(TValue value) chipFormatter;

  const TableFilter(
      {required this.id, required this.title, required this.chipFormatter});

  Widget buildPicker(BuildContext context, TableFilterState state);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      other is TableFilter ? other.id == id : false;
}

class TextTableFilter extends TableFilter<String> {
  final InputDecoration? decoration;

  const TextTableFilter(
      {this.decoration,
      required super.chipFormatter,
      required super.id,
      required super.title});

  @override
  Widget buildPicker(BuildContext context, TableFilterState state) {
    return TextFormField(
      decoration: decoration ?? InputDecoration(labelText: title),
      initialValue: state.value,
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          state.value = newValue;
        }
      },
    );
  }
}

class DropdownTableFilter<TValue> extends TableFilter<TValue> {
  final InputDecoration? decoration;
  final List<DropdownMenuItem<TValue>> items;

  const DropdownTableFilter(
      {this.decoration,
      required this.items,
      required super.chipFormatter,
      required super.id,
      required super.title});

  @override
  Widget buildPicker(BuildContext context, TableFilterState state) {
    return DropdownButtonFormField<TValue>(
      items: items,
      value: state.value,
      onChanged: (newValue) {},
      onSaved: (newValue) {
        state.value = newValue;
      },
      decoration: decoration ?? InputDecoration(labelText: title),
    );
  }
}

class DatePickerTableFilter extends TableFilter<DateTime> {
  final InputDecoration? decoration;
  final DateTime firstDate, lastDate;
  final DateFormat? dateFormat;

  const DatePickerTableFilter(
      {this.decoration,
      this.dateFormat,
      required this.firstDate,
      required this.lastDate,
      required super.chipFormatter,
      required super.id,
      required super.title});

  @override
  Widget buildPicker(BuildContext context, TableFilterState state) {
    return _DateTimePicker(
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      initialDate: state.value,
      decoration: decoration ?? InputDecoration(labelText: title),
      onSaved: (newValue) {
        if (newValue != null) {
          state.value = newValue;
        }
      },
    );
  }
}

class DateRangePickerTableFilter extends TableFilter<DateTimeRange> {
  final InputDecoration? decoration;
  final DateTime firstDate, lastDate;
  final DateFormat? dateFormat;

  const DateRangePickerTableFilter(
      {this.decoration,
      this.dateFormat,
      required this.firstDate,
      required this.lastDate,
      required super.chipFormatter,
      required super.id,
      required super.title});

  @override
  Widget buildPicker(BuildContext context, TableFilterState state) {
    return _DateTimeRangePicker(
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      initialValue: state.value,
      decoration: decoration ?? InputDecoration(labelText: title),
      onSaved: (newValue) {
        if (newValue != null) {
          state.value = newValue;
        }
      },
    );
  }
}
