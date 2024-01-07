import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug(release: true);

  // var n = add(intFrom(2).root(2), root(intFrom(2), rat(Rat.fromInt(11, 8))));
  var n = root(intFrom(2), intFrom(2).root(2));
  print(n);
  print('---');
  n = simplify(n);
  print(astToString(n));
  print(n);
  print(n.toDouble());
  print((n as IrrationalNumeral).getCoefficients());
}
