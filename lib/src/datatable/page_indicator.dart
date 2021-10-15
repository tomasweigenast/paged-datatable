class PageIndicator<T> {
  final List<T> items;
  final String? nextPageToken;
  final Object? error;

  PageIndicator._(this.items, this.nextPageToken, this.error);

  factory PageIndicator.items({required List<T> items, String? nextPageToken}) {
    return PageIndicator._(items, nextPageToken, null);
  }

  factory PageIndicator.error({required Object? error}) {
    return PageIndicator._(const [], null, error);
  }
}