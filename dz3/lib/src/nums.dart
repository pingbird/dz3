import 'dart:math';

import 'package:meta/meta.dart';

/// A rational number represented as a fraction of two BigInts.
///
/// For efficiency reasons the fraction is not normalized. This means that two
/// [Rat]s with equivalent fractions may not be equal. Use [normalize] to get a
/// normalized [Rat].
@immutable
class Rat {
  /// Creates a new [Rat] with the given numerator and denominator.
  factory Rat(BigInt n, [BigInt? m]) {
    m ??= BigInt.one;
    if (m == BigInt.zero) {
      throw ArgumentError.value(m, 'm', 'cannot be zero');
    } else if (m < BigInt.zero) {
      n = -n;
      m = -m;
    }

    return Rat._(n, m);
  }

  const Rat._(this.n, this.d);

  /// The numerator of the fraction.
  final BigInt n;

  /// The denominator of the fraction.
  final BigInt d;

  /// Creates a new [Rat] from two integers (numerator and denominator).
  static Rat fromInt(int n, [int d = 1]) {
    return Rat(BigInt.from(n), BigInt.from(d));
  }

  /// Creates a new [Rat] from a double.
  ///
  /// This is a lossy conversion.
  static Rat fromDouble(double n) {
    // The approximation algorithm that toString uses is pretty good, but not
    // perfect. A perfect representation of 2 ^ exponent * significand is easily
    // possible, but would create colossal fractions for some exponents.
    final parts = n.toString().split('.');
    final d = pow(10, parts[1].length);
    return Rat(BigInt.from(n * d), BigInt.from(d));
  }

  /// Parses a [Rat] from a string.
  ///
  /// The string must be in the format `numerator/denominator` or a decimal
  /// number.
  static Rat parse(String n) {
    final parts = n.split('/');
    if (parts.length == 1) {
      if (n.contains('.')) {
        final dotIndex = n.indexOf('.');
        final d = pow(10, n.length - dotIndex - 1);
        return Rat(BigInt.parse(n.replaceAll('.', '')), BigInt.from(d));
      } else {
        return Rat(BigInt.parse(parts[0]), BigInt.one);
      }
    } else if (parts.length != 2) {
      throw ArgumentError.value(n, 'n', 'invalid format');
    }
    return Rat(BigInt.parse(parts[0]), BigInt.parse(parts[1]));
  }

  /// The zero [Rat].
  static final Rat zero = Rat.fromInt(0);

  /// The one [Rat].
  static final Rat one = Rat.fromInt(1);

  /// The two [Rat].
  static final Rat two = Rat.fromInt(2);

  /// The half [Rat].
  static final Rat half = Rat.fromInt(1, 2);

  /// Whether this [Rat] is negative.
  bool get isNegative => n < BigInt.zero;

  /// Whether this [Rat] is zero.
  bool get isZero => n == BigInt.zero;

  /// Whether this [Rat] is an integer.
  bool get isInteger {
    return d == BigInt.one || n.remainder(d) == BigInt.zero;
  }

  /// Adds this [Rat] to [other].
  Rat operator +(Rat other) {
    return Rat(n * other.d + other.n * d, d * other.d);
  }

  /// Subtracts [other] from this [Rat].
  Rat operator -(Rat other) {
    if (d == other.d) {
      return Rat(n - other.n, d);
    }
    return Rat(n * other.d - other.n * d, d * other.d);
  }

  /// Multiplies this [Rat] by [other].
  Rat operator *(Rat other) {
    return Rat(n * other.n, d * other.d);
  }

  /// Divides this [Rat] by [other].
  Rat operator /(Rat other) {
    return Rat(n * other.d, d * other.n);
  }

  /// Returns the modulo of this [Rat] and [other].
  Rat operator %(Rat other) {
    return Rat(n * other.d % (d * other.n), d * other.d);
  }

  /// Returns the remainder of this [Rat] divided by [other].
  Rat remainder(Rat other) {
    return Rat(n.remainder(d * other.n), d * other.d);
  }

  /// Returns the truncating division of this [Rat] by [other].
  BigInt operator ~/(Rat other) {
    return (n * other.d) ~/ (d * other.n);
  }

  /// Returns the negation of this [Rat].
  Rat operator -() {
    return Rat(-n, d);
  }

  /// Returns the absolute value of this [Rat].
  Rat abs() {
    return Rat(n.abs(), d);
  }

  /// Returns the sign of this [Rat].
  int get sign => n.sign;

  /// Returns the integer closest to this [Rat].
  BigInt round() {
    return ((abs() + half).truncate()) * BigInt.from(sign);
  }

  /// Discards the fractional part of this [Rat].
  BigInt truncate() {
    return n ~/ d;
  }

  /// Returns the biggest integer that is less or equal to this [Rat].
  BigInt floor() {
    return isInteger
        ? truncate()
        : n.isNegative
            ? n ~/ d - BigInt.one
            : n ~/ d;
  }

  /// Returns the smallest integer that is greater or equal to this [Rat].
  BigInt ceil() {
    return isInteger
        ? truncate()
        : n.isNegative
            ? n ~/ d
            : n ~/ d + BigInt.one;
  }

  /// Whether this [Rat] is less than [other].
  bool operator <(Rat other) {
    return n * other.d < other.n * d;
  }

  /// Whether this [Rat] is less or equal to [other].
  bool operator <=(Rat other) {
    return n * other.d <= other.n * d;
  }

  /// Whether this [Rat] is greater than [other].
  bool operator >(Rat other) {
    return n * other.d > other.n * d;
  }

  /// Whether this [Rat] is greater or equal to [other].
  bool operator >=(Rat other) {
    return n * other.d >= other.n * d;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Rat) {
      return n == other.n && d == other.d;
    }
    return false;
  }

  /// Returns a new [Rat] with the smallest denominator for the fraction.
  Rat normalize() {
    final gcd = n.gcd(d);
    return Rat(n ~/ gcd, d ~/ gcd);
  }

  @override
  int get hashCode => Object.hash(n, d);

  @override
  String toString() => isInteger ? '$n' : '$n/$d';

  /// Returns this [Rat] as a [double].
  ///
  /// This is a lossy conversion.
  double toDouble() {
    final length = min(n.bitLength, d.bitLength);
    if (length > 65) {
      final shift = length - 65;
      return (n >> shift).toDouble() / (d >> shift).toDouble();
    }
    return n.toDouble() / d.toDouble();
  }

  /// Returns this [Rat] as a [BigInt].
  ///
  /// Throws if this [Rat] is not an integer.
  BigInt toBigInt() {
    if (isInteger) {
      return truncate();
    }
    throw StateError(
      'Fraction $this is not an integer, to truncate use .truncate()',
    );
  }

  /// Returns this [Rat] as an [int].
  ///
  /// Throws if this [Rat] is not an integer, or if the integer is too big to
  /// fit in an [int].
  int toInt() => toBigInt().toInt();
}
