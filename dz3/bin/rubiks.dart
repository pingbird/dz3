import 'package:z3/scoped.dart';

import 'debug.dart';

enum Move {
  up,
  right,
  front,
}

enum Color {
  white('W'), // 0, up
  orange('O'), // 1, left
  green('G'), // 2, front
  red('R'), // 3, right
  blue('B'), // 4, back
  yellow('Y'); // 5, down

  const Color(this.letter);
  final String letter;
}

const initialState = ''
    '      B R R            '
    '      B W G            '
    '      O O G            '
    'W W G W G R W W B W W O'
    'O O O W G Y R R Y B B Y'
    'B B R Y Y Y O G Y R R Y'
    '      G G G            '
    '      O Y R            '
    '      O B B            ';

void main() async {
  await initDebug();

  declareEnumValues(Move.values);
  declareEnumValues(Color.values);

  const w = 3;
  const numTiles = (w * w) - 1; // Don't count the center as a tile

  final s = solver();

  final moves = constVar('moves', arraySort(intSort, $s<Move>()));

  // Multi-dimensional array from [move, face, tile] to color
  final states = constVar(
    'states',
    arraySortN(
      [intSort, $s<Color>(), intSort],
      $s<Color>(),
    ),
  );

  // The number of moves, one minus the number of states because the first state
  // is the initial state
  final numMoves = constVar('numMoves', intSort);

  s.add(ge(numMoves, $(0)));

  // Each pair of states between 0 and numMoves (inclusive) are distinct
  final x = constVar('x', intSort);
  final y = constVar('y', intSort);
  final face = constVar('face', $s<Color>());
  final tile = constVar('tile', intSort);
  s.add(forall(
    [x, y, face, tile],
    implies(
      and(
        ge(x, $(0)),
        le(x, $(numMoves)),
        ge(y, $(0)),
        le(y, $(numMoves)),
        ge(tile, $(0)),
        lt(tile, $(numTiles)),
        notEq(x, y),
      ),
      notEq(
        selectN(states, [x, face, tile]),
        selectN(states, [x, face, tile]),
      ),
    ),
  ));

  final face2 = constVar('face2', $s<Color>());
  final tile2 = constVar('tile2', intSort);
  // The last move is solved (all tiles are equal to their face)
  s.add(forall(
    [face2, tile2],
    implies(
      and(ge(tile2, $(0)), lt(tile2, $(numTiles))),
      eq(face2, selectN(states, [$(numMoves), face2, tile2])),
    ),
  ));

  // Decode first state
  final filteredState = initialState
      .split('')
      .expand((e) => Color.values.where((n) => e == n.letter))
      .toList();
  assert(filteredState.length == w * w * Color.values.length);

  assert(filteredState[4] == Color.white);
  assert(filteredState[22] == Color.orange);
  assert(filteredState[25] == Color.green);
  assert(filteredState[28] == Color.red);
  assert(filteredState[31] == Color.blue);
  assert(filteredState[49] == Color.yellow);

  final initList = <int>[
    0, 1, 2, 3, 5, 6, 7, 8, // White
    9, 10, 11, 21, 23, 33, 34, 35, // Orange
    12, 13, 14, 24, 26, 36, 37, 38, // Green
    15, 16, 17, 27, 29, 39, 40, 41, // Red
    18, 19, 20, 30, 32, 42, 43, 44, // Blue
    45, 46, 47, 48, 50, 51, 52, 53, // Yellow
  ];

  for (var i = 0; i < initList.length; i++) {
    s.add(eq(
      selectN(states, [$(0), $(Color.values[i ~/ 8]), $(i % 8)]),
      $(filteredState[initList[i]]),
    ));
  }

  print('assertions:\n${s.getAssertions().join('\n')}');

  final model = s.ensureSat();

  void printState(int move) {
    final colors = <Color>[];
    for (final face in Color.values) {
      for (var i = 0; i < 9; i++) {
        if (i == 4) {
          colors.add(face);
          continue;
        }
        colors.add(
          model
              .eval(selectN(states, [$(move), $(face), $(i - (i ~/ 5))]))!
              .to<Color>(),
        );
      }
    }

    void p(int pad, List<int> idx) {
      print(' ' * pad + idx.map((e) => colors[e].letter).join(' '));
    }

    p(6, [0, 1, 2]);
    p(6, [3, 4, 5]);
    p(6, [6, 7, 8]);
    p(0, [9, 10, 11, 18, 19, 20, 27, 28, 29, 36, 37, 38]);
    p(0, [12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, 41]);
    p(0, [15, 16, 17, 24, 25, 26, 33, 34, 35, 42, 43, 44]);
    p(6, [45, 46, 47]);
    p(6, [48, 49, 50]);
    p(6, [51, 52, 53]);
    print('');
  }

  printState(0);
  print('numMoves: ${model.eval(numMoves)}');
  printState(model.eval(numMoves)!.toInt());
}
