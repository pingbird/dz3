import 'package:z3/scoped.dart';
import 'package:z3/z3.dart';

import 'debug.dart';

void main() async {
  await initDebug();

  // Create a 2d array of variables
  final board = <List<ConstVar>>[
    for (var j = 0; j < 9; j++)
      [
        for (var i = 0; i < 9; i++) constVar('x$i$j', intSort),
      ],
  ];

  final s = solver();

  // Each cell is 1 to 9
  for (var j = 0; j < 9; j++) {
    for (var i = 0; i < 9; i++) {
      s.add(ge(board[i][j], intFrom(1)));
      s.add(le(board[i][j], intFrom(9)));
    }
  }

  // Each row has distinct numbers
  for (var i = 0; i < 9; i++) {
    s.add(distinctN(board[i]));
  }

  // Each column has distinct numbers
  for (var i = 0; i < 9; i++) {
    s.add(distinctN([
      for (var j = 0; j < 9; j++) board[j][i],
    ]));
  }

  // Each 3x3 square has distinct numbers
  for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 3; j++) {
      s.add(distinctN([
        for (var k = 0; k < 3; k++)
          for (var l = 0; l < 3; l++) board[i * 3 + k][j * 3 + l],
      ]));
    }
  }

  // Add some numbers
  s.add(eq(board[4][2], intFrom(1)));
  s.add(eq(board[5][6], intFrom(2)));

  // Solve
  s.ensureSat();
  final model = s.getModel();

  // Print solution
  for (var j = 0; j < 9; j++) {
    final row = <int>[
      for (var i = 0; i < 9; i++)
        model.evalConst<IntNumeral>(board[j][i])!.toInt(),
    ];
    if (j % 3 == 0) {
      print('+-------+-------+-------+');
    }
    print(
      '| ${row.sublist(0, 3).join(' ')} | ${row.sublist(3, 6).join(' ')} | ${row.sublist(6, 9).join(' ')} |',
    );
  }
  print('+-------+-------+-------+');

  // Get stats
  final stats = s.getStats();
  print(stats);
}
