part of 'paged_datatable.dart';

final class _SelectRowCheckbox<K extends Comparable<K>, T> extends StatelessWidget {
  final int index;

  const _SelectRowCheckbox({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final tableController = TableControllerProvider.of<K, T>(context);

    return Checkbox(
      value: tableController._selectedRows.contains(index),
      tristate: false,
      onChanged: (_) => tableController.toggleRow(index),
    );
  }
}

final class _SelectAllRowsCheckbox<K extends Comparable<K>, T> extends StatefulWidget {
  const _SelectAllRowsCheckbox({super.key});

  @override
  State<StatefulWidget> createState() => _SelectAllRowsCheckboxState<K, T>();
}

final class _SelectAllRowsCheckboxState<K extends Comparable<K>, T> extends State<_SelectAllRowsCheckbox<K, T>> {
  late final tableController = TableControllerProvider.of<K, T>(context);
  bool? state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _onTableControllerChanged();
    tableController.addListener(_onTableControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: state,
      tristate: true,
      onChanged: (newValue) {
        switch (newValue) {
          case false:
          case null:
            tableController.unselectEveryRow();
            break;

          case true:
            tableController.selectAllRows();
            break;
        }
      },
    );
  }

  void _onTableControllerChanged() {
    final newState = tableController._selectedRows.isEmpty
        ? false
        : tableController._selectedRows.length == tableController._totalItems
            ? true
            : null;

    if (state != newState) {
      setState(() {
        state = newState;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    tableController.removeListener(_onTableControllerChanged);
  }
}
