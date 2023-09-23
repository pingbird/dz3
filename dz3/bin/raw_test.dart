import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:z3/z3_ffi.dart';

final z3 = Z3Lib(DynamicLibrary.open(
    r'C:\Users\ping\CLionProjects\z3\cmake-build-debug-visual-studio\libz3.dll'));

void main() {
  final config = z3.mk_config();
  final context = z3.mk_context(config);
  final funcName = z3.mk_string_symbol(context, 'wow'.toNativeUtf8().cast());
  final intSort = z3.mk_int_sort(context);
  final intSortPtr = malloc<Z3_sort>()..value = intSort;
  final func = z3.mk_func_decl(context, funcName, 1, intSortPtr, intSort);
  final kind = z3.get_decl_kind(context, func);
  print('kind: ${kind.toRadixString(16)}');
}
