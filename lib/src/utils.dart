bool listEquals<E>(List<E>? list1, List<E>? list2) {
  if (identical(list1, list2)) return true;
  if (list1 == null || list2 == null) return false;
  final length = list1.length;
  if (length != list2.length) return false;
  for (var i = 0; i < length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

const kEmptyString = "";

extension IterableX<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    var index = 0;
    for (var element in this) {
      yield convert(index++, element);
    }
  }
}
