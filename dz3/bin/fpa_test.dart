import 'package:z3/z3.dart';

void main() async {
  print(
    NullaryOpKind.values.length +
        UnaryOpKind.values.length +
        PUnaryOpKind.values.length +
        BinaryOpKind.values.length +
        TernaryOpKind.values.length +
        QuaternaryOpKind.values.length +
        NaryOpKind.values.length,
  );
}
