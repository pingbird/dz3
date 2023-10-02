import 'package:z3/scoped.dart';
import 'package:z3/z3.dart';

import 'debug.dart';

const initialBoard = ''
    '+-------+-------+-------+'
    '| _ _ _ | _ 1 _ | _ 3 _ |'
    '| _ _ 9 | _ _ 5 | _ _ 8 |'
    '| 8 _ 4 | _ _ 6 | _ 2 5 |'
    '+-------+-------+-------+'
    '| _ _ _ | _ _ _ | 6 _ _ |'
    '| _ _ 8 | _ _ 4 | _ _ _ |'
    '| 1 2 _ | _ 8 7 | _ _ _ |'
    '+-------+-------+-------+'
    '| 3 _ _ | 9 _ _ | 2 _ _ |'
    '| _ 6 5 | _ _ 8 | _ _ _ |'
    '| 9 _ _ | _ _ _ | _ _ _ |'
    '+-------+-------+-------+';

void main() async {
  await initDebug();

  // Create a 2d array of variables
  final board = <ConstVar>[
    for (var j = 0; j < 9; j++)
      for (var i = 0; i < 9; i++) constVar('x$i$j', intSort),
  ];

  final s = solver();

  for (var i = 0; i < 9; i++) {
    // Each row has distinct numbers
    s.add(distinctN(board.getRange(i * 9, (i + 1) * 9)));

    // Each column has distinct numbers
    s.add(distinctN([for (var j = 0; j < 9; j++) board[j * 9 + i]]));

    // Each 3x3 square has distinct numbers
    s.add(distinctN([
      for (var j = 0; j < 9; j++)
        board[(i * 27) % 81 + (i ~/ 3) * 3 + (j ~/ 3) * 9 + j % 3],
    ]));

    // Each cell is 0 to 9 (exclusive).
    for (var j = 0; j < 9; j++) {
      s.add(board[j * 9 + i].between(0, 9));
    }
  }

  // Parse initial board and constrain it
  final filtered = initialBoard.replaceAll(RegExp('[^_0-9]'), '');
  for (var i = 0; i < 81; i++) {
    if (filtered[i] != '_') {
      s.add(board[i].eq(int.parse(filtered[i]) - 1));
    }
  }

  // Solve
  s.ensureSat();
  final model = s.getModel();

  // Print solution
  for (var j = 0; j < 9; j++) {
    final row = <int>[
      for (var i = 0; i < 9; i++) model[board[j * 9 + i]].toInt() + 1,
    ];
    if (j % 3 == 0) {
      print('+-------+-------+-------+');
    }
    print(
      '| ${row.sublist(0, 3).join(' ')} | '
      '${row.sublist(3, 6).join(' ')} | '
      '${row.sublist(6, 9).join(' ')} |',
    );
  }
  print('+-------+-------+-------+');

  print('time: ${s.getStats().getData()['time']}');
}
