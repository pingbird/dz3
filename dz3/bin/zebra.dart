// Solver for Einstein's Zebra puzzle: https://en.wikipedia.org/wiki/Zebra_Puzzle

import 'dart:math';

import 'package:z3/scoped.dart';
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
  s.add(forallConst(
    [x],
    and(
      ge(select(house, x), $(1)),
      le(select(house, x), $(5)),
    ),
  ));

  // Each group of properties are distinct
  for (var i = 0; i < 5; i++) {
    s.add(distinctN([
      for (final prop in Props.values.sublist(i * 5, (i + 1) * 5))
        select(house, $(prop)),
    ]));
  }

  // The Englishman lives in the red house.
  s.add(eq(
    select(house, $(Props.englishman)),
    select(house, $(Props.red)),
  ));

  // The Spaniard owns the dog.
  s.add(eq(
    select(house, $(Props.spaniard)),
    select(house, $(Props.dog)),
  ));

  // Coffee is drunk in the green house.
  s.add(eq(
    select(house, $(Props.coffee)),
    select(house, $(Props.green)),
  ));

  // The Ukrainian drinks tea.
  s.add(eq(
    select(house, $(Props.ukrainian)),
    select(house, $(Props.tea)),
  ));

  // The green house is immediately to the right of the ivory house.
  s.add(eq(
    select(house, $(Props.green)),
    add(select(house, $(Props.ivory)), $(1)),
  ));

  // The Old Gold smoker owns snails.
  s.add(eq(
    select(house, $(Props.oldGold)),
    select(house, $(Props.snails)),
  ));

  // Kools are smoked in the yellow house.
  s.add(eq(
    select(house, $(Props.kools)),
    select(house, $(Props.yellow)),
  ));

  // Milk is drunk in the middle house.
  s.add(eq(select(house, $(Props.milk)), $(3)));

  // The Norwegian lives in the first house.
  s.add(eq(select(house, $(Props.norwegian)), $(1)));

  // The man who smokes Chesterfields lives in the house next to the man with
  // the fox.
  s.add(eq(
    abs(sub(
      select(house, $(Props.chesterfields)),
      select(house, $(Props.fox)),
    )),
    $(1),
  ));

  // Kools are smoked in the house next to the house where the horse is kept.
  s.add(eq(
    abs(sub(
      select(house, $(Props.kools)),
      select(house, $(Props.horse)),
    )),
    $(1),
  ));

  // The Lucky Strike smoker drinks orange juice.
  s.add(eq(
    select(house, $(Props.luckyStrike)),
    select(house, $(Props.orangeJuice)),
  ));

  // The Japanese smokes Parliaments.
  s.add(eq(
    select(house, $(Props.japanese)),
    select(house, $(Props.parliaments)),
  ));

  // The Norwegian lives next to the blue house.
  s.add(eq(
    abs(sub(
      select(house, $(Props.norwegian)),
      select(house, $(Props.blue)),
    )),
    $(1),
  ));

  // Solve.
  s.ensureSat();

  // Print solution.
  final model = s.getModel();

  final houseProps = <int, List<Props>>{};
  for (final prop in Props.values) {
    final h = model.eval<Numeral>(select(house, $(prop))).toInt();
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
