part of 'paged_datatable.dart';

final class SelectRowCheckbox<K extends Comparable<K>, T> extends StatelessWidget {
  final int index;

  const SelectRowCheckbox({required this.index, super.key});

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
