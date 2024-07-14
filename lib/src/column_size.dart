import 'dart:math' as math;

/// Indicates the size of a table column
sealed class ColumnSize {
  const ColumnSize();

  bool get isFixed => false;

  double getFraction(double availableWidth);

  /// The function used to calculate the constraints for the column given the [availableWidth].
  double calculateConstraints(double availableWidth);
}

/// Indicates a fixed size of a column. If the content of a cell does not fit, it will be wrapped
final class FixedColumnSize extends ColumnSize {
  final double size;

  const FixedColumnSize(this.size);

  @override
  int get hashCode => size.hashCode;

  @override
  bool get isFixed => true;

  @override
  bool operator ==(Object other) => other is FixedColumnSize && other.size == size;

  @override
  double calculateConstraints(double availableWidth) => size;

  @override
  double getFraction(double availableWidth) => 0.0;
}

/// Indicates a fraction size of a column. That is, a column that takes a fraction of the available viewport.
final class FractionalColumnSize extends ColumnSize {
  final double fraction;

  const FractionalColumnSize(this.fraction) : assert(fraction > 0, "Fraction cannot be less than or equal to zero.");

  @override
  int get hashCode => fraction.hashCode;

  @override
  bool operator ==(Object other) => other is FractionalColumnSize && other.fraction == fraction;

  @override
  double calculateConstraints(double availableWidth) => availableWidth * fraction;

  @override
  double getFraction(double availableWidth) => fraction;
}

/// Indicates that a column will take the remaining space in the viewport.
final class RemainingColumnSize extends ColumnSize {
  const RemainingColumnSize();

  @override
  double calculateConstraints(double availableWidth) => math.max(0.0, availableWidth);

  @override
  double getFraction(double availableWidth) => 0.0;
}

/// A column size that uses the maximum value of two provided constraints.
final class MaxColumnSize extends ColumnSize {
  final ColumnSize a, b;

  const MaxColumnSize(this.a, this.b);

  @override
  double calculateConstraints(double availableWidth) =>
      math.max(a.calculateConstraints(availableWidth), b.calculateConstraints(availableWidth));

  @override
  bool get isFixed => a.isFixed && b.isFixed;

  @override
  double getFraction(double availableWidth) => math.max(a.getFraction(availableWidth), b.getFraction(availableWidth));
}
