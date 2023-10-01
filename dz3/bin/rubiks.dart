import 'package:z3/scoped.dart';

import 'debug.dart';

enum Move {
  up,
  right,
  front,
}

enum Color {
  white('W'), // 0, up
  yellow('Y'), // 1, down
  red('R'), // 2, right
  orange('O'), // 3, left
  green('G'), // 4, front
  blue('B'); // 5, back

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
  const numFaces = (w * w) - 1; // Don't count the center as a face

  final s = solver();

  final moves = constVar('moves', arraySort(intSort, $s<Move>()));

  // Multi-dimensional array from move number to color to position to
  final states = constVar(
    'states',
    arraySortN(
      [intSort, $s<Color>(), intSort],
      $s<Color>(),
    ),
  );

  // The number of moves
  final numMoves = constVar('numMoves', intSort);

  // Each pair of states between 0 and numMoves are distinct
  final x = constVar('x', intSort);
  final y = constVar('y', intSort);
  final color = constVar('color', $s<Color>());
  final face = constVar('face', intSort);
  s.add(forallConst(
    [x, y, color, face],
    implies(
      and(
        ge(x, $(0)),
        lt(x, $(numMoves)),
        ge(y, $(0)),
        lt(y, $(numMoves)),
        ge(face, $(0)),
        lt(face, $(numFaces)),
        distinct(x, y),
      ),
      distinct(
        selectN(states, [x, color, face]),
        selectN(states, [y, color, face]),
      ),
    ),
  ));

  // The last move is solved (all faces are equal to their color)
  s.add(forallConst(
    [color, face],
    eq(color, selectN(states, [numMoves, color, face])),
  ));

  // Decode first state
  final filteredState = initialState
      .split('')
      .expand((e) => Color.values.where((n) => e == n.letter))
      .toList();
  assert(filteredState.length == w * w * Color.values.length);
  void init(Color color, int face, int i) {
    print('init($color, $face, $i)');
    s.add(eq(
      selectN(states, [$(0), $(color), $(face)]),
      $(filteredState[i]),
    ));
  }

  const ww = w * w;
  const w4 = w * 4;
  const ww5 = ww * 5;

  assert(filteredState[4] == Color.white);
  assert(filteredState[22] == Color.orange);
  assert(filteredState[25] == Color.green);
  assert(filteredState[28] == Color.red);
  assert(filteredState[31] == Color.blue);
  assert(filteredState[49] == Color.yellow);

  init(Color.white, 0, 0);
  init(Color.white, 1, 1);
  init(Color.white, 2, 2);
  init(Color.white, 3, 3);
  init(Color.white, 4, 5);
  init(Color.white, 5, 6);
  init(Color.white, 6, 7);
  init(Color.white, 7, 8);
  init(Color.orange, 0, 9);
  init(Color.orange, 1, 10);
  init(Color.orange, 2, 11);
  init(Color.orange, 3, 21);
  init(Color.orange, 4, 23);
  init(Color.orange, 5, 33);
  init(Color.orange, 6, 34);
  init(Color.orange, 7, 35);
  init(Color.green, 0, 12);
  init(Color.green, 1, 13);
  init(Color.green, 2, 14);
  init(Color.green, 3, 24);
  init(Color.green, 4, 26);
  init(Color.green, 5, 36);
  init(Color.green, 6, 37);
  init(Color.green, 7, 38);
  init(Color.red, 0, 15);
  init(Color.red, 1, 16);
  init(Color.red, 2, 17);
  init(Color.red, 3, 27);
  init(Color.red, 4, 29);
  init(Color.red, 5, 39);
  init(Color.red, 6, 40);
  init(Color.red, 7, 41);
  init(Color.blue, 0, 18);
  init(Color.blue, 1, 19);
  init(Color.blue, 2, 20);
  init(Color.blue, 3, 30);
  init(Color.blue, 4, 32);
  init(Color.blue, 5, 42);
  init(Color.blue, 6, 43);
  init(Color.blue, 7, 44);
  init(Color.yellow, 0, 45);
  init(Color.yellow, 1, 46);
  init(Color.yellow, 2, 47);
  init(Color.yellow, 3, 48);
  init(Color.yellow, 4, 50);
  init(Color.yellow, 5, 51);
  init(Color.yellow, 6, 52);
  init(Color.yellow, 7, 53);

  final model = s.ensureSat();

  void printState(int i) {
    final colors = <Color>[];
    for (final color in Color.values) {
      final face =
          model.eval(selectN(states, [$(i), $(color), $(0)]))!.to<Color>();
    }
  }

  printState(0);
}
