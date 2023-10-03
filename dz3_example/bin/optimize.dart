import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug(release: true);

  print(simplify($(-123) % $(5)));
  print(simplify($(123) % $(5)));

  print(simplify(rem($(-123), $(5))));
  print(simplify(rem($(123), $(5))));

  print(-123 % 5);
  print(123 % 5);

  print((-123).remainder(5));
  print(123.remainder(5));
}
