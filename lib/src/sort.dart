final class SortModel {
  final String fieldName;
  final bool descending;

  const SortModel({required this.fieldName, required this.descending});
  const SortModel.descending({required this.fieldName}) : descending = false;
  const SortModel.ascending({required this.fieldName}) : descending = true;
}
