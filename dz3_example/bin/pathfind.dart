import 'package:z3/z3.dart';

import 'debug.dart';

const initialState = ''
    '#################\n'
    '#       #       #\n'
    '#    #  #   # ###\n'
    '#   #   #   #   #\n'
    '#. #        # _ #\n'
    '#################\n';

void main() async {
  await initDebug();
  final initialStateLines = initialState.trim().split('\n');

  final s = solver();

  final pos = declareTupleNamed('Pos', {'x': intSort, 'y': intSort});

  // Grid of boolean defining walls
  final walls = constVar('walls', arraySort(pos.sort, boolSort));

  // Array of positions in the path from 0 to last (inclusive)
  final path = constVar('path', arraySort(intSort, pos.sort));

  // Index of the last position in the path
  final last = constVar('last', intSort);

  final width = initialStateLines[0].length;
  final height = initialStateLines.length;

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final c = initialStateLines[y][x];
      // Add walls
      s.add(walls[pos(x, y)].eq(c == '#'));
      if (c == '.') {
        // The first position is the start
        s.add(path[0].eq(pos(x, y)));
      } else if (c == '_') {
        // The last position is the end
        s.add(path[last].eq(pos(x, y)));
      }
    }
  }

  s.add(last > 0);

  final i = constVar('i', intSort);
  final j = constVar('j', intSort);

  // Path stays within bounds
  s.add(forall(
    [i],
    (path[i]['x'].between(0, width)) & (path[i]['y'].between(0, height)),
    when: i.between(0, last),
  ));

  // Walls are unreachable
  s.add(forall(
    [i],
    ~walls[path[i]],
    when: i.between(0, last),
  ));

  // Path points are adjacent
  s.add(forall(
    [i],
    path[i + 1].eq(pos(path[i]['x'] + 1, path[i]['y'])) | // right
        path[i + 1].eq(pos(path[i]['x'] - 1, path[i]['y'])) | // left
        path[i + 1].eq(pos(path[i]['x'], path[i]['y'] + 1)) | // down
        path[i + 1].eq(pos(path[i]['x'], path[i]['y'] - 1)), // up
    when: i.between(0, last),
  ));

  // Path points are distinct
  s.add(forall(
    [i, j],
    distinct(path[i], path[j]),
    when: distinct(i, j) & i.betweenIn(0, last) & j.betweenIn(0, last),
  ));

  for (;;) {
    final result = s.check();
    if (result == false) {
      print('exhausted solutions');
      break;
    } else if (result == null) {
      print('unknown: ${s.getReasonUnknown()}');
      break;
    }

    final model = s.getModel();
    final modelPath = <(int, int)>{
      for (var i = 0; i <= model[last].toInt(); i++)
        (model[path[i]['x']].toInt(), model[path[i]['y']].toInt()),
    };
    final modelWalls = <(int, int)>{
      for (var y = 0; y < height; y++)
        for (var x = 0; x < width; x++)
          if (model[walls[pos(x, y)]].toBool()) (x, y),
    };

    for (var y = 0; y < height; y++) {
      final row = <StringBuffer>[];
      for (var x = 0; x < width; x++) {
        if (modelPath.contains((x, y))) {
          row.add(StringBuffer('.'));
        } else if (modelWalls.contains((x, y))) {
          row.add(StringBuffer('#'));
        } else {
          row.add(StringBuffer(' '));
        }
      }
      print(row.join());
    }
    print('score: ${modelPath.length}');
    print('time: ${s.getStats().getData()['time']}');
    print('-' * 80);

    // Check for a better solution
    s.add(last < model[last]);
  }
}
