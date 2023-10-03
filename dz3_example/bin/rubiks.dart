import 'dart:math' as math;

import 'package:z3/z3.dart';

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

// const initialState = ''
//     '      B R R            '
//     '      B W G            '
//     '      O O G            '
//     'W W G W G R W W B W W O'
//     'O O O W G Y R R Y B B Y'
//     'B B R Y Y Y O G Y R R Y'
//     '      G G G            '
//     '      O Y R            '
//     '      O B B            ';

const initialState = ''
    '      W W G            '
    '      W W G            '
    '      W W G            '
    'O O O G G Y R R R W B B'
    'O O O G G Y R R R W B B'
    'O O O G G Y R R R W B B'
    '      Y Y B            '
    '      Y Y B            '
    '      Y Y B            ';

void main() async {
  await initDebug();

  declareEnumValues(Move.values);
  declareEnumValues(Color.values);

  const w = 3;
  const tilesPerFace = (w * w) - 1; // Don't count the center as a tile
  const numTiles = tilesPerFace * 6;

  final s = solver();

  // Multi-dimensional array from [move, tile] to color.
  // The center tile of each face is not included because it is always the same
  // color, the indices are as follows:
  //       0 1 2
  //       3 W 4
  //       5 6 7
  // 0 1 2 0 1 2 0 1 2 0 1 2
  // 3 O 4 3 G 4 3 R 4 3 B 4
  // 5 6 7 5 6 7 5 6 7 5 6 7
  //       0 1 2
  //       3 Y 4
  //       5 6 7
  final states = constVar(
    'states',
    arraySortN([intSort, intSort], $s<Color>()),
  );

  final moves = constVar('moves', arraySort(intSort, $s<Move>()));

  // The number of moves, one minus the number of states because the first state
  // is the initial state
  final numMoves = constVar('numMoves', intSort);

  // Each pair of states between 0 and numMoves (inclusive) are distinct
  final x = constVar('x', intSort);
  final y = constVar('y', intSort);
  final tile = constVar('tile', intSort);
  // s.add(forall(
  //   [x, y],
  //   exists(
  //     [tile],
  //     tile.between(0, 8) & distinct(states[[x, tile]], states[[y, tile]]),
  //   ),
  //   when: x.betweenIn(0, 1) & y.betweenIn(0, 1) & distinct(x, y),
  // ));

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

  assert(initList.length == numTiles);

  for (var i = 0; i < numTiles; i++) {
    s.add(eq(
      states[[0, i]],
      $(filteredState[initList[i]]),
    ));
  }

  final i = constVar('i', intSort);
  Expr map(int from, int to) {
    return states[[i, from]].eq(states[[i, to]]);
  }

  int rotn(int n, int x) {
    var res = x;
    for (var i = 0; i < n; i++) {
      res = (11297762 ~/ math.pow(8, res)) % 8;
    }
    return res;
  }

  Map<int, int> cw(int face) {
    return {for (var i = 0; i < 8; i++) face * 8 + i: face * 8 + rotn(1, i)};
  }

  Map<int, int> shift(int rot, int from, int rotTo, int to) {
    return {
      for (var i = 0; i < 3; i++)
        from * 8 + rotn(rot, i): to * 8 + rotn(rotTo, i),
    };
  }

  final id = {for (var i = 0; i < numTiles; i++) i: i};

  final moveOps = <Move, Map<int, int>>{
    Move.up: {
      ...id,
      ...cw(0),
      ...shift(0, 1, 0, 2),
      ...shift(0, 2, 0, 3),
      ...shift(0, 3, 0, 4),
      ...shift(0, 4, 0, 1),
    },
    Move.right: {
      ...id,
      ...cw(3),
      ...shift(1, 0, 1, 2),
      ...shift(1, 2, 1, 5),
      ...shift(1, 5, 3, 4),
      ...shift(3, 4, 1, 0),
    },
    Move.front: {
      ...id,
      ...cw(2),
      ...shift(2, 0, 1, 1),
      ...shift(3, 3, 2, 0),
      ...shift(0, 5, 3, 3),
      ...shift(1, 1, 0, 5),
    }
  };

  for (final MapEntry(key: move, value: m) in moveOps.entries) {
    s.add(forall(
      [i],
      andN(m.entries
          .map((e) => states[[i + 1, e.key]].eq(states[[i, e.value]]))),
      when: i.between(0, numMoves) & moves[i].eq(move),
    ));
  }

  // The last move is solved (all tiles are equal to their face)
  for (var i = 0; i < 6; i++) {
    for (var j = 0; j < 8; j++) {
      s.add(states[[numMoves, i * 8 + j]].eq(Color.values[i]));
    }
  }

  s.add(numMoves.between(0, 10));
  s.add(forall([i], moves[i].eq(Move.right)));
  // s.add(moves[0].eq(Move.right));
  // s.add(moves[1].eq(Move.right));
  // s.add(moves[2].eq(Move.right));

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
          model[states[[move, face.index * 8 + (i - i ~/ 5)]]].to<Color>(),
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
  printState(1);
  printState(2);
  printState(3);
  print('numMoves: ${model.eval(numMoves)}');
  // printState(model.eval(numMoves)!.toInt());
}
