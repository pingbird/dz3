import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug();
  print('version: $z3GlobalVersion');
  print('full version: $z3GlobalFullVersion');
}
