import 'package:z3/scoped.dart';
import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug(release: true);

  final x = mul($(2), add(pow($(2), ratFrom(2, 3)), $(4)));
  final y = mul($(-1), x);
  print(simplify(x));
  print(simplify(y));
  print('isNegative: ${simplify<AlgebraicNumeral>(x).isNegative}');
  print('isNegative: ${simplify<AlgebraicNumeral>(y).isNegative}');
  print('---');
  print(astToString(simplify(x)));
  print(astToString(simplify(y)));
}
