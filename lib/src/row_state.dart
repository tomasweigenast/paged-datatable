part of 'paged_datatable.dart';

final class _Row<T> extends ChangeNotifier {
  T value;
  final int index;

  _Row(this.index, this.value);
}
