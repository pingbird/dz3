import 'dart:math' as math;

import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug(release: true);

  final s = solver();

  final c = constVar('c', intSort);
  final c2 = constVar('c2', intSort);
  final c3 = constVar('c3', intSort);
  final c4 = constVar('c4', intSort);
  final m = constVar('m', intSort);
  final o = constVar('o', intSort);

  var e = 0;
  void f(int x, int y) {
    e *= 8;
    e += y;
    print('$x -> ${(11297762 ~/ math.pow(8, x)) % 8}');
  }

  print((5479453 ~/ math.pow(8, 0)) % 8);
  print((5479453 ~/ math.pow(8, 1)) % 8);
  print((5479453 ~/ math.pow(8, 2)) % 8);

  s.add(c2 > 0);
  s.add(m > 0);

  s.add(c.between(-1000000000, 1000000000));
  s.add(c2.between(-1000000000, 1000000000));
  s.add(c3.between(-1000000000, 1000000000));
  s.add(c4.between(-1000000000, 1000000000));
  s.add(o.between(-1000000000, 1000000000));

  f(7, 5);
  f(6, 3);
  f(5, 0);
  f(4, 6);
  f(3, 1);
  f(2, 7);
  f(1, 4);
  f(0, 2);

  print(e);

  final model = s.ensureSat();

  print('c = ${model[c]}');
  print('c2 = ${model[c2]}');
  print('c3 = ${model[c3]}');
  print('m = ${model[m]}');
  print('o = ${model[o]}');

  int f2(int x) {
    return (((x * model[c].toInt()) + model[o].toInt()) % model[m].toInt()) ~/
        model[c2].toInt();
  }

  for (var i = 0; i < 8; i++) {
    print('$i -> ${f2(i)}');
  }
}
