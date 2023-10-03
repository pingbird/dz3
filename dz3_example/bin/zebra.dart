// Solver for Einstein's Zebra puzzle: https://en.wikipedia.org/wiki/Zebra_Puzzle

import 'dart:math';

import 'package:z3/z3.dart';

import 'debug.dart';

enum Props {
  // Colors
  red,
  green,
  ivory,
  yellow,
  blue,

  // Nationalities
  englishman,
  japanese,
  ukrainian,
  norwegian,
  spaniard,

  // Drinks
  coffee,
  tea,
  milk,
  orangeJuice,
  water,

  // Smokes
  oldGold,
  kools,
  chesterfields,
  luckyStrike,
  parliaments,

  // Pets
  dog,
  snails,
  fox,
  horse,
  zebra,
}

void main() async {
  await initDebug();

  declareEnumValues(Props.values);
  final house = constVar('house', arraySort($s<Props>(), intSort));

  final s = solver();

  final x = constVar('x', $s<Props>());

  // There are 5 houses
  s.add(forall([x], house[x].betweenIn(1, 5)));

  // Each group of properties are distinct
  s.add(distinctN(Props.values.sublist(0, 5).map((e) => house[e])));
  s.add(distinctN(Props.values.sublist(5, 10).map((e) => house[e])));
  s.add(distinctN(Props.values.sublist(10, 15).map((e) => house[e])));
  s.add(distinctN(Props.values.sublist(15, 20).map((e) => house[e])));
  s.add(distinctN(Props.values.sublist(20, 25).map((e) => house[e])));

  // The Englishman lives in the red house.
  s.add(house[Props.englishman].eq(house[Props.red]));

  // The Spaniard owns the dog.
  s.add(house[Props.spaniard].eq(house[Props.dog]));

  // Coffee is drunk in the green house.
  s.add(house[Props.coffee].eq(house[Props.green]));

  // The Ukrainian drinks tea.
  s.add(house[Props.ukrainian].eq(house[Props.tea]));

  // The green house is immediately to the right of the ivory house.
  s.add(house[Props.green].eq(house[Props.ivory] + 1));

  // The Old Gold smoker owns snails.
  s.add(house[Props.oldGold].eq(house[Props.snails]));

  // Kools are smoked in the yellow house.
  s.add(house[Props.kools].eq(house[Props.yellow]));

  // Milk is drunk in the middle house.
  s.add(house[Props.milk].eq(3));

  // The Norwegian lives in the first house.
  s.add(house[Props.norwegian].eq(1));

  // The man who smokes Chesterfields lives in the house next to the man with
  // the fox.
  s.add(abs(house[Props.chesterfields] - house[Props.fox]).eq(1));

  // Kools are smoked in the house next to the house where the horse is kept.
  s.add(abs(house[Props.kools] - house[Props.horse]).eq(1));

  // The Lucky Strike smoker drinks orange juice.
  s.add(house[Props.luckyStrike].eq(house[Props.orangeJuice]));

  // The Japanese smokes Parliaments.
  s.add(house[Props.japanese].eq(house[Props.parliaments]));

  // The Norwegian lives next to the blue house.
  s.add(abs(house[Props.norwegian] - house[Props.blue]).eq(1));

  // Solve.
  final model = s.ensureSat();

  // Print solution.
  final houseProps = <int, List<Props>>{};
  for (final prop in Props.values) {
    final h = model[house[prop]].toInt();
    houseProps.putIfAbsent(h, () => []).add(prop);
  }

  final rows = <List<String>>[
    ['House', '1', '2', '3', '4', '5'],
  ];
  for (var i = 0; i < 5; i++) {
    rows.add([
      ['Color', 'Nationality', 'Drink', 'Smoke', 'Pet'][i],
      for (var j = 0; j < 5; j++)
        houseProps[j + 1]![i].toString().split('.')[1],
    ]);
  }

  String table(List<List<String>> rows) {
    final widths = <int>[];
    for (final row in rows) {
      for (var i = 0; i < row.length; i++) {
        if (widths.length <= i) {
          widths.add(0);
        }
        widths[i] = max(widths[i], row[i].length);
      }
    }
    final sb = StringBuffer();
    for (final row in rows) {
      for (var i = 0; i < row.length; i++) {
        sb.write(row[i].padRight(widths[i] + 2));
      }
      sb.writeln();
    }
    return sb.toString();
  }

  print(table(rows));
}
