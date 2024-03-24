final class SortModel {
  final String fieldName;
  final bool descending;

  const SortModel({required this.fieldName, required this.descending});
  const SortModel.descending({required this.fieldName}) : descending = true;
  const SortModel.ascending({required this.fieldName}) : descending = false;

  @override
  int get hashCode => Object.hash(fieldName, descending);

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is SortModel && other.fieldName == fieldName && other.descending == descending);
}
