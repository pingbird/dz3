// GENERATED CODE - DO NOT MODIFY BY HAND

import 'dart:ffi';

// **************************************************************************
// ErrorHandlerLibraryGenerator
// **************************************************************************

import 'z3_ffi.dart';

// ignore_for_file: non_constant_identifier_names
class Z3LibWrapper {
  Z3LibWrapper(this.z3, this.context, this.checkError);
  final Z3Lib z3;
  final Z3_context context;
  final void Function() checkError;
  void del_context() {
    final result = z3.del_context(
      context,
    );
    checkError();
    return result;
  }

  void inc_ref(
    Z3_ast p1,
  ) {
    final result = z3.inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void dec_ref(
    Z3_ast p1,
  ) {
    final result = z3.dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void update_param_value(
    Pointer<Char> p1,
    Pointer<Char> p2,
  ) {
    final result = z3.update_param_value(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_param_descrs get_global_param_descrs() {
    final result = z3.get_global_param_descrs(
      context,
    );
    checkError();
    return result;
  }

  void interrupt() {
    final result = z3.interrupt(
      context,
    );
    checkError();
    return result;
  }

  void enable_concurrent_dec_ref() {
    final result = z3.enable_concurrent_dec_ref(
      context,
    );
    checkError();
    return result;
  }

  Z3_params mk_params() {
    final result = z3.mk_params(
      context,
    );
    checkError();
    return result;
  }

  void params_inc_ref(
    Z3_params p1,
  ) {
    final result = z3.params_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void params_dec_ref(
    Z3_params p1,
  ) {
    final result = z3.params_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void params_set_bool(
    Z3_params p1,
    Z3_symbol p2,
    bool p3,
  ) {
    final result = z3.params_set_bool(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void params_set_uint(
    Z3_params p1,
    Z3_symbol p2,
    int p3,
  ) {
    final result = z3.params_set_uint(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void params_set_double(
    Z3_params p1,
    Z3_symbol p2,
    double p3,
  ) {
    final result = z3.params_set_double(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void params_set_symbol(
    Z3_params p1,
    Z3_symbol p2,
    Z3_symbol p3,
  ) {
    final result = z3.params_set_symbol(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Pointer<Char> params_to_string(
    Z3_params p1,
  ) {
    final result = z3.params_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void params_validate(
    Z3_params p1,
    Z3_param_descrs p2,
  ) {
    final result = z3.params_validate(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void param_descrs_inc_ref(
    Z3_param_descrs p1,
  ) {
    final result = z3.param_descrs_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void param_descrs_dec_ref(
    Z3_param_descrs p1,
  ) {
    final result = z3.param_descrs_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int param_descrs_get_kind(
    Z3_param_descrs p1,
    Z3_symbol p2,
  ) {
    final result = z3.param_descrs_get_kind(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int param_descrs_size(
    Z3_param_descrs p1,
  ) {
    final result = z3.param_descrs_size(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_symbol param_descrs_get_name(
    Z3_param_descrs p1,
    int p2,
  ) {
    final result = z3.param_descrs_get_name(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> param_descrs_get_documentation(
    Z3_param_descrs p1,
    Z3_symbol p2,
  ) {
    final result = z3.param_descrs_get_documentation(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> param_descrs_to_string(
    Z3_param_descrs p1,
  ) {
    final result = z3.param_descrs_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_symbol mk_int_symbol(
    int p1,
  ) {
    final result = z3.mk_int_symbol(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_symbol mk_string_symbol(
    Pointer<Char> p1,
  ) {
    final result = z3.mk_string_symbol(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort mk_uninterpreted_sort(
    Z3_symbol p1,
  ) {
    final result = z3.mk_uninterpreted_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort mk_type_variable(
    Z3_symbol p1,
  ) {
    final result = z3.mk_type_variable(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort mk_bool_sort() {
    final result = z3.mk_bool_sort(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_int_sort() {
    final result = z3.mk_int_sort(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_real_sort() {
    final result = z3.mk_real_sort(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_bv_sort(
    int p1,
  ) {
    final result = z3.mk_bv_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort mk_finite_domain_sort(
    Z3_symbol p1,
    int p2,
  ) {
    final result = z3.mk_finite_domain_sort(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort mk_array_sort(
    Z3_sort p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_array_sort(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort mk_array_sort_n(
    int p1,
    Pointer<Z3_sort> p2,
    Z3_sort p3,
  ) {
    final result = z3.mk_array_sort_n(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_sort mk_tuple_sort(
    Z3_symbol p1,
    int p2,
    Pointer<Z3_symbol> p3,
    Pointer<Z3_sort> p4,
    Pointer<Z3_func_decl> p5,
    Pointer<Z3_func_decl> p6,
  ) {
    final result = z3.mk_tuple_sort(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
    );
    checkError();
    return result;
  }

  Z3_sort mk_enumeration_sort(
    Z3_symbol p1,
    int p2,
    Pointer<Z3_symbol> p3,
    Pointer<Z3_func_decl> p4,
    Pointer<Z3_func_decl> p5,
  ) {
    final result = z3.mk_enumeration_sort(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
    );
    checkError();
    return result;
  }

  Z3_sort mk_list_sort(
    Z3_symbol p1,
    Z3_sort p2,
    Pointer<Z3_func_decl> p3,
    Pointer<Z3_func_decl> p4,
    Pointer<Z3_func_decl> p5,
    Pointer<Z3_func_decl> p6,
    Pointer<Z3_func_decl> p7,
    Pointer<Z3_func_decl> p8,
  ) {
    final result = z3.mk_list_sort(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
    );
    checkError();
    return result;
  }

  Z3_constructor mk_constructor(
    Z3_symbol p1,
    Z3_symbol p2,
    int p3,
    Pointer<Z3_symbol> p4,
    Pointer<Z3_sort> p5,
    Pointer<UnsignedInt> p6,
  ) {
    final result = z3.mk_constructor(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
    );
    checkError();
    return result;
  }

  void del_constructor(
    Z3_constructor p1,
  ) {
    final result = z3.del_constructor(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort mk_datatype(
    Z3_symbol p1,
    int p2,
    Pointer<Z3_constructor> p3,
  ) {
    final result = z3.mk_datatype(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_sort mk_datatype_sort(
    Z3_symbol p1,
  ) {
    final result = z3.mk_datatype_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_constructor_list mk_constructor_list(
    int p1,
    Pointer<Z3_constructor> p2,
  ) {
    final result = z3.mk_constructor_list(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void del_constructor_list(
    Z3_constructor_list p1,
  ) {
    final result = z3.del_constructor_list(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void mk_datatypes(
    int p1,
    Pointer<Z3_symbol> p2,
    Pointer<Z3_sort> p3,
    Pointer<Z3_constructor_list> p4,
  ) {
    final result = z3.mk_datatypes(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  void query_constructor(
    Z3_constructor p1,
    int p2,
    Pointer<Z3_func_decl> p3,
    Pointer<Z3_func_decl> p4,
    Pointer<Z3_func_decl> p5,
  ) {
    final result = z3.query_constructor(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_func_decl(
    Z3_symbol p1,
    int p2,
    Pointer<Z3_sort> p3,
    Z3_sort p4,
  ) {
    final result = z3.mk_func_decl(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_app(
    Z3_func_decl p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.mk_app(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_const(
    Z3_symbol p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_const(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_fresh_func_decl(
    Pointer<Char> p1,
    int p2,
    Pointer<Z3_sort> p3,
    Z3_sort p4,
  ) {
    final result = z3.mk_fresh_func_decl(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fresh_const(
    Pointer<Char> p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_fresh_const(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_rec_func_decl(
    Z3_symbol p1,
    int p2,
    Pointer<Z3_sort> p3,
    Z3_sort p4,
  ) {
    final result = z3.mk_rec_func_decl(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  void add_rec_def(
    Z3_func_decl p1,
    int p2,
    Pointer<Z3_ast> p3,
    Z3_ast p4,
  ) {
    final result = z3.add_rec_def(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_true() {
    final result = z3.mk_true(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_false() {
    final result = z3.mk_false(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_eq(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_eq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_distinct(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_distinct(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_not(
    Z3_ast p1,
  ) {
    final result = z3.mk_not(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_ite(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_ite(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_iff(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_iff(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_implies(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_implies(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_xor(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_xor(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_and(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_and(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_or(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_or(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_add(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_add(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_mul(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_mul(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_sub(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_sub(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_unary_minus(
    Z3_ast p1,
  ) {
    final result = z3.mk_unary_minus(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_div(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_div(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_mod(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_mod(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_rem(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_rem(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_power(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_power(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_lt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_lt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_le(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_le(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_gt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_gt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_ge(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_ge(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_divides(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_divides(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_int2real(
    Z3_ast p1,
  ) {
    final result = z3.mk_int2real(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_real2int(
    Z3_ast p1,
  ) {
    final result = z3.mk_real2int(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_is_int(
    Z3_ast p1,
  ) {
    final result = z3.mk_is_int(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvnot(
    Z3_ast p1,
  ) {
    final result = z3.mk_bvnot(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvredand(
    Z3_ast p1,
  ) {
    final result = z3.mk_bvredand(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvredor(
    Z3_ast p1,
  ) {
    final result = z3.mk_bvredor(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvand(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvand(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvor(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvor(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvxor(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvxor(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvnand(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvnand(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvnor(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvnor(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvxnor(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvxnor(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvneg(
    Z3_ast p1,
  ) {
    final result = z3.mk_bvneg(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvadd(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvadd(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsub(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsub(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvmul(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvmul(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvudiv(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvudiv(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsdiv(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsdiv(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvurem(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvurem(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsrem(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsrem(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsmod(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsmod(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvult(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvult(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvslt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvslt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvule(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvule(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsle(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsle(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvuge(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvuge(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsge(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsge(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvugt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvugt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsgt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsgt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_concat(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_concat(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_extract(
    int p1,
    int p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_extract(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_sign_ext(
    int p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_sign_ext(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_zero_ext(
    int p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_zero_ext(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_repeat(
    int p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_repeat(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bit2bool(
    int p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bit2bool(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvshl(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvshl(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvlshr(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvlshr(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvashr(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvashr(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_rotate_left(
    int p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_rotate_left(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_rotate_right(
    int p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_rotate_right(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_ext_rotate_left(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_ext_rotate_left(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_ext_rotate_right(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_ext_rotate_right(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_int2bv(
    int p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_int2bv(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bv2int(
    Z3_ast p1,
    bool p2,
  ) {
    final result = z3.mk_bv2int(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvadd_no_overflow(
    Z3_ast p1,
    Z3_ast p2,
    bool p3,
  ) {
    final result = z3.mk_bvadd_no_overflow(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvadd_no_underflow(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvadd_no_underflow(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsub_no_overflow(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsub_no_overflow(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsub_no_underflow(
    Z3_ast p1,
    Z3_ast p2,
    bool p3,
  ) {
    final result = z3.mk_bvsub_no_underflow(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvsdiv_no_overflow(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvsdiv_no_overflow(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvneg_no_overflow(
    Z3_ast p1,
  ) {
    final result = z3.mk_bvneg_no_overflow(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvmul_no_overflow(
    Z3_ast p1,
    Z3_ast p2,
    bool p3,
  ) {
    final result = z3.mk_bvmul_no_overflow(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bvmul_no_underflow(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_bvmul_no_underflow(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_select(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_select(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_select_n(
    Z3_ast p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.mk_select_n(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_store(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_store(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_store_n(
    Z3_ast p1,
    int p2,
    Pointer<Z3_ast> p3,
    Z3_ast p4,
  ) {
    final result = z3.mk_store_n(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_const_array(
    Z3_sort p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_const_array(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_map(
    Z3_func_decl p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.mk_map(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_array_default(
    Z3_ast p1,
  ) {
    final result = z3.mk_array_default(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_as_array(
    Z3_func_decl p1,
  ) {
    final result = z3.mk_as_array(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_has_size(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_set_has_size(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort mk_set_sort(
    Z3_sort p1,
  ) {
    final result = z3.mk_set_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_empty_set(
    Z3_sort p1,
  ) {
    final result = z3.mk_empty_set(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_full_set(
    Z3_sort p1,
  ) {
    final result = z3.mk_full_set(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_add(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_set_add(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_del(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_set_del(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_union(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_set_union(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_intersect(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_set_intersect(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_difference(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_set_difference(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_complement(
    Z3_ast p1,
  ) {
    final result = z3.mk_set_complement(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_member(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_set_member(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_set_subset(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_set_subset(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_array_ext(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_array_ext(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_numeral(
    Pointer<Char> p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_numeral(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_real(
    int p1,
    int p2,
  ) {
    final result = z3.mk_real(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_real_int64(
    int p1,
    int p2,
  ) {
    final result = z3.mk_real_int64(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_int(
    int p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_int(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_unsigned_int(
    int p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_unsigned_int(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_int64(
    int p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_int64(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_unsigned_int64(
    int p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_unsigned_int64(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bv_numeral(
    int p1,
    Pointer<Bool> p2,
  ) {
    final result = z3.mk_bv_numeral(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort mk_seq_sort(
    Z3_sort p1,
  ) {
    final result = z3.mk_seq_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_seq_sort(
    Z3_sort p1,
  ) {
    final result = z3.is_seq_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort get_seq_sort_basis(
    Z3_sort p1,
  ) {
    final result = z3.get_seq_sort_basis(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort mk_re_sort(
    Z3_sort p1,
  ) {
    final result = z3.mk_re_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_re_sort(
    Z3_sort p1,
  ) {
    final result = z3.is_re_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort get_re_sort_basis(
    Z3_sort p1,
  ) {
    final result = z3.get_re_sort_basis(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort mk_string_sort() {
    final result = z3.mk_string_sort(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_char_sort() {
    final result = z3.mk_char_sort(
      context,
    );
    checkError();
    return result;
  }

  bool is_string_sort(
    Z3_sort p1,
  ) {
    final result = z3.is_string_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_char_sort(
    Z3_sort p1,
  ) {
    final result = z3.is_char_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_string(
    Pointer<Char> p1,
  ) {
    final result = z3.mk_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_lstring(
    int p1,
    Pointer<Char> p2,
  ) {
    final result = z3.mk_lstring(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_u32string(
    int p1,
    Pointer<UnsignedInt> p2,
  ) {
    final result = z3.mk_u32string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool is_string(
    Z3_ast p1,
  ) {
    final result = z3.is_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_string(
    Z3_ast p1,
  ) {
    final result = z3.get_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_lstring(
    Z3_ast p1,
    Pointer<UnsignedInt> p2,
  ) {
    final result = z3.get_lstring(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_string_length(
    Z3_ast p1,
  ) {
    final result = z3.get_string_length(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void get_string_contents(
    Z3_ast p1,
    int p2,
    Pointer<UnsignedInt> p3,
  ) {
    final result = z3.get_string_contents(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_empty(
    Z3_sort p1,
  ) {
    final result = z3.mk_seq_empty(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_unit(
    Z3_ast p1,
  ) {
    final result = z3.mk_seq_unit(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_concat(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_seq_concat(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_prefix(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_seq_prefix(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_suffix(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_seq_suffix(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_contains(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_seq_contains(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_str_lt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_str_lt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_str_le(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_str_le(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_extract(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_seq_extract(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_replace(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_seq_replace(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_at(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_seq_at(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_nth(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_seq_nth(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_length(
    Z3_ast p1,
  ) {
    final result = z3.mk_seq_length(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_index(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_seq_index(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_last_index(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_seq_last_index(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_str_to_int(
    Z3_ast p1,
  ) {
    final result = z3.mk_str_to_int(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_int_to_str(
    Z3_ast p1,
  ) {
    final result = z3.mk_int_to_str(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_string_to_code(
    Z3_ast p1,
  ) {
    final result = z3.mk_string_to_code(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_string_from_code(
    Z3_ast p1,
  ) {
    final result = z3.mk_string_from_code(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_ubv_to_str(
    Z3_ast p1,
  ) {
    final result = z3.mk_ubv_to_str(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_sbv_to_str(
    Z3_ast p1,
  ) {
    final result = z3.mk_sbv_to_str(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_to_re(
    Z3_ast p1,
  ) {
    final result = z3.mk_seq_to_re(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_seq_in_re(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_seq_in_re(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_plus(
    Z3_ast p1,
  ) {
    final result = z3.mk_re_plus(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_star(
    Z3_ast p1,
  ) {
    final result = z3.mk_re_star(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_option(
    Z3_ast p1,
  ) {
    final result = z3.mk_re_option(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_union(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_re_union(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_concat(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_re_concat(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_range(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_re_range(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_allchar(
    Z3_sort p1,
  ) {
    final result = z3.mk_re_allchar(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_loop(
    Z3_ast p1,
    int p2,
    int p3,
  ) {
    final result = z3.mk_re_loop(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_power(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.mk_re_power(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_intersect(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_re_intersect(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_complement(
    Z3_ast p1,
  ) {
    final result = z3.mk_re_complement(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_diff(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_re_diff(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_empty(
    Z3_sort p1,
  ) {
    final result = z3.mk_re_empty(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_re_full(
    Z3_sort p1,
  ) {
    final result = z3.mk_re_full(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_char(
    int p1,
  ) {
    final result = z3.mk_char(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_char_le(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_char_le(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_char_to_int(
    Z3_ast p1,
  ) {
    final result = z3.mk_char_to_int(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_char_to_bv(
    Z3_ast p1,
  ) {
    final result = z3.mk_char_to_bv(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_char_from_bv(
    Z3_ast p1,
  ) {
    final result = z3.mk_char_from_bv(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_char_is_digit(
    Z3_ast p1,
  ) {
    final result = z3.mk_char_is_digit(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_linear_order(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.mk_linear_order(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_partial_order(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.mk_partial_order(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_piecewise_linear_order(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.mk_piecewise_linear_order(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_tree_order(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.mk_tree_order(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl mk_transitive_closure(
    Z3_func_decl p1,
  ) {
    final result = z3.mk_transitive_closure(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_pattern mk_pattern(
    int p1,
    Pointer<Z3_ast> p2,
  ) {
    final result = z3.mk_pattern(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_bound(
    int p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_bound(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_forall(
    int p1,
    int p2,
    Pointer<Z3_pattern> p3,
    int p4,
    Pointer<Z3_sort> p5,
    Pointer<Z3_symbol> p6,
    Z3_ast p7,
  ) {
    final result = z3.mk_forall(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
    checkError();
    return result;
  }

  Z3_ast mk_exists(
    int p1,
    int p2,
    Pointer<Z3_pattern> p3,
    int p4,
    Pointer<Z3_sort> p5,
    Pointer<Z3_symbol> p6,
    Z3_ast p7,
  ) {
    final result = z3.mk_exists(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
    checkError();
    return result;
  }

  Z3_ast mk_quantifier(
    bool p1,
    int p2,
    int p3,
    Pointer<Z3_pattern> p4,
    int p5,
    Pointer<Z3_sort> p6,
    Pointer<Z3_symbol> p7,
    Z3_ast p8,
  ) {
    final result = z3.mk_quantifier(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
    );
    checkError();
    return result;
  }

  Z3_ast mk_quantifier_ex(
    bool p1,
    int p2,
    Z3_symbol p3,
    Z3_symbol p4,
    int p5,
    Pointer<Z3_pattern> p6,
    int p7,
    Pointer<Z3_ast> p8,
    int p9,
    Pointer<Z3_sort> p10,
    Pointer<Z3_symbol> p11,
    Z3_ast p12,
  ) {
    final result = z3.mk_quantifier_ex(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
      p10,
      p11,
      p12,
    );
    checkError();
    return result;
  }

  Z3_ast mk_forall_const(
    int p1,
    int p2,
    Pointer<Z3_app> p3,
    int p4,
    Pointer<Z3_pattern> p5,
    Z3_ast p6,
  ) {
    final result = z3.mk_forall_const(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
    );
    checkError();
    return result;
  }

  Z3_ast mk_exists_const(
    int p1,
    int p2,
    Pointer<Z3_app> p3,
    int p4,
    Pointer<Z3_pattern> p5,
    Z3_ast p6,
  ) {
    final result = z3.mk_exists_const(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
    );
    checkError();
    return result;
  }

  Z3_ast mk_quantifier_const(
    bool p1,
    int p2,
    int p3,
    Pointer<Z3_app> p4,
    int p5,
    Pointer<Z3_pattern> p6,
    Z3_ast p7,
  ) {
    final result = z3.mk_quantifier_const(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
    checkError();
    return result;
  }

  Z3_ast mk_quantifier_const_ex(
    bool p1,
    int p2,
    Z3_symbol p3,
    Z3_symbol p4,
    int p5,
    Pointer<Z3_app> p6,
    int p7,
    Pointer<Z3_pattern> p8,
    int p9,
    Pointer<Z3_ast> p10,
    Z3_ast p11,
  ) {
    final result = z3.mk_quantifier_const_ex(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
      p10,
      p11,
    );
    checkError();
    return result;
  }

  Z3_ast mk_lambda(
    int p1,
    Pointer<Z3_sort> p2,
    Pointer<Z3_symbol> p3,
    Z3_ast p4,
  ) {
    final result = z3.mk_lambda(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_lambda_const(
    int p1,
    Pointer<Z3_app> p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_lambda_const(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  int get_symbol_kind(
    Z3_symbol p1,
  ) {
    final result = z3.get_symbol_kind(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_symbol_int(
    Z3_symbol p1,
  ) {
    final result = z3.get_symbol_int(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_symbol_string(
    Z3_symbol p1,
  ) {
    final result = z3.get_symbol_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_symbol get_sort_name(
    Z3_sort p1,
  ) {
    final result = z3.get_sort_name(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_sort_id(
    Z3_sort p1,
  ) {
    final result = z3.get_sort_id(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast sort_to_ast(
    Z3_sort p1,
  ) {
    final result = z3.sort_to_ast(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_eq_sort(
    Z3_sort p1,
    Z3_sort p2,
  ) {
    final result = z3.is_eq_sort(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_sort_kind(
    Z3_sort p1,
  ) {
    final result = z3.get_sort_kind(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_bv_sort_size(
    Z3_sort p1,
  ) {
    final result = z3.get_bv_sort_size(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool get_finite_domain_sort_size(
    Z3_sort p1,
    Pointer<Uint64> p2,
  ) {
    final result = z3.get_finite_domain_sort_size(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort get_array_sort_domain(
    Z3_sort p1,
  ) {
    final result = z3.get_array_sort_domain(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort get_array_sort_domain_n(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.get_array_sort_domain_n(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort get_array_sort_range(
    Z3_sort p1,
  ) {
    final result = z3.get_array_sort_range(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_tuple_sort_mk_decl(
    Z3_sort p1,
  ) {
    final result = z3.get_tuple_sort_mk_decl(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_tuple_sort_num_fields(
    Z3_sort p1,
  ) {
    final result = z3.get_tuple_sort_num_fields(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_tuple_sort_field_decl(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.get_tuple_sort_field_decl(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_datatype_sort_num_constructors(
    Z3_sort p1,
  ) {
    final result = z3.get_datatype_sort_num_constructors(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_datatype_sort_constructor(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.get_datatype_sort_constructor(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_datatype_sort_recognizer(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.get_datatype_sort_recognizer(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_datatype_sort_constructor_accessor(
    Z3_sort p1,
    int p2,
    int p3,
  ) {
    final result = z3.get_datatype_sort_constructor_accessor(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast datatype_update_field(
    Z3_func_decl p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.datatype_update_field(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  int get_relation_arity(
    Z3_sort p1,
  ) {
    final result = z3.get_relation_arity(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort get_relation_column(
    Z3_sort p1,
    int p2,
  ) {
    final result = z3.get_relation_column(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_atmost(
    int p1,
    Pointer<Z3_ast> p2,
    int p3,
  ) {
    final result = z3.mk_atmost(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_atleast(
    int p1,
    Pointer<Z3_ast> p2,
    int p3,
  ) {
    final result = z3.mk_atleast(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_pble(
    int p1,
    Pointer<Z3_ast> p2,
    Pointer<Int> p3,
    int p4,
  ) {
    final result = z3.mk_pble(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_pbge(
    int p1,
    Pointer<Z3_ast> p2,
    Pointer<Int> p3,
    int p4,
  ) {
    final result = z3.mk_pbge(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_pbeq(
    int p1,
    Pointer<Z3_ast> p2,
    Pointer<Int> p3,
    int p4,
  ) {
    final result = z3.mk_pbeq(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast func_decl_to_ast(
    Z3_func_decl p1,
  ) {
    final result = z3.func_decl_to_ast(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_eq_func_decl(
    Z3_func_decl p1,
    Z3_func_decl p2,
  ) {
    final result = z3.is_eq_func_decl(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_func_decl_id(
    Z3_func_decl p1,
  ) {
    final result = z3.get_func_decl_id(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_symbol get_decl_name(
    Z3_func_decl p1,
  ) {
    final result = z3.get_decl_name(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_decl_kind(
    Z3_func_decl p1,
  ) {
    final result = z3.get_decl_kind(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_domain_size(
    Z3_func_decl p1,
  ) {
    final result = z3.get_domain_size(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_arity(
    Z3_func_decl p1,
  ) {
    final result = z3.get_arity(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort get_domain(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_domain(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort get_range(
    Z3_func_decl p1,
  ) {
    final result = z3.get_range(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_decl_num_parameters(
    Z3_func_decl p1,
  ) {
    final result = z3.get_decl_num_parameters(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_decl_parameter_kind(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_parameter_kind(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_decl_int_parameter(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_int_parameter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  double get_decl_double_parameter(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_double_parameter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_symbol get_decl_symbol_parameter(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_symbol_parameter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort get_decl_sort_parameter(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_sort_parameter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast get_decl_ast_parameter(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_ast_parameter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_decl_func_decl_parameter(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_func_decl_parameter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_decl_rational_parameter(
    Z3_func_decl p1,
    int p2,
  ) {
    final result = z3.get_decl_rational_parameter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast app_to_ast(
    Z3_app p1,
  ) {
    final result = z3.app_to_ast(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_app_decl(
    Z3_app p1,
  ) {
    final result = z3.get_app_decl(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_app_num_args(
    Z3_app p1,
  ) {
    final result = z3.get_app_num_args(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast get_app_arg(
    Z3_app p1,
    int p2,
  ) {
    final result = z3.get_app_arg(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool is_eq_ast(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.is_eq_ast(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_ast_id(
    Z3_ast p1,
  ) {
    final result = z3.get_ast_id(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_ast_hash(
    Z3_ast p1,
  ) {
    final result = z3.get_ast_hash(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort get_sort(
    Z3_ast p1,
  ) {
    final result = z3.get_sort(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_well_sorted(
    Z3_ast p1,
  ) {
    final result = z3.is_well_sorted(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_bool_value(
    Z3_ast p1,
  ) {
    final result = z3.get_bool_value(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_ast_kind(
    Z3_ast p1,
  ) {
    final result = z3.get_ast_kind(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_app(
    Z3_ast p1,
  ) {
    final result = z3.is_app(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_numeral_ast(
    Z3_ast p1,
  ) {
    final result = z3.is_numeral_ast(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_algebraic_number(
    Z3_ast p1,
  ) {
    final result = z3.is_algebraic_number(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_app to_app(
    Z3_ast p1,
  ) {
    final result = z3.to_app(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl to_func_decl(
    Z3_ast p1,
  ) {
    final result = z3.to_func_decl(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_numeral_string(
    Z3_ast p1,
  ) {
    final result = z3.get_numeral_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_numeral_binary_string(
    Z3_ast p1,
  ) {
    final result = z3.get_numeral_binary_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_numeral_decimal_string(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.get_numeral_decimal_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  double get_numeral_double(
    Z3_ast p1,
  ) {
    final result = z3.get_numeral_double(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast get_numerator(
    Z3_ast p1,
  ) {
    final result = z3.get_numerator(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast get_denominator(
    Z3_ast p1,
  ) {
    final result = z3.get_denominator(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool get_numeral_small(
    Z3_ast p1,
    Pointer<Int64> p2,
    Pointer<Int64> p3,
  ) {
    final result = z3.get_numeral_small(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  bool get_numeral_int(
    Z3_ast p1,
    Pointer<Int> p2,
  ) {
    final result = z3.get_numeral_int(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool get_numeral_uint(
    Z3_ast p1,
    Pointer<UnsignedInt> p2,
  ) {
    final result = z3.get_numeral_uint(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool get_numeral_uint64(
    Z3_ast p1,
    Pointer<Uint64> p2,
  ) {
    final result = z3.get_numeral_uint64(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool get_numeral_int64(
    Z3_ast p1,
    Pointer<Int64> p2,
  ) {
    final result = z3.get_numeral_int64(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool get_numeral_rational_int64(
    Z3_ast p1,
    Pointer<Int64> p2,
    Pointer<Int64> p3,
  ) {
    final result = z3.get_numeral_rational_int64(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast get_algebraic_number_lower(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.get_algebraic_number_lower(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast get_algebraic_number_upper(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.get_algebraic_number_upper(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast pattern_to_ast(
    Z3_pattern p1,
  ) {
    final result = z3.pattern_to_ast(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_pattern_num_terms(
    Z3_pattern p1,
  ) {
    final result = z3.get_pattern_num_terms(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast get_pattern(
    Z3_pattern p1,
    int p2,
  ) {
    final result = z3.get_pattern(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_index_value(
    Z3_ast p1,
  ) {
    final result = z3.get_index_value(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_quantifier_forall(
    Z3_ast p1,
  ) {
    final result = z3.is_quantifier_forall(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_quantifier_exists(
    Z3_ast p1,
  ) {
    final result = z3.is_quantifier_exists(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool is_lambda(
    Z3_ast p1,
  ) {
    final result = z3.is_lambda(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_quantifier_weight(
    Z3_ast p1,
  ) {
    final result = z3.get_quantifier_weight(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_quantifier_num_patterns(
    Z3_ast p1,
  ) {
    final result = z3.get_quantifier_num_patterns(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_pattern get_quantifier_pattern_ast(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.get_quantifier_pattern_ast(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_quantifier_num_no_patterns(
    Z3_ast p1,
  ) {
    final result = z3.get_quantifier_num_no_patterns(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast get_quantifier_no_pattern_ast(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.get_quantifier_no_pattern_ast(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_quantifier_num_bound(
    Z3_ast p1,
  ) {
    final result = z3.get_quantifier_num_bound(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_symbol get_quantifier_bound_name(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.get_quantifier_bound_name(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort get_quantifier_bound_sort(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.get_quantifier_bound_sort(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast get_quantifier_body(
    Z3_ast p1,
  ) {
    final result = z3.get_quantifier_body(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast simplify(
    Z3_ast p1,
  ) {
    final result = z3.simplify(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast simplify_ex(
    Z3_ast p1,
    Z3_params p2,
  ) {
    final result = z3.simplify_ex(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> simplify_get_help() {
    final result = z3.simplify_get_help(
      context,
    );
    checkError();
    return result;
  }

  Z3_param_descrs simplify_get_param_descrs() {
    final result = z3.simplify_get_param_descrs(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast update_term(
    Z3_ast p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.update_term(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast substitute(
    Z3_ast p1,
    int p2,
    Pointer<Z3_ast> p3,
    Pointer<Z3_ast> p4,
  ) {
    final result = z3.substitute(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast substitute_vars(
    Z3_ast p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.substitute_vars(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast substitute_funs(
    Z3_ast p1,
    int p2,
    Pointer<Z3_func_decl> p3,
    Pointer<Z3_ast> p4,
  ) {
    final result = z3.substitute_funs(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast translate(
    Z3_ast p1,
    Z3_context p2,
  ) {
    final result = z3.translate(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_model mk_model() {
    final result = z3.mk_model(
      context,
    );
    checkError();
    return result;
  }

  void model_inc_ref(
    Z3_model p1,
  ) {
    final result = z3.model_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void model_dec_ref(
    Z3_model p1,
  ) {
    final result = z3.model_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool model_eval(
    Z3_model p1,
    Z3_ast p2,
    bool p3,
    Pointer<Z3_ast> p4,
  ) {
    final result = z3.model_eval(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast model_get_const_interp(
    Z3_model p1,
    Z3_func_decl p2,
  ) {
    final result = z3.model_get_const_interp(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool model_has_interp(
    Z3_model p1,
    Z3_func_decl p2,
  ) {
    final result = z3.model_has_interp(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_func_interp model_get_func_interp(
    Z3_model p1,
    Z3_func_decl p2,
  ) {
    final result = z3.model_get_func_interp(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int model_get_num_consts(
    Z3_model p1,
  ) {
    final result = z3.model_get_num_consts(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl model_get_const_decl(
    Z3_model p1,
    int p2,
  ) {
    final result = z3.model_get_const_decl(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int model_get_num_funcs(
    Z3_model p1,
  ) {
    final result = z3.model_get_num_funcs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl model_get_func_decl(
    Z3_model p1,
    int p2,
  ) {
    final result = z3.model_get_func_decl(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int model_get_num_sorts(
    Z3_model p1,
  ) {
    final result = z3.model_get_num_sorts(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_sort model_get_sort(
    Z3_model p1,
    int p2,
  ) {
    final result = z3.model_get_sort(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector model_get_sort_universe(
    Z3_model p1,
    Z3_sort p2,
  ) {
    final result = z3.model_get_sort_universe(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_model model_translate(
    Z3_model p1,
    Z3_context p2,
  ) {
    final result = z3.model_translate(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool is_as_array(
    Z3_ast p1,
  ) {
    final result = z3.is_as_array(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_decl get_as_array_func_decl(
    Z3_ast p1,
  ) {
    final result = z3.get_as_array_func_decl(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_interp add_func_interp(
    Z3_model p1,
    Z3_func_decl p2,
    Z3_ast p3,
  ) {
    final result = z3.add_func_interp(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void add_const_interp(
    Z3_model p1,
    Z3_func_decl p2,
    Z3_ast p3,
  ) {
    final result = z3.add_const_interp(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void func_interp_inc_ref(
    Z3_func_interp p1,
  ) {
    final result = z3.func_interp_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void func_interp_dec_ref(
    Z3_func_interp p1,
  ) {
    final result = z3.func_interp_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int func_interp_get_num_entries(
    Z3_func_interp p1,
  ) {
    final result = z3.func_interp_get_num_entries(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_func_entry func_interp_get_entry(
    Z3_func_interp p1,
    int p2,
  ) {
    final result = z3.func_interp_get_entry(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast func_interp_get_else(
    Z3_func_interp p1,
  ) {
    final result = z3.func_interp_get_else(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void func_interp_set_else(
    Z3_func_interp p1,
    Z3_ast p2,
  ) {
    final result = z3.func_interp_set_else(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int func_interp_get_arity(
    Z3_func_interp p1,
  ) {
    final result = z3.func_interp_get_arity(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void func_interp_add_entry(
    Z3_func_interp p1,
    Z3_ast_vector p2,
    Z3_ast p3,
  ) {
    final result = z3.func_interp_add_entry(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void func_entry_inc_ref(
    Z3_func_entry p1,
  ) {
    final result = z3.func_entry_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void func_entry_dec_ref(
    Z3_func_entry p1,
  ) {
    final result = z3.func_entry_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast func_entry_get_value(
    Z3_func_entry p1,
  ) {
    final result = z3.func_entry_get_value(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int func_entry_get_num_args(
    Z3_func_entry p1,
  ) {
    final result = z3.func_entry_get_num_args(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast func_entry_get_arg(
    Z3_func_entry p1,
    int p2,
  ) {
    final result = z3.func_entry_get_arg(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void set_ast_print_mode(
    int p1,
  ) {
    final result = z3.set_ast_print_mode(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> ast_to_string(
    Z3_ast p1,
  ) {
    final result = z3.ast_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> pattern_to_string(
    Z3_pattern p1,
  ) {
    final result = z3.pattern_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> sort_to_string(
    Z3_sort p1,
  ) {
    final result = z3.sort_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> func_decl_to_string(
    Z3_func_decl p1,
  ) {
    final result = z3.func_decl_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> model_to_string(
    Z3_model p1,
  ) {
    final result = z3.model_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> benchmark_to_smtlib_string(
    Pointer<Char> p1,
    Pointer<Char> p2,
    Pointer<Char> p3,
    Pointer<Char> p4,
    int p5,
    Pointer<Z3_ast> p6,
    Z3_ast p7,
  ) {
    final result = z3.benchmark_to_smtlib_string(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
    checkError();
    return result;
  }

  Z3_ast_vector parse_smtlib2_string(
    Pointer<Char> p1,
    int p2,
    Pointer<Z3_symbol> p3,
    Pointer<Z3_sort> p4,
    int p5,
    Pointer<Z3_symbol> p6,
    Pointer<Z3_func_decl> p7,
  ) {
    final result = z3.parse_smtlib2_string(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
    checkError();
    return result;
  }

  Z3_ast_vector parse_smtlib2_file(
    Pointer<Char> p1,
    int p2,
    Pointer<Z3_symbol> p3,
    Pointer<Z3_sort> p4,
    int p5,
    Pointer<Z3_symbol> p6,
    Pointer<Z3_func_decl> p7,
  ) {
    final result = z3.parse_smtlib2_file(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
    checkError();
    return result;
  }

  Pointer<Char> eval_smtlib2_string(
    Pointer<Char> p1,
  ) {
    final result = z3.eval_smtlib2_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_parser_context mk_parser_context() {
    final result = z3.mk_parser_context(
      context,
    );
    checkError();
    return result;
  }

  void parser_context_inc_ref(
    Z3_parser_context p1,
  ) {
    final result = z3.parser_context_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void parser_context_dec_ref(
    Z3_parser_context p1,
  ) {
    final result = z3.parser_context_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void parser_context_add_sort(
    Z3_parser_context p1,
    Z3_sort p2,
  ) {
    final result = z3.parser_context_add_sort(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void parser_context_add_decl(
    Z3_parser_context p1,
    Z3_func_decl p2,
  ) {
    final result = z3.parser_context_add_decl(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector parser_context_from_string(
    Z3_parser_context p1,
    Pointer<Char> p2,
  ) {
    final result = z3.parser_context_from_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_error_code() {
    final result = z3.get_error_code(
      context,
    );
    checkError();
    return result;
  }

  void set_error_handler(
    Pointer<NativeFunction<Void Function(Z3_context, Int32)>> p1,
  ) {
    final result = z3.set_error_handler(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void set_error(
    int p1,
  ) {
    final result = z3.set_error(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_error_msg(
    int p1,
  ) {
    final result = z3.get_error_msg(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_goal mk_goal(
    bool p1,
    bool p2,
    bool p3,
  ) {
    final result = z3.mk_goal(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void goal_inc_ref(
    Z3_goal p1,
  ) {
    final result = z3.goal_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void goal_dec_ref(
    Z3_goal p1,
  ) {
    final result = z3.goal_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int goal_precision(
    Z3_goal p1,
  ) {
    final result = z3.goal_precision(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void goal_assert(
    Z3_goal p1,
    Z3_ast p2,
  ) {
    final result = z3.goal_assert(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool goal_inconsistent(
    Z3_goal p1,
  ) {
    final result = z3.goal_inconsistent(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int goal_depth(
    Z3_goal p1,
  ) {
    final result = z3.goal_depth(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void goal_reset(
    Z3_goal p1,
  ) {
    final result = z3.goal_reset(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int goal_size(
    Z3_goal p1,
  ) {
    final result = z3.goal_size(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast goal_formula(
    Z3_goal p1,
    int p2,
  ) {
    final result = z3.goal_formula(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int goal_num_exprs(
    Z3_goal p1,
  ) {
    final result = z3.goal_num_exprs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool goal_is_decided_sat(
    Z3_goal p1,
  ) {
    final result = z3.goal_is_decided_sat(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool goal_is_decided_unsat(
    Z3_goal p1,
  ) {
    final result = z3.goal_is_decided_unsat(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_goal goal_translate(
    Z3_goal p1,
    Z3_context p2,
  ) {
    final result = z3.goal_translate(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_model goal_convert_model(
    Z3_goal p1,
    Z3_model p2,
  ) {
    final result = z3.goal_convert_model(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> goal_to_string(
    Z3_goal p1,
  ) {
    final result = z3.goal_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> goal_to_dimacs_string(
    Z3_goal p1,
    bool p2,
  ) {
    final result = z3.goal_to_dimacs_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic mk_tactic(
    Pointer<Char> p1,
  ) {
    final result = z3.mk_tactic(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void tactic_inc_ref(
    Z3_tactic p1,
  ) {
    final result = z3.tactic_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void tactic_dec_ref(
    Z3_tactic p1,
  ) {
    final result = z3.tactic_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_probe mk_probe(
    Pointer<Char> p1,
  ) {
    final result = z3.mk_probe(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void probe_inc_ref(
    Z3_probe p1,
  ) {
    final result = z3.probe_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void probe_dec_ref(
    Z3_probe p1,
  ) {
    final result = z3.probe_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_and_then(
    Z3_tactic p1,
    Z3_tactic p2,
  ) {
    final result = z3.tactic_and_then(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_or_else(
    Z3_tactic p1,
    Z3_tactic p2,
  ) {
    final result = z3.tactic_or_else(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_par_or(
    int p1,
    Pointer<Z3_tactic> p2,
  ) {
    final result = z3.tactic_par_or(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_par_and_then(
    Z3_tactic p1,
    Z3_tactic p2,
  ) {
    final result = z3.tactic_par_and_then(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_try_for(
    Z3_tactic p1,
    int p2,
  ) {
    final result = z3.tactic_try_for(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_when(
    Z3_probe p1,
    Z3_tactic p2,
  ) {
    final result = z3.tactic_when(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_cond(
    Z3_probe p1,
    Z3_tactic p2,
    Z3_tactic p3,
  ) {
    final result = z3.tactic_cond(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_repeat(
    Z3_tactic p1,
    int p2,
  ) {
    final result = z3.tactic_repeat(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_skip() {
    final result = z3.tactic_skip(
      context,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_fail() {
    final result = z3.tactic_fail(
      context,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_fail_if(
    Z3_probe p1,
  ) {
    final result = z3.tactic_fail_if(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_fail_if_not_decided() {
    final result = z3.tactic_fail_if_not_decided(
      context,
    );
    checkError();
    return result;
  }

  Z3_tactic tactic_using_params(
    Z3_tactic p1,
    Z3_params p2,
  ) {
    final result = z3.tactic_using_params(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_simplifier mk_simplifier(
    Pointer<Char> p1,
  ) {
    final result = z3.mk_simplifier(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void simplifier_inc_ref(
    Z3_simplifier p1,
  ) {
    final result = z3.simplifier_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void simplifier_dec_ref(
    Z3_simplifier p1,
  ) {
    final result = z3.simplifier_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_solver solver_add_simplifier(
    Z3_solver p1,
    Z3_simplifier p2,
  ) {
    final result = z3.solver_add_simplifier(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_simplifier simplifier_and_then(
    Z3_simplifier p1,
    Z3_simplifier p2,
  ) {
    final result = z3.simplifier_and_then(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_simplifier simplifier_using_params(
    Z3_simplifier p1,
    Z3_params p2,
  ) {
    final result = z3.simplifier_using_params(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int get_num_simplifiers() {
    final result = z3.get_num_simplifiers(
      context,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_simplifier_name(
    int p1,
  ) {
    final result = z3.get_simplifier_name(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> simplifier_get_help(
    Z3_simplifier p1,
  ) {
    final result = z3.simplifier_get_help(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_param_descrs simplifier_get_param_descrs(
    Z3_simplifier p1,
  ) {
    final result = z3.simplifier_get_param_descrs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> simplifier_get_descr(
    Pointer<Char> p1,
  ) {
    final result = z3.simplifier_get_descr(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_probe probe_const(
    double p1,
  ) {
    final result = z3.probe_const(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_probe probe_lt(
    Z3_probe p1,
    Z3_probe p2,
  ) {
    final result = z3.probe_lt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_probe probe_gt(
    Z3_probe p1,
    Z3_probe p2,
  ) {
    final result = z3.probe_gt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_probe probe_le(
    Z3_probe p1,
    Z3_probe p2,
  ) {
    final result = z3.probe_le(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_probe probe_ge(
    Z3_probe p1,
    Z3_probe p2,
  ) {
    final result = z3.probe_ge(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_probe probe_eq(
    Z3_probe p1,
    Z3_probe p2,
  ) {
    final result = z3.probe_eq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_probe probe_and(
    Z3_probe p1,
    Z3_probe p2,
  ) {
    final result = z3.probe_and(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_probe probe_or(
    Z3_probe p1,
    Z3_probe p2,
  ) {
    final result = z3.probe_or(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_probe probe_not(
    Z3_probe p1,
  ) {
    final result = z3.probe_not(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_num_tactics() {
    final result = z3.get_num_tactics(
      context,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_tactic_name(
    int p1,
  ) {
    final result = z3.get_tactic_name(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int get_num_probes() {
    final result = z3.get_num_probes(
      context,
    );
    checkError();
    return result;
  }

  Pointer<Char> get_probe_name(
    int p1,
  ) {
    final result = z3.get_probe_name(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> tactic_get_help(
    Z3_tactic p1,
  ) {
    final result = z3.tactic_get_help(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_param_descrs tactic_get_param_descrs(
    Z3_tactic p1,
  ) {
    final result = z3.tactic_get_param_descrs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> tactic_get_descr(
    Pointer<Char> p1,
  ) {
    final result = z3.tactic_get_descr(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> probe_get_descr(
    Pointer<Char> p1,
  ) {
    final result = z3.probe_get_descr(
      context,
      p1,
    );
    checkError();
    return result;
  }

  double probe_apply(
    Z3_probe p1,
    Z3_goal p2,
  ) {
    final result = z3.probe_apply(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_apply_result tactic_apply(
    Z3_tactic p1,
    Z3_goal p2,
  ) {
    final result = z3.tactic_apply(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_apply_result tactic_apply_ex(
    Z3_tactic p1,
    Z3_goal p2,
    Z3_params p3,
  ) {
    final result = z3.tactic_apply_ex(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void apply_result_inc_ref(
    Z3_apply_result p1,
  ) {
    final result = z3.apply_result_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void apply_result_dec_ref(
    Z3_apply_result p1,
  ) {
    final result = z3.apply_result_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> apply_result_to_string(
    Z3_apply_result p1,
  ) {
    final result = z3.apply_result_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int apply_result_get_num_subgoals(
    Z3_apply_result p1,
  ) {
    final result = z3.apply_result_get_num_subgoals(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_goal apply_result_get_subgoal(
    Z3_apply_result p1,
    int p2,
  ) {
    final result = z3.apply_result_get_subgoal(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_solver mk_solver() {
    final result = z3.mk_solver(
      context,
    );
    checkError();
    return result;
  }

  Z3_solver mk_simple_solver() {
    final result = z3.mk_simple_solver(
      context,
    );
    checkError();
    return result;
  }

  Z3_solver mk_solver_for_logic(
    Z3_symbol p1,
  ) {
    final result = z3.mk_solver_for_logic(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_solver mk_solver_from_tactic(
    Z3_tactic p1,
  ) {
    final result = z3.mk_solver_from_tactic(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_solver solver_translate(
    Z3_solver p1,
    Z3_context p2,
  ) {
    final result = z3.solver_translate(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_import_model_converter(
    Z3_solver p1,
    Z3_solver p2,
  ) {
    final result = z3.solver_import_model_converter(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> solver_get_help(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_help(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_param_descrs solver_get_param_descrs(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_param_descrs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void solver_set_params(
    Z3_solver p1,
    Z3_params p2,
  ) {
    final result = z3.solver_set_params(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_inc_ref(
    Z3_solver p1,
  ) {
    final result = z3.solver_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void solver_dec_ref(
    Z3_solver p1,
  ) {
    final result = z3.solver_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void solver_interrupt(
    Z3_solver p1,
  ) {
    final result = z3.solver_interrupt(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void solver_push(
    Z3_solver p1,
  ) {
    final result = z3.solver_push(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void solver_pop(
    Z3_solver p1,
    int p2,
  ) {
    final result = z3.solver_pop(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_reset(
    Z3_solver p1,
  ) {
    final result = z3.solver_reset(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int solver_get_num_scopes(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_num_scopes(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void solver_assert(
    Z3_solver p1,
    Z3_ast p2,
  ) {
    final result = z3.solver_assert(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_assert_and_track(
    Z3_solver p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.solver_assert_and_track(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void solver_from_file(
    Z3_solver p1,
    Pointer<Char> p2,
  ) {
    final result = z3.solver_from_file(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_from_string(
    Z3_solver p1,
    Pointer<Char> p2,
  ) {
    final result = z3.solver_from_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector solver_get_assertions(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_assertions(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector solver_get_units(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_units(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector solver_get_trail(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_trail(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector solver_get_non_units(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_non_units(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void solver_get_levels(
    Z3_solver p1,
    Z3_ast_vector p2,
    int p3,
    Pointer<UnsignedInt> p4,
  ) {
    final result = z3.solver_get_levels(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast solver_congruence_root(
    Z3_solver p1,
    Z3_ast p2,
  ) {
    final result = z3.solver_congruence_root(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast solver_congruence_next(
    Z3_solver p1,
    Z3_ast p2,
  ) {
    final result = z3.solver_congruence_next(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_register_on_clause(
    Z3_solver p1,
    Pointer<Void> p2,
    Pointer<
            NativeFunction<
                Void Function(Pointer<Void>, Z3_ast, UnsignedInt,
                    Pointer<UnsignedInt>, Z3_ast_vector)>>
        p3,
  ) {
    final result = z3.solver_register_on_clause(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void solver_propagate_init(
    Z3_solver p1,
    Pointer<Void> p2,
    Pointer<NativeFunction<Void Function(Pointer<Void>, Z3_solver_callback)>>
        p3,
    Pointer<
            NativeFunction<
                Void Function(Pointer<Void>, Z3_solver_callback, UnsignedInt)>>
        p4,
    Pointer<NativeFunction<Pointer<Void> Function(Pointer<Void>, Z3_context)>>
        p5,
  ) {
    final result = z3.solver_propagate_init(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
    );
    checkError();
    return result;
  }

  void solver_propagate_fixed(
    Z3_solver p1,
    Pointer<
            NativeFunction<
                Void Function(
                    Pointer<Void>, Z3_solver_callback, Z3_ast, Z3_ast)>>
        p2,
  ) {
    final result = z3.solver_propagate_fixed(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_propagate_final(
    Z3_solver p1,
    Pointer<NativeFunction<Void Function(Pointer<Void>, Z3_solver_callback)>>
        p2,
  ) {
    final result = z3.solver_propagate_final(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_propagate_eq(
    Z3_solver p1,
    Pointer<
            NativeFunction<
                Void Function(
                    Pointer<Void>, Z3_solver_callback, Z3_ast, Z3_ast)>>
        p2,
  ) {
    final result = z3.solver_propagate_eq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_propagate_diseq(
    Z3_solver p1,
    Pointer<
            NativeFunction<
                Void Function(
                    Pointer<Void>, Z3_solver_callback, Z3_ast, Z3_ast)>>
        p2,
  ) {
    final result = z3.solver_propagate_diseq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_propagate_created(
    Z3_solver p1,
    Pointer<
            NativeFunction<
                Void Function(Pointer<Void>, Z3_solver_callback, Z3_ast)>>
        p2,
  ) {
    final result = z3.solver_propagate_created(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_propagate_decide(
    Z3_solver p1,
    Pointer<
            NativeFunction<
                Void Function(Pointer<Void>, Z3_solver_callback, Z3_ast,
                    UnsignedInt, Bool)>>
        p2,
  ) {
    final result = z3.solver_propagate_decide(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool solver_next_split(
    Z3_solver_callback p1,
    Z3_ast p2,
    int p3,
    int p4,
  ) {
    final result = z3.solver_next_split(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_func_decl solver_propagate_declare(
    Z3_symbol p1,
    int p2,
    Pointer<Z3_sort> p3,
    Z3_sort p4,
  ) {
    final result = z3.solver_propagate_declare(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  void solver_propagate_register(
    Z3_solver p1,
    Z3_ast p2,
  ) {
    final result = z3.solver_propagate_register(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void solver_propagate_register_cb(
    Z3_solver_callback p1,
    Z3_ast p2,
  ) {
    final result = z3.solver_propagate_register_cb(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool solver_propagate_consequence(
    Z3_solver_callback p1,
    int p2,
    Pointer<Z3_ast> p3,
    int p4,
    Pointer<Z3_ast> p5,
    Pointer<Z3_ast> p6,
    Z3_ast p7,
  ) {
    final result = z3.solver_propagate_consequence(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
    );
    checkError();
    return result;
  }

  int solver_check(
    Z3_solver p1,
  ) {
    final result = z3.solver_check(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int solver_check_assumptions(
    Z3_solver p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.solver_check_assumptions(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  int get_implied_equalities(
    Z3_solver p1,
    int p2,
    Pointer<Z3_ast> p3,
    Pointer<UnsignedInt> p4,
  ) {
    final result = z3.get_implied_equalities(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  int solver_get_consequences(
    Z3_solver p1,
    Z3_ast_vector p2,
    Z3_ast_vector p3,
    Z3_ast_vector p4,
  ) {
    final result = z3.solver_get_consequences(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast_vector solver_cube(
    Z3_solver p1,
    Z3_ast_vector p2,
    int p3,
  ) {
    final result = z3.solver_cube(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_model solver_get_model(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_model(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast solver_get_proof(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_proof(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector solver_get_unsat_core(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_unsat_core(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> solver_get_reason_unknown(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_reason_unknown(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_stats solver_get_statistics(
    Z3_solver p1,
  ) {
    final result = z3.solver_get_statistics(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> solver_to_string(
    Z3_solver p1,
  ) {
    final result = z3.solver_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> solver_to_dimacs_string(
    Z3_solver p1,
    bool p2,
  ) {
    final result = z3.solver_to_dimacs_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> stats_to_string(
    Z3_stats p1,
  ) {
    final result = z3.stats_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void stats_inc_ref(
    Z3_stats p1,
  ) {
    final result = z3.stats_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void stats_dec_ref(
    Z3_stats p1,
  ) {
    final result = z3.stats_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int stats_size(
    Z3_stats p1,
  ) {
    final result = z3.stats_size(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> stats_get_key(
    Z3_stats p1,
    int p2,
  ) {
    final result = z3.stats_get_key(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool stats_is_uint(
    Z3_stats p1,
    int p2,
  ) {
    final result = z3.stats_is_uint(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool stats_is_double(
    Z3_stats p1,
    int p2,
  ) {
    final result = z3.stats_is_double(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int stats_get_uint_value(
    Z3_stats p1,
    int p2,
  ) {
    final result = z3.stats_get_uint_value(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  double stats_get_double_value(
    Z3_stats p1,
    int p2,
  ) {
    final result = z3.stats_get_double_value(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector mk_ast_vector() {
    final result = z3.mk_ast_vector(
      context,
    );
    checkError();
    return result;
  }

  void ast_vector_inc_ref(
    Z3_ast_vector p1,
  ) {
    final result = z3.ast_vector_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void ast_vector_dec_ref(
    Z3_ast_vector p1,
  ) {
    final result = z3.ast_vector_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int ast_vector_size(
    Z3_ast_vector p1,
  ) {
    final result = z3.ast_vector_size(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast ast_vector_get(
    Z3_ast_vector p1,
    int p2,
  ) {
    final result = z3.ast_vector_get(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void ast_vector_set(
    Z3_ast_vector p1,
    int p2,
    Z3_ast p3,
  ) {
    final result = z3.ast_vector_set(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void ast_vector_resize(
    Z3_ast_vector p1,
    int p2,
  ) {
    final result = z3.ast_vector_resize(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void ast_vector_push(
    Z3_ast_vector p1,
    Z3_ast p2,
  ) {
    final result = z3.ast_vector_push(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector ast_vector_translate(
    Z3_ast_vector p1,
    Z3_context p2,
  ) {
    final result = z3.ast_vector_translate(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> ast_vector_to_string(
    Z3_ast_vector p1,
  ) {
    final result = z3.ast_vector_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_map mk_ast_map() {
    final result = z3.mk_ast_map(
      context,
    );
    checkError();
    return result;
  }

  void ast_map_inc_ref(
    Z3_ast_map p1,
  ) {
    final result = z3.ast_map_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void ast_map_dec_ref(
    Z3_ast_map p1,
  ) {
    final result = z3.ast_map_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool ast_map_contains(
    Z3_ast_map p1,
    Z3_ast p2,
  ) {
    final result = z3.ast_map_contains(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast ast_map_find(
    Z3_ast_map p1,
    Z3_ast p2,
  ) {
    final result = z3.ast_map_find(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void ast_map_insert(
    Z3_ast_map p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.ast_map_insert(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void ast_map_erase(
    Z3_ast_map p1,
    Z3_ast p2,
  ) {
    final result = z3.ast_map_erase(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void ast_map_reset(
    Z3_ast_map p1,
  ) {
    final result = z3.ast_map_reset(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int ast_map_size(
    Z3_ast_map p1,
  ) {
    final result = z3.ast_map_size(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector ast_map_keys(
    Z3_ast_map p1,
  ) {
    final result = z3.ast_map_keys(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> ast_map_to_string(
    Z3_ast_map p1,
  ) {
    final result = z3.ast_map_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool algebraic_is_value(
    Z3_ast p1,
  ) {
    final result = z3.algebraic_is_value(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool algebraic_is_pos(
    Z3_ast p1,
  ) {
    final result = z3.algebraic_is_pos(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool algebraic_is_neg(
    Z3_ast p1,
  ) {
    final result = z3.algebraic_is_neg(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool algebraic_is_zero(
    Z3_ast p1,
  ) {
    final result = z3.algebraic_is_zero(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int algebraic_sign(
    Z3_ast p1,
  ) {
    final result = z3.algebraic_sign(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast algebraic_add(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_add(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast algebraic_sub(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_sub(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast algebraic_mul(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_mul(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast algebraic_div(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_div(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast algebraic_root(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.algebraic_root(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast algebraic_power(
    Z3_ast p1,
    int p2,
  ) {
    final result = z3.algebraic_power(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool algebraic_lt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_lt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool algebraic_gt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_gt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool algebraic_le(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_le(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool algebraic_ge(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_ge(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool algebraic_eq(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_eq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool algebraic_neq(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.algebraic_neq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector algebraic_roots(
    Z3_ast p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.algebraic_roots(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  int algebraic_eval(
    Z3_ast p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.algebraic_eval(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast_vector algebraic_get_poly(
    Z3_ast p1,
  ) {
    final result = z3.algebraic_get_poly(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int algebraic_get_i(
    Z3_ast p1,
  ) {
    final result = z3.algebraic_get_i(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector polynomial_subresultants(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.polynomial_subresultants(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void rcf_del(
    Z3_rcf_num p1,
  ) {
    final result = z3.rcf_del(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_mk_rational(
    Pointer<Char> p1,
  ) {
    final result = z3.rcf_mk_rational(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_mk_small_int(
    int p1,
  ) {
    final result = z3.rcf_mk_small_int(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_mk_pi() {
    final result = z3.rcf_mk_pi(
      context,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_mk_e() {
    final result = z3.rcf_mk_e(
      context,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_mk_infinitesimal() {
    final result = z3.rcf_mk_infinitesimal(
      context,
    );
    checkError();
    return result;
  }

  int rcf_mk_roots(
    int p1,
    Pointer<Z3_rcf_num> p2,
    Pointer<Z3_rcf_num> p3,
  ) {
    final result = z3.rcf_mk_roots(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_add(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_add(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_sub(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_sub(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_mul(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_mul(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_div(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_div(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_neg(
    Z3_rcf_num p1,
  ) {
    final result = z3.rcf_neg(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_inv(
    Z3_rcf_num p1,
  ) {
    final result = z3.rcf_inv(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_rcf_num rcf_power(
    Z3_rcf_num p1,
    int p2,
  ) {
    final result = z3.rcf_power(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool rcf_lt(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_lt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool rcf_gt(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_gt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool rcf_le(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_le(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool rcf_ge(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_ge(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool rcf_eq(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_eq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool rcf_neq(
    Z3_rcf_num p1,
    Z3_rcf_num p2,
  ) {
    final result = z3.rcf_neq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> rcf_num_to_string(
    Z3_rcf_num p1,
    bool p2,
    bool p3,
  ) {
    final result = z3.rcf_num_to_string(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Pointer<Char> rcf_num_to_decimal_string(
    Z3_rcf_num p1,
    int p2,
  ) {
    final result = z3.rcf_num_to_decimal_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void rcf_get_numerator_denominator(
    Z3_rcf_num p1,
    Pointer<Z3_rcf_num> p2,
    Pointer<Z3_rcf_num> p3,
  ) {
    final result = z3.rcf_get_numerator_denominator(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_fixedpoint mk_fixedpoint() {
    final result = z3.mk_fixedpoint(
      context,
    );
    checkError();
    return result;
  }

  void fixedpoint_inc_ref(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void fixedpoint_dec_ref(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void fixedpoint_add_rule(
    Z3_fixedpoint p1,
    Z3_ast p2,
    Z3_symbol p3,
  ) {
    final result = z3.fixedpoint_add_rule(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void fixedpoint_add_fact(
    Z3_fixedpoint p1,
    Z3_func_decl p2,
    int p3,
    Pointer<UnsignedInt> p4,
  ) {
    final result = z3.fixedpoint_add_fact(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  void fixedpoint_assert(
    Z3_fixedpoint p1,
    Z3_ast p2,
  ) {
    final result = z3.fixedpoint_assert(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int fixedpoint_query(
    Z3_fixedpoint p1,
    Z3_ast p2,
  ) {
    final result = z3.fixedpoint_query(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int fixedpoint_query_relations(
    Z3_fixedpoint p1,
    int p2,
    Pointer<Z3_func_decl> p3,
  ) {
    final result = z3.fixedpoint_query_relations(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast fixedpoint_get_answer(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_answer(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> fixedpoint_get_reason_unknown(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_reason_unknown(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void fixedpoint_update_rule(
    Z3_fixedpoint p1,
    Z3_ast p2,
    Z3_symbol p3,
  ) {
    final result = z3.fixedpoint_update_rule(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  int fixedpoint_get_num_levels(
    Z3_fixedpoint p1,
    Z3_func_decl p2,
  ) {
    final result = z3.fixedpoint_get_num_levels(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast fixedpoint_get_cover_delta(
    Z3_fixedpoint p1,
    int p2,
    Z3_func_decl p3,
  ) {
    final result = z3.fixedpoint_get_cover_delta(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  void fixedpoint_add_cover(
    Z3_fixedpoint p1,
    int p2,
    Z3_func_decl p3,
    Z3_ast p4,
  ) {
    final result = z3.fixedpoint_add_cover(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_stats fixedpoint_get_statistics(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_statistics(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void fixedpoint_register_relation(
    Z3_fixedpoint p1,
    Z3_func_decl p2,
  ) {
    final result = z3.fixedpoint_register_relation(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void fixedpoint_set_predicate_representation(
    Z3_fixedpoint p1,
    Z3_func_decl p2,
    int p3,
    Pointer<Z3_symbol> p4,
  ) {
    final result = z3.fixedpoint_set_predicate_representation(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast_vector fixedpoint_get_rules(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_rules(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector fixedpoint_get_assertions(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_assertions(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void fixedpoint_set_params(
    Z3_fixedpoint p1,
    Z3_params p2,
  ) {
    final result = z3.fixedpoint_set_params(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> fixedpoint_get_help(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_help(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_param_descrs fixedpoint_get_param_descrs(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_param_descrs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Pointer<Char> fixedpoint_to_string(
    Z3_fixedpoint p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.fixedpoint_to_string(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast_vector fixedpoint_from_string(
    Z3_fixedpoint p1,
    Pointer<Char> p2,
  ) {
    final result = z3.fixedpoint_from_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector fixedpoint_from_file(
    Z3_fixedpoint p1,
    Pointer<Char> p2,
  ) {
    final result = z3.fixedpoint_from_file(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void fixedpoint_init(
    Z3_fixedpoint p1,
    Pointer<Void> p2,
  ) {
    final result = z3.fixedpoint_init(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void fixedpoint_set_reduce_assign_callback(
    Z3_fixedpoint p1,
    Pointer<
            NativeFunction<
                Void Function(Pointer<Void>, Z3_func_decl, UnsignedInt,
                    Pointer<Z3_ast>, UnsignedInt, Pointer<Z3_ast>)>>
        p2,
  ) {
    final result = z3.fixedpoint_set_reduce_assign_callback(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void fixedpoint_set_reduce_app_callback(
    Z3_fixedpoint p1,
    Pointer<
            NativeFunction<
                Void Function(Pointer<Void>, Z3_func_decl, UnsignedInt,
                    Pointer<Z3_ast>, Pointer<Z3_ast>)>>
        p2,
  ) {
    final result = z3.fixedpoint_set_reduce_app_callback(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void fixedpoint_add_callback(
    Z3_fixedpoint p1,
    Pointer<Void> p2,
    Pointer<NativeFunction<Void Function(Pointer<Void>, Z3_ast, UnsignedInt)>>
        p3,
    Pointer<NativeFunction<Void Function(Pointer<Void>)>> p4,
    Pointer<NativeFunction<Void Function(Pointer<Void>)>> p5,
  ) {
    final result = z3.fixedpoint_add_callback(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
    );
    checkError();
    return result;
  }

  void fixedpoint_add_constraint(
    Z3_fixedpoint p1,
    Z3_ast p2,
    int p3,
  ) {
    final result = z3.fixedpoint_add_constraint(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_optimize mk_optimize() {
    final result = z3.mk_optimize(
      context,
    );
    checkError();
    return result;
  }

  void optimize_inc_ref(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_inc_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void optimize_dec_ref(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_dec_ref(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void optimize_assert(
    Z3_optimize p1,
    Z3_ast p2,
  ) {
    final result = z3.optimize_assert(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void optimize_assert_and_track(
    Z3_optimize p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.optimize_assert_and_track(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  int optimize_assert_soft(
    Z3_optimize p1,
    Z3_ast p2,
    Pointer<Char> p3,
    Z3_symbol p4,
  ) {
    final result = z3.optimize_assert_soft(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  int optimize_maximize(
    Z3_optimize p1,
    Z3_ast p2,
  ) {
    final result = z3.optimize_maximize(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  int optimize_minimize(
    Z3_optimize p1,
    Z3_ast p2,
  ) {
    final result = z3.optimize_minimize(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void optimize_push(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_push(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void optimize_pop(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_pop(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int optimize_check(
    Z3_optimize p1,
    int p2,
    Pointer<Z3_ast> p3,
  ) {
    final result = z3.optimize_check(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Pointer<Char> optimize_get_reason_unknown(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_reason_unknown(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_model optimize_get_model(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_model(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector optimize_get_unsat_core(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_unsat_core(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void optimize_set_params(
    Z3_optimize p1,
    Z3_params p2,
  ) {
    final result = z3.optimize_set_params(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_param_descrs optimize_get_param_descrs(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_param_descrs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast optimize_get_lower(
    Z3_optimize p1,
    int p2,
  ) {
    final result = z3.optimize_get_lower(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast optimize_get_upper(
    Z3_optimize p1,
    int p2,
  ) {
    final result = z3.optimize_get_upper(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector optimize_get_lower_as_vector(
    Z3_optimize p1,
    int p2,
  ) {
    final result = z3.optimize_get_lower_as_vector(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast_vector optimize_get_upper_as_vector(
    Z3_optimize p1,
    int p2,
  ) {
    final result = z3.optimize_get_upper_as_vector(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> optimize_to_string(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_to_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void optimize_from_string(
    Z3_optimize p1,
    Pointer<Char> p2,
  ) {
    final result = z3.optimize_from_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  void optimize_from_file(
    Z3_optimize p1,
    Pointer<Char> p2,
  ) {
    final result = z3.optimize_from_file(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> optimize_get_help(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_help(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_stats optimize_get_statistics(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_statistics(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector optimize_get_assertions(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_assertions(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector optimize_get_objectives(
    Z3_optimize p1,
  ) {
    final result = z3.optimize_get_objectives(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void optimize_register_model_eh(
    Z3_optimize p1,
    Z3_model p2,
    Pointer<Void> p3,
    Pointer<NativeFunction<Void Function(Pointer<Void>)>> p4,
  ) {
    final result = z3.optimize_register_model_eh(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_rounding_mode_sort() {
    final result = z3.mk_fpa_rounding_mode_sort(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_round_nearest_ties_to_even() {
    final result = z3.mk_fpa_round_nearest_ties_to_even(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_rne() {
    final result = z3.mk_fpa_rne(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_round_nearest_ties_to_away() {
    final result = z3.mk_fpa_round_nearest_ties_to_away(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_rna() {
    final result = z3.mk_fpa_rna(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_round_toward_positive() {
    final result = z3.mk_fpa_round_toward_positive(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_rtp() {
    final result = z3.mk_fpa_rtp(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_round_toward_negative() {
    final result = z3.mk_fpa_round_toward_negative(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_rtn() {
    final result = z3.mk_fpa_rtn(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_round_toward_zero() {
    final result = z3.mk_fpa_round_toward_zero(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_rtz() {
    final result = z3.mk_fpa_rtz(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort(
    int p1,
    int p2,
  ) {
    final result = z3.mk_fpa_sort(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_half() {
    final result = z3.mk_fpa_sort_half(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_16() {
    final result = z3.mk_fpa_sort_16(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_single() {
    final result = z3.mk_fpa_sort_single(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_32() {
    final result = z3.mk_fpa_sort_32(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_double() {
    final result = z3.mk_fpa_sort_double(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_64() {
    final result = z3.mk_fpa_sort_64(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_quadruple() {
    final result = z3.mk_fpa_sort_quadruple(
      context,
    );
    checkError();
    return result;
  }

  Z3_sort mk_fpa_sort_128() {
    final result = z3.mk_fpa_sort_128(
      context,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_nan(
    Z3_sort p1,
  ) {
    final result = z3.mk_fpa_nan(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_inf(
    Z3_sort p1,
    bool p2,
  ) {
    final result = z3.mk_fpa_inf(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_zero(
    Z3_sort p1,
    bool p2,
  ) {
    final result = z3.mk_fpa_zero(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_fp(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_fpa_fp(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_numeral_float(
    double p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_fpa_numeral_float(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_numeral_double(
    double p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_fpa_numeral_double(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_numeral_int(
    int p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_fpa_numeral_int(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_numeral_int_uint(
    bool p1,
    int p2,
    int p3,
    Z3_sort p4,
  ) {
    final result = z3.mk_fpa_numeral_int_uint(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_numeral_int64_uint64(
    bool p1,
    int p2,
    int p3,
    Z3_sort p4,
  ) {
    final result = z3.mk_fpa_numeral_int64_uint64(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_abs(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_abs(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_neg(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_neg(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_add(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_fpa_add(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_sub(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_fpa_sub(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_mul(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_fpa_mul(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_div(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
  ) {
    final result = z3.mk_fpa_div(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_fma(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
    Z3_ast p4,
  ) {
    final result = z3.mk_fpa_fma(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_sqrt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_sqrt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_rem(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_rem(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_round_to_integral(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_round_to_integral(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_min(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_min(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_max(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_max(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_leq(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_leq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_lt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_lt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_geq(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_geq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_gt(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_gt(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_eq(
    Z3_ast p1,
    Z3_ast p2,
  ) {
    final result = z3.mk_fpa_eq(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_is_normal(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_is_normal(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_is_subnormal(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_is_subnormal(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_is_zero(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_is_zero(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_is_infinite(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_is_infinite(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_is_nan(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_is_nan(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_is_negative(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_is_negative(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_is_positive(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_is_positive(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_fp_bv(
    Z3_ast p1,
    Z3_sort p2,
  ) {
    final result = z3.mk_fpa_to_fp_bv(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_fp_float(
    Z3_ast p1,
    Z3_ast p2,
    Z3_sort p3,
  ) {
    final result = z3.mk_fpa_to_fp_float(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_fp_real(
    Z3_ast p1,
    Z3_ast p2,
    Z3_sort p3,
  ) {
    final result = z3.mk_fpa_to_fp_real(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_fp_signed(
    Z3_ast p1,
    Z3_ast p2,
    Z3_sort p3,
  ) {
    final result = z3.mk_fpa_to_fp_signed(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_fp_unsigned(
    Z3_ast p1,
    Z3_ast p2,
    Z3_sort p3,
  ) {
    final result = z3.mk_fpa_to_fp_unsigned(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_ubv(
    Z3_ast p1,
    Z3_ast p2,
    int p3,
  ) {
    final result = z3.mk_fpa_to_ubv(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_sbv(
    Z3_ast p1,
    Z3_ast p2,
    int p3,
  ) {
    final result = z3.mk_fpa_to_sbv(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_real(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_to_real(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int fpa_get_ebits(
    Z3_sort p1,
  ) {
    final result = z3.fpa_get_ebits(
      context,
      p1,
    );
    checkError();
    return result;
  }

  int fpa_get_sbits(
    Z3_sort p1,
  ) {
    final result = z3.fpa_get_sbits(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_is_numeral_nan(
    Z3_ast p1,
  ) {
    final result = z3.fpa_is_numeral_nan(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_is_numeral_inf(
    Z3_ast p1,
  ) {
    final result = z3.fpa_is_numeral_inf(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_is_numeral_zero(
    Z3_ast p1,
  ) {
    final result = z3.fpa_is_numeral_zero(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_is_numeral_normal(
    Z3_ast p1,
  ) {
    final result = z3.fpa_is_numeral_normal(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_is_numeral_subnormal(
    Z3_ast p1,
  ) {
    final result = z3.fpa_is_numeral_subnormal(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_is_numeral_positive(
    Z3_ast p1,
  ) {
    final result = z3.fpa_is_numeral_positive(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_is_numeral_negative(
    Z3_ast p1,
  ) {
    final result = z3.fpa_is_numeral_negative(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast fpa_get_numeral_sign_bv(
    Z3_ast p1,
  ) {
    final result = z3.fpa_get_numeral_sign_bv(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast fpa_get_numeral_significand_bv(
    Z3_ast p1,
  ) {
    final result = z3.fpa_get_numeral_significand_bv(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_get_numeral_sign(
    Z3_ast p1,
    Pointer<Int> p2,
  ) {
    final result = z3.fpa_get_numeral_sign(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> fpa_get_numeral_significand_string(
    Z3_ast p1,
  ) {
    final result = z3.fpa_get_numeral_significand_string(
      context,
      p1,
    );
    checkError();
    return result;
  }

  bool fpa_get_numeral_significand_uint64(
    Z3_ast p1,
    Pointer<Uint64> p2,
  ) {
    final result = z3.fpa_get_numeral_significand_uint64(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Pointer<Char> fpa_get_numeral_exponent_string(
    Z3_ast p1,
    bool p2,
  ) {
    final result = z3.fpa_get_numeral_exponent_string(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  bool fpa_get_numeral_exponent_int64(
    Z3_ast p1,
    Pointer<Int64> p2,
    bool p3,
  ) {
    final result = z3.fpa_get_numeral_exponent_int64(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast fpa_get_numeral_exponent_bv(
    Z3_ast p1,
    bool p2,
  ) {
    final result = z3.fpa_get_numeral_exponent_bv(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_ieee_bv(
    Z3_ast p1,
  ) {
    final result = z3.mk_fpa_to_ieee_bv(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast mk_fpa_to_fp_int_real(
    Z3_ast p1,
    Z3_ast p2,
    Z3_ast p3,
    Z3_sort p4,
  ) {
    final result = z3.mk_fpa_to_fp_int_real(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  int fixedpoint_query_from_lvl(
    Z3_fixedpoint p1,
    Z3_ast p2,
    int p3,
  ) {
    final result = z3.fixedpoint_query_from_lvl(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast fixedpoint_get_ground_sat_answer(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_ground_sat_answer(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_ast_vector fixedpoint_get_rules_along_trace(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_rules_along_trace(
      context,
      p1,
    );
    checkError();
    return result;
  }

  Z3_symbol fixedpoint_get_rule_names_along_trace(
    Z3_fixedpoint p1,
  ) {
    final result = z3.fixedpoint_get_rule_names_along_trace(
      context,
      p1,
    );
    checkError();
    return result;
  }

  void fixedpoint_add_invariant(
    Z3_fixedpoint p1,
    Z3_func_decl p2,
    Z3_ast p3,
  ) {
    final result = z3.fixedpoint_add_invariant(
      context,
      p1,
      p2,
      p3,
    );
    checkError();
    return result;
  }

  Z3_ast fixedpoint_get_reachable(
    Z3_fixedpoint p1,
    Z3_func_decl p2,
  ) {
    final result = z3.fixedpoint_get_reachable(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast qe_model_project(
    Z3_model p1,
    int p2,
    Pointer<Z3_app> p3,
    Z3_ast p4,
  ) {
    final result = z3.qe_model_project(
      context,
      p1,
      p2,
      p3,
      p4,
    );
    checkError();
    return result;
  }

  Z3_ast qe_model_project_skolem(
    Z3_model p1,
    int p2,
    Pointer<Z3_app> p3,
    Z3_ast p4,
    Z3_ast_map p5,
  ) {
    final result = z3.qe_model_project_skolem(
      context,
      p1,
      p2,
      p3,
      p4,
      p5,
    );
    checkError();
    return result;
  }

  Z3_ast model_extrapolate(
    Z3_model p1,
    Z3_ast p2,
  ) {
    final result = z3.model_extrapolate(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }

  Z3_ast qe_lite(
    Z3_ast_vector p1,
    Z3_ast p2,
  ) {
    final result = z3.qe_lite(
      context,
      p1,
      p2,
    );
    checkError();
    return result;
  }
}
