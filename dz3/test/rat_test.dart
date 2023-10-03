import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:z3/z3.dart';

void main() {
  test('Constructors', () {
    expect('${Rat(BigInt.one, BigInt.two)}', '1/2');
    expect('${Rat.fromInt(1, 2)}', '1/2');
    expect('${Rat.fromInt(1)}', '1');
    expect('${Rat(BigInt.one)}', '1');
    expect('${Rat.fromDouble(123.456)}', '123456/1000');
    expect('${Rat.parse('1')}', '1');
    expect('${Rat.parse('1/2')}', '1/2');
    expect('${Rat.zero}', '0');
    expect('${Rat.one}', '1');
    expect('${Rat.two}', '2');
    expect('${Rat.half}', '1/2');
  });

  test('Sign', () {
    final one = Rat.fromInt(1);
    expect(one.isNegative, isFalse);
    expect(one.isZero, isFalse);
    expect(one.isInteger, isTrue);
    expect(one.sign, 1);

    final negativeOne = Rat.fromInt(-1);
    expect(negativeOne.isNegative, isTrue);
    expect(negativeOne.isZero, isFalse);
    expect(negativeOne.isInteger, isTrue);
    expect(negativeOne.sign, -1);

    final zero = Rat.fromInt(0);
    expect(zero.isNegative, isFalse);
    expect(zero.isZero, isTrue);
    expect(zero.isInteger, isTrue);
    expect(zero.sign, 0);
  });

  test('Integers', () {
    expect(Rat.fromInt(1, 2).isInteger, isFalse);
    expect(Rat.fromInt(1).isInteger, isTrue);
    expect(Rat.fromInt(4, 2).isInteger, isTrue);
  });

  test('Arithmetic', () {
    expect('${(Rat.fromInt(1, 2) + Rat.fromInt(1, 2)).normalize()}', '1');
    expect('${(Rat.fromInt(1, 2) - Rat.fromInt(1, 2)).normalize()}', '0');
    expect('${(Rat.fromInt(1, 2) * Rat.fromInt(1, 2)).normalize()}', '1/4');
    expect('${(Rat.fromInt(1, 2) / Rat.fromInt(1, 2)).normalize()}', '1');
    expect('${(Rat.fromInt(1, 2) % Rat.fromInt(1, 2)).normalize()}', '0');
    expect('${Rat.fromInt(1, 2) ~/ Rat.fromInt(1, 2)}', '1');
    expect('${(-Rat.fromInt(1, 2)).normalize()}', '-1/2');
    expect('${Rat.fromInt(1, 2).abs()}', '1/2');
  });

  test('Rounding', () {
    expect('${Rat.fromInt(1).round()}', '1');
    expect('${Rat.fromInt(-1).round()}', '-1');
    expect('${Rat.fromInt(1, 2).round()}', '1');
    expect('${Rat.fromInt(-1, 2).round()}', '-1');
    expect('${Rat.fromInt(1, 3).round()}', '0');
    expect('${Rat.fromInt(2, 3).round()}', '1');
    expect('${Rat.fromInt(-1, 3).round()}', '0');
    expect('${Rat.fromInt(-2, 3).round()}', '-1');

    expect('${Rat.fromInt(1).floor()}', '1');
    expect('${Rat.fromInt(-1).floor()}', '-1');
    expect('${Rat.fromInt(1, 2).floor()}', '0');
    expect('${Rat.fromInt(-1, 2).floor()}', '-1');
    expect('${Rat.fromInt(1, 3).floor()}', '0');
    expect('${Rat.fromInt(2, 3).floor()}', '0');
    expect('${Rat.fromInt(-1, 3).floor()}', '-1');
    expect('${Rat.fromInt(-2, 3).floor()}', '-1');

    expect('${Rat.fromInt(1).ceil()}', '1');
    expect('${Rat.fromInt(-1).ceil()}', '-1');
    expect('${Rat.fromInt(1, 2).ceil()}', '1');
    expect('${Rat.fromInt(-1, 2).ceil()}', '0');
    expect('${Rat.fromInt(1, 3).ceil()}', '1');
    expect('${Rat.fromInt(2, 3).ceil()}', '1');
    expect('${Rat.fromInt(-1, 3).ceil()}', '0');
    expect('${Rat.fromInt(-2, 3).ceil()}', '0');

    // Same thing but subnormal

    expect('${Rat.fromInt(2, 2).round()}', '1');
    expect('${Rat.fromInt(-2, 2).round()}', '-1');
    expect('${Rat.fromInt(2, 4).round()}', '1');
    expect('${Rat.fromInt(-2, 4).round()}', '-1');
    expect('${Rat.fromInt(2, 6).round()}', '0');
    expect('${Rat.fromInt(4, 6).round()}', '1');
    expect('${Rat.fromInt(-2, 6).round()}', '0');
    expect('${Rat.fromInt(-4, 6).round()}', '-1');

    expect('${Rat.fromInt(2, 2).floor()}', '1');
    expect('${Rat.fromInt(-2, 2).floor()}', '-1');
    expect('${Rat.fromInt(2, 4).floor()}', '0');
    expect('${Rat.fromInt(-2, 4).floor()}', '-1');
    expect('${Rat.fromInt(2, 6).floor()}', '0');
    expect('${Rat.fromInt(4, 6).floor()}', '0');
    expect('${Rat.fromInt(-2, 6).floor()}', '-1');
    expect('${Rat.fromInt(-4, 6).floor()}', '-1');

    expect('${Rat.fromInt(2, 2).ceil()}', '1');
    expect('${Rat.fromInt(-2, 2).ceil()}', '-1');
    expect('${Rat.fromInt(2, 4).ceil()}', '1');
    expect('${Rat.fromInt(-2, 4).ceil()}', '0');
    expect('${Rat.fromInt(2, 6).ceil()}', '1');
    expect('${Rat.fromInt(4, 6).ceil()}', '1');
    expect('${Rat.fromInt(-2, 6).ceil()}', '0');
    expect('${Rat.fromInt(-4, 6).ceil()}', '0');
  });
}
