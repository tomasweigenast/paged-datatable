part of 'paged_datatable.dart';

/// Represents a value selector that filters the dataset returned and displayed in the table.
abstract class TableFilter<T extends Object> {
  /// The name of the filter.
  ///
  /// It will appear in the filter dialog.
  final String name;

  /// The id of the filter, used to identify it when fetching data.
  final String id;

  /// Formats [T] to be displayed in the selected filter chip.
  final String Function(T value) chipFormatter;

  /// A flag that indicates if the filter is enabled or not
  final bool enabled;

  /// A flag that indicates if the filter is visible or not
  final bool visible;

  /// The initial value for the filter
  final T? initialValue;

  const TableFilter({
    required this.id,
    required this.name,
    required this.chipFormatter,
    required this.enabled,
    required this.initialValue,
    this.visible = true,
  });

  /// Renders the picker for the filter.
  Widget buildPicker(BuildContext context, FilterState<T> state);

  /// Creates the state of the filter
  FilterState<T> createState() => FilterState._(this);

  @override
  int get hashCode => Object.hash(name, id, enabled, initialValue);

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is TableFilter<T> &&
          other.id == id &&
          other.name == name &&
          other.enabled == enabled &&
          other.initialValue == initialValue);
}

/// A [TableFilter] that renders a [TextFormField].
final class TextTableFilter extends TableFilter<String> {
  final InputDecoration? decoration;

  const TextTableFilter({
    this.decoration,
    required super.chipFormatter,
    required super.id,
    required super.name,
    super.initialValue,
    super.enabled = true,
  });

  @override
  Widget buildPicker(BuildContext context, FilterState<String> state) {
    return TextFormField(
      decoration: decoration ?? InputDecoration(labelText: name),
      initialValue: state.value,
      onSaved: (newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          state.value = newValue;
        }
      },
    );
  }
}

/// A [TableFilter] that is not visible in the filter selection but can be set using the controller.
final class ProgrammingTextFilter<T extends Object> extends TableFilter<T> {
  ProgrammingTextFilter({
    required super.id,
    required super.chipFormatter,
    required super.initialValue,
  }) : super(enabled: true, visible: false, name: "");

  @override
  Widget buildPicker(BuildContext context, FilterState<T> state) =>
      const SizedBox.shrink();
}

/// A [TableFilter] that renders a [DropdownButtonFormField].
final class DropdownTableFilter<T extends Object> extends TableFilter<T> {
  final InputDecoration? decoration;
  final List<DropdownMenuItem<T>> items;

  const DropdownTableFilter({
    this.decoration,
    required this.items,
    required super.chipFormatter,
    required super.id,
    required super.name,
    super.initialValue,
    super.enabled = true,
  });

  @override
  Widget buildPicker(BuildContext context, FilterState<T> state) {
    return DropdownButtonFormField<T>(
      items: items,
      value: state.value,
      onChanged: (newValue) {},
      onSaved: (newValue) {
        state.value = newValue;
      },
      decoration: decoration ?? InputDecoration(labelText: name),
    );
  }
}

/// A [TableFilter] that renders a [TextField] that, when selected, opens a [DateTime] picker.
final class DateTimePickerTableFilter extends TableFilter<DateTime> {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final bool Function(DateTime)? selectableDayPredicate;
  final DateFormat dateFormat;

  DateTimePickerTableFilter({
    required super.id,
    required super.name,
    required super.chipFormatter,
    required super.initialValue,
    required this.firstDate,
    required this.lastDate,
    required this.dateFormat,
    super.enabled = true,
    this.initialDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.selectableDayPredicate,
  });

  @override
  Widget buildPicker(BuildContext context, FilterState<DateTime> state) =>
      _DateTimePicker(
        firstDate: firstDate,
        initialDate: initialDate,
        initialDatePickerMode: initialDatePickerMode,
        initialEntryMode: initialEntryMode,
        lastDate: lastDate,
        selectableDayPredicate: selectableDayPredicate,
        dateFormat: dateFormat,
        value: state.value,
        onChanged: (newValue) {
          state.value = newValue;
        },
      );
}

/// A [TableFilter] that renders a [TextField] that, when selected, opens a [DateTimeRange] picker.
final class DateRangePickerTableFilter extends TableFilter<DateTimeRange> {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialDateRange;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final String Function(DateTimeRange) formatter;

  DateRangePickerTableFilter({
    required super.id,
    required super.name,
    required super.chipFormatter,
    required super.initialValue,
    required this.firstDate,
    required this.lastDate,
    required this.formatter,
    super.enabled = true,
    this.initialDateRange,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
  });

  @override
  Widget buildPicker(BuildContext context, FilterState<DateTimeRange> state) =>
      _DateRangePicker(
        firstDate: firstDate,
        formatter: formatter,
        initialDateRange: initialDateRange,
        initialDatePickerMode: initialDatePickerMode,
        initialEntryMode: initialEntryMode,
        lastDate: lastDate,
        value: state.value,
        onChanged: (newValue) {
          state.value = newValue;
        },
      );
}
