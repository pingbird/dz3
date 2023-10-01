import 'package:z3/scoped.dart';

import 'debug.dart';

void main() async {
  await initDebug();

  final s = solver();

  final desc = s.getParamDescs();

  print('# Solver Options\n');

  for (final opt in desc) {
    print('## ${opt.name} (${opt.kind.name})\n');
    print('${opt.docs}\n');
  }
}
