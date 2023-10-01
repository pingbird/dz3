import 'package:z3/scoped.dart';

import 'debug.dart';

enum Move {
  up,
  right,
  front,
}

void main() async {
  await initDebug();

  declareEnumValues(Move.values);

  final moves = constVar('moves', arraySort(intSort, $s<Move>()));
  final states = constVar
}
