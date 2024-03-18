/// Indicates the size of a table column
sealed class ColumnSize {
  const ColumnSize();
}

/// Indicates a fixed size of a column. If the content of a cell does not fit, it will be wrapped
final class FixedColumnSize extends ColumnSize {
  final double size;

  const FixedColumnSize(this.size);

  @override
  int get hashCode => size.hashCode;

  @override
  bool operator ==(Object other) => other is FixedColumnSize && other.size == size;
}

/// Indicates a fraction size of a column. That is, a column that takes a fraction of the available viewport.
final class FractionalColumnSize extends ColumnSize {
  final double fraction;

  const FractionalColumnSize(this.fraction) : assert(fraction > 0, "Fraction cannot be less than or equal to zero.");

  @override
  int get hashCode => fraction.hashCode;

  @override
  bool operator ==(Object other) => other is FractionalColumnSize && other.fraction == fraction;
}

/// Indicates that a column will take the remaining space in the viewport.
final class RemainingColumnSize extends ColumnSize {
  const RemainingColumnSize();
}
