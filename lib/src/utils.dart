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
