import 'dart:math';

/// A rational number represented as a fraction of two BigInts.
class Rat {
  factory Rat(
    BigInt n,
    BigInt m,
  ) {
    if (m == BigInt.zero) {
      throw ArgumentError.value(m, 'm', 'cannot be zero');
    } else if (m < BigInt.zero) {
      n = -n;
      m = -m;
    }

    return Rat._(n, m);
  }

  Rat._(this.n, this.d);

  final BigInt n;
  final BigInt d;

  static Rat fromInt(int n) {
    return Rat(BigInt.from(n), BigInt.one);
  }

  static Rat fromInts(int n, int d) {
    return Rat(BigInt.from(n), BigInt.from(d));
  }

  static Rat fromBigInt(BigInt n) {
    return Rat(n, BigInt.one);
  }

  static Rat fromDouble(double n) {
    // The approximation algorithm that toString uses is pretty good, but not
    // perfect. A perfect representation of 2 ^ exponent * significand is easily
    // possible, but would create colossal fractions for some exponents.
    final parts = n.toString().split('.');
    final d = pow(10, parts[1].length);
    return Rat(BigInt.from(n * d), BigInt.from(d));
  }

  static Rat parse(String n) {
    final parts = n.split('/');
    if (parts.length == 1) {
      if (n.contains('.')) {
        return fromDouble(double.parse(n));
      } else {
        return Rat(BigInt.parse(parts[0]), BigInt.one);
      }
    }
    return Rat(BigInt.parse(parts[0]), BigInt.parse(parts[1]));
  }

  static final Rat zero = Rat.fromInt(0);
  static final Rat one = Rat.fromInt(1);

  bool get isPositive => n >= BigInt.zero;
  bool get isNegative => n < BigInt.zero;
  bool get isZero => n == BigInt.zero;
  bool get isInteger => d == BigInt.one;

  Rat operator +(Rat other) {
    return Rat(n * other.d + other.n * d, d * other.d);
  }

  Rat operator -(Rat other) {
    if (d == other.d) {
      return Rat(n - other.n, d);
    }
    return Rat(n * other.d - other.n * d, d * other.d);
  }

  Rat operator *(Rat other) {
    return Rat(n * other.n, d * other.d);
  }

  Rat operator /(Rat other) {
    return Rat(n * other.d, d * other.n);
  }

  bool operator <(Rat other) {
    return n * other.d < other.n * d;
  }

  bool operator <=(Rat other) {
    return n * other.d <= other.n * d;
  }

  bool operator >(Rat other) {
    return n * other.d > other.n * d;
  }

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

  BigInt truncate() => n ~/ d;

  BigInt floor() => n < BigInt.one ? n ~/ d - BigInt.one : n ~/ d;

  BigInt ceil() => n < BigInt.one ? n ~/ d : n ~/ d + BigInt.one;

  double toDouble() => n.toDouble() / d.toDouble();

  BigInt toBigInt() {
    if (d == BigInt.one) {
      return n;
    }
    throw StateError('Cannot convert fraction $this to BigInt');
  }

  int toInt() => toBigInt().toInt();

  Rat abs() => Rat(n.abs(), d);
}
