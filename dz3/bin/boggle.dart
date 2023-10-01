// Solver for Big Boggle: https://en.wikipedia.org/wiki/Boggle
// Returns all solutions given a list of words and a map of how many times each
// cube is used.

import 'package:z3/scoped.dart';
import 'package:z3/z3.dart';

import 'debug.dart';

const atoz = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

const usedState = ''
    '11111'
    '12211'
    '22322'
    '22321'
    '34322';

const words = [
  'ABATACEPT',
  'SIORDIA',
  'DIEPPA',
  'LEADIN',
  'CLASSICS',
  'ORCIN',
  'TETANI',
];

const uncountedWords = [
  'ABSCISSA',
  // 'ORDINATE',
  // 'APPLICATE',
];

void main() async {
  await initDebug(release: true);

  final s = solver(params: {'unsat_core': true, 'proof': true});

  final pos = declareTuple('Pos', {'x': intSort, 'y': intSort});

  final board = constVar('board', arraySort(intSort, intSort));

  // Each letter is 0 to 26
  for (var i = 0; i < atoz.length; i++) {
    s.add(and(
      ge(select(board, $(i)), $(0)),
      lt(select(board, $(i)), $(26)),
    ));
  }

  final used = <ConstVar>[
    for (var y = 1; y <= 5; y++)
      for (var x = 1; x <= 5; x++) constVar('s$x$y', intSort),
  ];

  for (var i = 0; i < 25; i++) {
    s.add(eq(used[i], $(int.parse(usedState[i]))));
  }

  List<Expr> apply(String word) {
    final letters = word.split('').map(atoz.indexOf).toList();
    var x = <ConstVar>[];
    var y = <ConstVar>[];

    for (var i = 0; i < letters.length; i++) {
      x.add(constVar('${word}_${i}_x', intSort));
      y.add(constVar('${word}_${i}_y', intSort));
      s.add(eq(select(board, add(mul(y.last, $(5)), x.last)), $(letters[i])));

      if (i > 0) {
        s.add(lt(abs(sub(x[i], x[i - 1])), $(2)));
        s.add(lt(abs(sub(y[i], y[i - 1])), $(2)));
      }
    }

    for (var i = 0; i < letters.length; i++) {
      s.add(and(
        ge(x[i], $(0)),
        lt(x[i], $(5)),
        ge(y[i], $(0)),
        lt(y[i], $(5)),
      ));
    }

    final coords = List.generate(
      letters.length,
      (i) => app(pos.constructor, x[i], y[i]),
    );
    s.add(distinctN(coords));
    return coords;
  }

  final allCoords = [for (final word in words) ...apply(word)];

  for (final word in uncountedWords) {
    apply(word);
  }

  Expr sumCoords(List<Expr> coords, int x, int y) {
    return addN([
      for (final coord in coords)
        ifThenElse(eq(coord, app(pos.constructor, $(x), $(y))), $(1), $(0)),
    ]);
  }

  for (var y = 0; y < 5; y++) {
    for (var x = 0; x < 5; x++) {
      s.add(eq(used[y * 5 + x], sumCoords(allCoords, x, y)));
    }
  }

  // These two should match, otherwise its guaranteed unsat
  final letters = words.join().length;
  final uses = usedState.split('').map(int.parse).fold(0, (a, b) => a + b);
  assert(letters == uses, '$letters != $uses');

  var total = 0.0;
  for (;;) {
    final result = s.check();
    if (result == false) {
      print('exhausted solutions');
      final time = s.getStats().getData()['time']!;
      total += time;
      print('time: $time');
      print('total: $total');
      break;
    } else if (result == null) {
      print('Unknown (${s.getReasonUnknown()})');
      break;
    }

    final model = s.getModel();

    // Print solution
    print('solution:');
    for (var y = 0; y < 5; y++) {
      print('  ${[
        for (var x = 0; x < 5; x++)
          atoz[model.eval<Numeral>(select(board, $(y * 5 + x))).toInt()],
      ].join(' ')}');
    }

    // Uncomment if used is not constant
    // print('used:');
    // for (var y = 0; y < 5; y++) {
    //   print([
    //     for (var x = 0; x < 5; x++)
    //       model.evalConst<Numeral>(used[y * 5 + x])!.toInt(),
    //   ].join(' '));
    // }

    print('paths:');
    for (final word in words.followedBy(uncountedWords)) {
      print('  $word: ${[
        for (var i = 0; i < word.length; i++)
          '${model.evalConst<Numeral>(constVar('${word}_${i}_x', intSort))!.toInt() + 1},'
              '${model.evalConst<Numeral>(constVar('${word}_${i}_y', intSort))!.toInt() + 1}'
      ].join(' -> ')}');
    }

    // Exclude this solution and try again
    s.add(not(andN([
      for (var i = 0; i < 25; i++)
        eq(select(board, $(i)), model.eval(select(board, $(i)))),
    ])));

    final time = s.getStats().getData()['time']!;
    print('time: $time');
    total += time;

    print('-' * 80);
  }
}
