import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:z3/z3_ffi.dart';

final z3 = Z3Lib(DynamicLibrary.open(
    r'C:\Users\ping\IdeaProjects\z3\z3\cmake-build-debug\libz3.dll'));

void main() {
  final config = z3.mk_config();
  final context = z3.mk_context_rc(config);
  final intSort = z3.mk_int_sort(context);
  z3.inc_ref(context, intSort.cast());
  final rat = z3.mk_int(context, 69, intSort);
  z3.inc_ref(context, rat);
  final sqrt = z3.algebraic_root(context, rat, 2);
  print(
      'sqrt: ${z3.ast_to_string(context, sqrt).cast<Utf8>().toDartString()}}');
  z3.inc_ref(context, sqrt);
  final coeffs = z3.algebraic_get_poly(context, sqrt);
  z3.ast_vector_inc_ref(context, coeffs);
  final len = z3.ast_vector_size(context, coeffs);
  for (var i = 0; i < len; i++) {
    final coeff = z3.ast_vector_get(context, coeffs, i);
    z3.inc_ref(context, coeff);
    final str = z3.ast_to_string(context, coeff).cast<Utf8>().toDartString();
    print('$i: $str');
    z3.dec_ref(context, coeff);
  }
  z3.ast_vector_dec_ref(context, coeffs);
  z3.dec_ref(context, sqrt);
  z3.dec_ref(context, rat);
  z3.del_context(context);
  z3.del_config(config);
}
