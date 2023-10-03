// Solver for a Big Boggle puzzle: https://en.wikipedia.org/wiki/Boggle
// Returns all possible boards given a list of words and a map of how many times
// each cube is used.

import 'package:z3/z3.dart';

import 'debug.dart';

const atoz = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

// The number of times each cube is used.
const usedState = ''
    '11111'
    '12211'
    '22322'
    '22321'
    '34322';

// The words that were played.
const words = [
  'ABATACEPT',
  'SIORDIA',
  'DIEPPA',
  'LEADIN',
  'CLASSICS',
  'ORCIN',
  'TETANI',
];

// Words we are looking for in the resulting board that weren't played yet.
const uncountedWords = [
  'ABSCISSA',
  // 'ORDINATE',
  // 'APPLICATE',
];

void main() async {
  await initDebug(release: true);

  final s = solver();

  final pos = declareTupleNamed('Pos', {'x': intSort, 'y': intSort});

  // Array from y * 5 + x to the letter (0 to 26) on the board
  final board = constVar('board', arraySort(intSort, intSort));

  // Array from y * 5 + x to the number of times that cube was used
  final used = constVar('used', arraySort(intSort, intSort));

  assert(atoz.length == 26);
  assert(usedState.length == 25);

  List<Expr> apply(String word) {
    final letters = word.split('').map(atoz.indexOf).toList();
    assert(!letters.any((e) => e < 0 || e >= 25), '$letters');

    final x = <ConstVar>[];
    final y = <ConstVar>[];

    for (var i = 0; i < letters.length; i++) {
      // Create variables for each letter's position
      x.add(constVar('${word}_${i}_x', intSort));
      y.add(constVar('${word}_${i}_y', intSort));

      // The letter on the board is the same as the letter in the word
      s.add(board[y.last * 5 + x.last].eq(letters[i]));

      // The position is within bounds
      s.add((x.last >= 0) & (x.last < 5) & (y.last >= 0) & (y.last < 5));

      if (i > 0) {
        // The position is diagonal to the previous position
        s.add((abs(x[i] - x[i - 1]) < 2) & (abs(y[i] - y[i - 1]) < 2));
      }
    }

    final coords = List.generate(letters.length, (i) => pos(x[i], y[i]));

    // Each letter is in a distinct position
    s.add(distinctN(coords));

    return coords;
  }

  for (var i = 0; i < 25; i++) {
    // Each letter on the board is 0 to 26
    s.add(board[i].between(0, 26));

    // Each cube was used a specific number of times
    s.add(used[i].eq(int.parse(usedState[i])));
  }

  final allCoords = [for (final word in words) ...apply(word)];

  uncountedWords.forEach(apply);

  // Constrain the number of times each cube is used to the number of times it
  // shows up in the words by
  for (var y = 0; y < 5; y++) {
    for (var x = 0; x < 5; x++) {
      s.add(used[y * 5 + x].eq(addN([
        for (final coord in allCoords) coord.eq(pos(x, y)).thenElse(1, 0),
      ])));
    }
  }

  // These two should match, otherwise its guaranteed unsat
  final letters = words.join().length;
  final uses = usedState.split('').map(int.parse).fold(0, (a, b) => a + b);
  assert(letters == uses, '$letters != $uses');

  // Solve
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
        for (var x = 0; x < 5; x++) atoz[model[board[y * 5 + x]].toInt()],
      ].join(' ')}');
    }

    // Uncomment if used is not constant
    // print('used:');
    // for (var y = 0; y < 5; y++) {
    //   print([
    //     for (var x = 0; x < 5; x++)
    //       model[used[y * 5 + x]].toInt(),
    //   ].join(' '));
    // }

    print('paths:');
    for (final word in words.followedBy(uncountedWords)) {
      print('  $word: ${[
        for (var i = 0; i < word.length; i++)
          '${model[constVar('${word}_${i}_x', intSort)].toInt() + 1},'
              '${model[constVar('${word}_${i}_y', intSort)].toInt() + 1}'
      ].join(' -> ')}');
    }

    // Exclude this solution and try again
    s.add(not(andN([
      for (var i = 0; i < 25; i++) board[i].eq(model[board[i]]),
    ])));

    final time = s.getStats().getData()['time']!;
    print('time: $time');
    total += time;

    print('-' * 80);
  }
}
