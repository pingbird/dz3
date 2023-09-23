import 'package:z3/z3.dart';

void main() {
  final context = Context(Config());
  final isNegative = FloatNumeral(69420, Float64Sort()).isNegative;
  // print('isNegative: $isNegative');
}
