import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug(release: true);

  final s = solver();

  final isPrime = constVar('isPrime', arraySort(intSort, boolSort));
  final x = constVar('x', intSort);
  final y = constVar('y', intSort);
  s.add(forall(
    [x],
    isPrime[x].eq(
      (x > 1) &
          forall(
            [y],
            (x % y).notEq(0),
            when: (y > 1) & (y < x),
          ),
    ),
  ));

  final model = s.ensureSat();

  for (var i = 1; i < 100; i += 2) {
    if (model[isPrime[i]].toBool()) {
      print('$i is prime');
    } else {
      print('$i is not prime');
    }
  }
}
