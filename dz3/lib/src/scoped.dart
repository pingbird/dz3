import 'dart:async';

import 'nums.dart';
import 'z3.dart';

/// Runs [fn] in the specified [context].
T withContext<T>(Context context, T Function() fn) {
  return runZoned(() => fn(), zoneValues: {#z3_context: context});
}

Context? _rootContext;

/// The root context that is used by default.
///
/// This is initialized to a new context with default configuration, but can be
/// overridden by the user.
Context get rootContext => _rootContext ??= Context(Config());
set rootContext(Context context) {
  if (_rootContext != null) {
    throw StateError('Root context already initialized');
  }
  _rootContext = context;
}

/// The current context, or [rootContext] if none is set.
///
/// See also:
/// * [withContext], which allows you to run code in a specific context.
Context get currentContext =>
    (Zone.current[#z3_context] as Context?) ?? rootContext;

NullaryOp get trueExpr => NullaryOp(NullaryOpKind.trueExpr).declare();
NullaryOp get falseExpr => NullaryOp(NullaryOpKind.falseExpr).declare();
NullaryOp get fpaRne => NullaryOp(NullaryOpKind.fpaRne).declare();
NullaryOp get fpaRoundNearestTiesToEven => fpaRne;
NullaryOp get fpaRna => NullaryOp(NullaryOpKind.fpaRna).declare();
NullaryOp get fpaRoundNearestTiesToAway => fpaRna;
NullaryOp get fpaRtp => NullaryOp(NullaryOpKind.fpaRtp).declare();
NullaryOp get fpaRoundTowardPositive => fpaRtp;
NullaryOp get fpaRtn => NullaryOp(NullaryOpKind.fpaRtn).declare();
NullaryOp get fpaRoundTowardNegative => fpaRtn;
NullaryOp get fpaRtz => NullaryOp(NullaryOpKind.fpaRtz).declare();
NullaryOp get fpaRoundTowardZero => fpaRtz;

UnaryOp not(Expr x) => UnaryOp(UnaryOpKind.not, x).declare();
UnaryOp unaryMinus(Expr x) => UnaryOp(UnaryOpKind.unaryMinus, x).declare();
UnaryOp intToReal(Expr x) => UnaryOp(UnaryOpKind.intToReal, x).declare();
UnaryOp realToInt(Expr x) => UnaryOp(UnaryOpKind.realToInt, x).declare();
UnaryOp isInt(Expr x) => UnaryOp(UnaryOpKind.isInt, x).declare();
UnaryOp bvNot(Expr x) => UnaryOp(UnaryOpKind.bvNot, x).declare();
UnaryOp bvRedAnd(Expr x) => UnaryOp(UnaryOpKind.bvRedAnd, x).declare();
UnaryOp bvRedOr(Expr x) => UnaryOp(UnaryOpKind.bvRedOr, x).declare();
UnaryOp bvNeg(Expr x) => UnaryOp(UnaryOpKind.bvNeg, x).declare();

Expr bvNegNoOverflow(Expr x) {
  final s = getSort<BitVecSort>(x);
  return notEq(x, s.sMin());
}

Expr abs(Expr x, [Sort? sort]) {
  sort ??= getSort(x);
  if (sort is FloatSort) {
    return fpaAbs(x);
  } else if (sort is BitVecSort) {
    return ite(bvSlt(x, sort.zero()), bvNeg(x), x);
  } else if (sort is IntSort || sort is RealSort) {
    return ite(lt(x, intFrom(0)), unaryMinus(x), x);
  } else {
    throw ArgumentError('Unsupported sort: $sort');
  }
}

Expr arrayDefault(Expr x) => UnaryOp(UnaryOpKind.arrayDefault, x).declare();
Expr setComplement(Expr x) => UnaryOp(UnaryOpKind.setComplement, x).declare();
Expr seqUnit(Expr x) => UnaryOp(UnaryOpKind.seqUnit, x).declare();
Expr seqLength(Expr x) => UnaryOp(UnaryOpKind.seqLength, x).declare();
Expr strToInt(Expr x) => UnaryOp(UnaryOpKind.strToInt, x).declare();
Expr intToStr(Expr x) => UnaryOp(UnaryOpKind.intToStr, x).declare();
Expr strToCode(Expr x) => UnaryOp(UnaryOpKind.strToCode, x).declare();
Expr codeToStr(Expr x) => UnaryOp(UnaryOpKind.codeToStr, x).declare();
Expr ubvToStr(Expr x) => UnaryOp(UnaryOpKind.ubvToStr, x).declare();
Expr sbvToStr(Expr x) => UnaryOp(UnaryOpKind.sbvToStr, x).declare();
Expr seqToRe(Expr x) => UnaryOp(UnaryOpKind.seqToRe, x).declare();
Expr rePlus(Expr x) => UnaryOp(UnaryOpKind.rePlus, x).declare();
Expr reStar(Expr x) => UnaryOp(UnaryOpKind.reStar, x).declare();
Expr reOption(Expr x) => UnaryOp(UnaryOpKind.reOption, x).declare();
Expr reComplement(Expr x) => UnaryOp(UnaryOpKind.reComplement, x).declare();
Expr charToInt(Expr x) => UnaryOp(UnaryOpKind.charToInt, x).declare();
Expr charToBv(Expr x) => UnaryOp(UnaryOpKind.charToBv, x).declare();
Expr bvToChar(Expr x) => UnaryOp(UnaryOpKind.bvToChar, x).declare();
Expr charIsDigit(Expr x) => UnaryOp(UnaryOpKind.charIsDigit, x).declare();
Expr fpaAbs(Expr x) => UnaryOp(UnaryOpKind.fpaAbs, x).declare();
Expr fpaNeg(Expr x) => UnaryOp(UnaryOpKind.fpaNeg, x).declare();
Expr fpaIsNormal(Expr x) => UnaryOp(UnaryOpKind.fpaIsNormal, x).declare();
Expr fpaIsSubnormal(Expr x) => UnaryOp(UnaryOpKind.fpaIsSubnormal, x).declare();
Expr fpaIsZero(Expr x) => UnaryOp(UnaryOpKind.fpaIsZero, x).declare();
Expr fpaIsInfinite(Expr x) => UnaryOp(UnaryOpKind.fpaIsInfinite, x).declare();
Expr fpaIsNaN(Expr x) => UnaryOp(UnaryOpKind.fpaIsNaN, x).declare();
Expr fpaIsNegative(Expr x) => UnaryOp(UnaryOpKind.fpaIsNegative, x).declare();
Expr fpaIsPositive(Expr x) => UnaryOp(UnaryOpKind.fpaIsPositive, x).declare();
Expr fpaToReal(Expr x) => UnaryOp(UnaryOpKind.fpaToReal, x).declare();
Expr fpaToIeeeBv(Expr x) => UnaryOp(UnaryOpKind.fpaToIeeeBv, x).declare();

BinaryOp eq(Expr x, Expr y) => BinaryOp(BinaryOpKind.eq, x, y).declare();
UnaryOp notEq(Expr x, Expr y) => not(eq(x, y));
BinaryOp iff(Expr x, Expr y) => BinaryOp(BinaryOpKind.eq, x, y).declare();
BinaryOp implies(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.implies, x, y).declare();
BinaryOp xor(Expr x, Expr y) => BinaryOp(BinaryOpKind.xor, x, y).declare();
BinaryOp div(Expr x, Expr y) => BinaryOp(BinaryOpKind.div, x, y).declare();
BinaryOp mod(Expr x, Expr y) => BinaryOp(BinaryOpKind.mod, x, y).declare();
BinaryOp rem(Expr x, Expr y) => BinaryOp(BinaryOpKind.rem, x, y).declare();
BinaryOp pow(Expr x, Expr y) => BinaryOp(BinaryOpKind.pow, x, y).declare();
BinaryOp lt(Expr x, Expr y) => BinaryOp(BinaryOpKind.lt, x, y).declare();
BinaryOp le(Expr x, Expr y) => BinaryOp(BinaryOpKind.le, x, y).declare();
BinaryOp gt(Expr x, Expr y) => BinaryOp(BinaryOpKind.gt, x, y).declare();
BinaryOp ge(Expr x, Expr y) => BinaryOp(BinaryOpKind.ge, x, y).declare();
BinaryOp bvAnd(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvAnd, x, y).declare();
BinaryOp bvOr(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvOr, x, y).declare();
BinaryOp bvXor(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvXor, x, y).declare();
BinaryOp bvNand(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvNand, x, y).declare();
BinaryOp bvNor(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvNor, x, y).declare();
BinaryOp bvXnor(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvXnor, x, y).declare();
BinaryOp bvAdd(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvAdd, x, y).declare();
BinaryOp bvSub(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSub, x, y).declare();
BinaryOp bvMul(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvMul, x, y).declare();
BinaryOp bvUdiv(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvUdiv, x, y).declare();
BinaryOp bvSdiv(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvSdiv, x, y).declare();
BinaryOp bvUrem(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvUrem, x, y).declare();
BinaryOp bvSrem(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvSrem, x, y).declare();
BinaryOp bvSmod(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvSmod, x, y).declare();
BinaryOp bvUlt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUlt, x, y).declare();
BinaryOp bvSlt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSlt, x, y).declare();
BinaryOp bvUle(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUle, x, y).declare();
BinaryOp bvSle(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSle, x, y).declare();
BinaryOp bvUge(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUge, x, y).declare();
BinaryOp bvSge(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSge, x, y).declare();
BinaryOp bvUgt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUgt, x, y).declare();
BinaryOp bvSgt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSgt, x, y).declare();
BinaryOp bvConcat(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvConcat, x, y).declare();
BinaryOp bvShl(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvShl, x, y).declare();
BinaryOp bvLshr(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvLshr, x, y).declare();
BinaryOp bvAshr(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvAshr, x, y).declare();
BinaryOp bvRotl(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvRotl, x, y).declare();
BinaryOp bvRotr(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvRotr, x, y).declare();

Expr bvAddNoUnderflow(Expr x, Expr y) {
  final zero = (getSort(x) as BitVecSort).zero();
  final r = bvAdd(x, y);
  final l1 = bvSlt(x, zero);
  final l2 = bvSlt(y, zero);
  final argsNeg = and(l1, l2);
  final lt = bvSlt(r, zero);
  return implies(argsNeg, lt);
}

Expr bvAddNoOverflow(Expr x, Expr y, {required bool signed}) {
  if (signed) {
    final zero = getSort<BitVecSort>(x).zero();
    final r = bvAdd(x, y);
    final l1 = bvSlt(zero, x);
    final l2 = bvSlt(zero, y);
    final argsPos = and(l1, l2);
    final lt = bvSlt(zero, r);
    return implies(argsPos, lt);
  } else {
    final size = getSort<BitVecSort>(x).size;
    x = bvZeroExt(x, 1);
    y = bvZeroExt(y, 1);
    final r = bvAdd(x, y);
    final ex = bvExtract(r, size, size);
    return eq(ex, bvFrom(0, 1));
  }
}

Expr bvSubNoOverflow(Expr x, Expr y) {
  final minusT2 = bvNeg(y);
  final s = getSort<BitVecSort>(y);
  final min = s.sMin();
  final a = eq(y, min);
  final zero = s.zero();
  final b = bvSlt(x, zero);
  final c = bvAddNoOverflow(x, minusT2, signed: true);
  return ifThenElse(a, b, c);
}

Expr bvSubNoUnderflow(Expr t1, Expr t2, {required bool signed}) {
  if (signed) {
    final zero = getSort<BitVecSort>(t1).zero();
    final minusT2 = bvNeg(t2);
    final x = bvSlt(zero, t2);
    final y = bvAddNoUnderflow(t1, minusT2);
    return implies(x, y);
  } else {
    return bvUle(t2, t1);
  }
}

Expr bvMulNoOverflow(Expr x, Expr y, {required bool signed}) => BinaryOp(
      signed ? BinaryOpKind.bvSMulNoOverflow : BinaryOpKind.bvUMulNoOverflow,
      x,
      y,
    ).declare();
Expr bvSdivNoOverflow(Expr x, Expr y) {
  final s = getSort<BitVecSort>(x);
  final min = s.msb();
  final a = eq(x, min);
  final b = eq(y, bvFrom(-1, s.size));
  final u = and(a, b);
  return not(u);
}

BinaryOp bvSMulNoUnderflow(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvSMulNoUnderflow, x, y).declare();

Expr setAdd(Expr x, Expr y) => store(x, y, trueExpr);
Expr setDel(Expr x, Expr y) => store(x, y, falseExpr);
BinaryOp setDifference(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.setDifference, x, y).declare();
ArraySelect setMember(Expr x, Expr y) => select(x, y);
BinaryOp setSubset(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.setSubset, x, y).declare();
BinaryOp seqPrefix(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqPrefix, x, y).declare();
BinaryOp seqSuffix(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqSuffix, x, y).declare();
BinaryOp seqContains(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqContains, x, y).declare();
BinaryOp strLt(Expr x, Expr y) => BinaryOp(BinaryOpKind.strLt, x, y).declare();
BinaryOp strLe(Expr x, Expr y) => BinaryOp(BinaryOpKind.strLe, x, y).declare();
BinaryOp seqAt(Expr x, Expr y) => BinaryOp(BinaryOpKind.seqAt, x, y).declare();
BinaryOp seqNth(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqNth, x, y).declare();
BinaryOp seqLastIndex(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqLastIndex, x, y).declare();
BinaryOp seqInRe(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqInRe, x, y).declare();
BinaryOp reRange(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.reRange, x, y).declare();
BinaryOp reDiff(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.reDiff, x, y).declare();
BinaryOp charLe(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.charLe, x, y).declare();
BinaryOp fpaSqrt(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.fpaSqrt, x, y).declare();
BinaryOp fpaRem(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.fpaRem, x, y).declare();
BinaryOp fpaMin(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.fpaMin, x, y).declare();
BinaryOp fpaMax(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.fpaMax, x, y).declare();
BinaryOp fpaLeq(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.fpaLeq, x, y).declare();
BinaryOp fpaLt(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaLt, x, y).declare();
BinaryOp fpaGeq(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.fpaGeq, x, y).declare();
BinaryOp fpaGt(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaGt, x, y).declare();
BinaryOp fpaEq(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaEq, x, y).declare();

TernaryOp ite(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.ite, x, y, z).declare();
TernaryOp ifThenElse(Expr x, Expr y, Expr z) => ite(x, y, z);
TernaryOp store(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.store, x, y, z).declare();
TernaryOp seqExtract(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.seqExtract, x, y, z).declare();
TernaryOp seqReplace(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.seqReplace, x, y, z).declare();
TernaryOp seqIndex(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.seqIndex, x, y, z).declare();
TernaryOp fpaFp(Expr sgn, Expr exp, Expr sig) =>
    TernaryOp(TernaryOpKind.fpaFp, sgn, exp, sig).declare();
TernaryOp fpaAdd(Expr x, Expr y) =>
    TernaryOp(TernaryOpKind.fpaAdd, fpaRne, x, y).declare();
TernaryOp fpaSub(Expr x, Expr y) =>
    TernaryOp(TernaryOpKind.fpaSub, fpaRne, x, y).declare();
TernaryOp fpaMul(Expr x, Expr y) =>
    TernaryOp(TernaryOpKind.fpaMul, fpaRne, x, y).declare();
TernaryOp fpaDiv(Expr x, Expr y) =>
    TernaryOp(TernaryOpKind.fpaDiv, fpaRne, x, y).declare();

NaryOp distinct(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.distinct, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp distinctN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.distinct, args.toList()).declare();
NaryOp and(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.and, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp andN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.and, args.toList()).declare();
NaryOp or(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.or, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp orN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.or, args.toList()).declare();
NaryOp add(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.add, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp addN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.add, args.toList()).declare();
NaryOp mul(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.mul, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp mulN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.mul, args.toList()).declare();
NaryOp sub(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.sub, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp subN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.sub, args.toList()).declare();
NaryOp setUnion(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.setUnion, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp setUnionN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.setUnion, args.toList()).declare();
NaryOp setIntersect(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.setIntersect, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp setIntersectN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.setIntersect, args.toList()).declare();
NaryOp seqConcat(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.seqConcat, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp seqConcatN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.seqConcat, args.toList()).declare();
NaryOp reUnion(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.reUnion, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp reUnionN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.reUnion, args.toList()).declare();
NaryOp reConcat(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.reConcat, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp reConcatN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.reConcat, args.toList()).declare();
NaryOp reIntersect(
  Expr x, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    NaryOp(NaryOpKind.reIntersect, [
      x,
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
NaryOp reIntersectN(Iterable<Expr> args) =>
    NaryOp(NaryOpKind.reIntersect, args.toList()).declare();

App app(
  FuncDecl decl, [
  Expr? x1,
  Expr? x2,
  Expr? x3,
  Expr? x4,
  Expr? x5,
  Expr? x6,
  Expr? x7,
  Expr? x8,
  Expr? x9,
]) =>
    App(decl, [
      if (x1 != null) x1,
      if (x2 != null) x2,
      if (x3 != null) x3,
      if (x4 != null) x4,
      if (x5 != null) x5,
      if (x6 != null) x6,
      if (x7 != null) x7,
      if (x8 != null) x8,
      if (x9 != null) x9,
    ]).declare();
App appN(FuncDecl decl, Iterable<Expr> args) =>
    App(decl, args.toList()).declare();

QuaternaryOp fpaFma(Expr x, Expr y, Expr z, Expr w) =>
    QuaternaryOp(QuaternaryOpKind.fpaFma, x, y, z, w).declare();

PUnaryOp bvSignExt(Expr x, int y) =>
    PUnaryOp(PUnaryOpKind.signExt, x, y).declare();
PUnaryOp bvZeroExt(Expr x, int y) =>
    PUnaryOp(PUnaryOpKind.zeroExt, x, y).declare();
PUnaryOp repeat(Expr x, int y) => PUnaryOp(PUnaryOpKind.repeat, x, y).declare();
PUnaryOp bitToBool(Expr x, int y) =>
    PUnaryOp(PUnaryOpKind.bitToBool, x, y).declare();
PUnaryOp rotateLeft(Expr x, int y) =>
    PUnaryOp(PUnaryOpKind.rotateLeft, x, y).declare();
PUnaryOp rotateRight(Expr x, int y) =>
    PUnaryOp(PUnaryOpKind.rotateRight, x, y).declare();
PUnaryOp intToBv(Expr x, int y) =>
    PUnaryOp(PUnaryOpKind.intToBv, x, y).declare().declare();

BvExtract bvExtract(Expr x, int high, int low) =>
    BvExtract(high, low, x).declare();
BvToInt bvToInt(Expr x, {bool signed = false}) => BvToInt(x, signed).declare();
BvToInt sbvToInt(Expr x, {bool signed = true}) => BvToInt(x, signed).declare();
ArraySelect select(Expr x, Expr index) => ArraySelect(x, [index]).declare();
ArraySelect selectN(Expr array, Iterable<Expr> indices) =>
    ArraySelect(array, indices.toList()).declare();
ArrayStore arrayStore(Expr x, Expr index, Expr value) =>
    ArrayStore(x, [index], value).declare();
ArrayStore arrayStoreN(Expr array, Iterable<Expr> indices, Expr value) =>
    ArrayStore(array, indices.toList(), value).declare();
ArrayMap arrayMap(FuncDecl f, Iterable<Expr> arrays) =>
    ArrayMap(f, arrays.toList()).declare();
AsArray funcAsArray(FuncDecl f) => AsArray(f).declare();
EmptySet emptySet(Sort sort) => EmptySet(sort).declare();
FullSet fullSet(Sort sort) => FullSet(sort).declare();

// Numerals are unlikely to error when constructed so they don't need to be
// automatically declared.

/// Creates a [FloatNumeral] from a [num] value.
FloatNumeral float(num value, FloatSort sort) => FloatNumeral.from(value, sort);

/// Creates a [FloatNumeral] from a [num] value.
FloatNumeral float16(num value) => FloatNumeral.from(value, Float16Sort());

/// Creates a [FloatNumeral] from a [num] value.
FloatNumeral float32(num value) => FloatNumeral.from(value, Float32Sort());

/// Creates a [FloatNumeral] from a [num] value.
FloatNumeral float64(num value) => FloatNumeral.from(value, Float64Sort());

/// Creates a [FloatNumeral] from a [num] value.
FloatNumeral float128(num value) => FloatNumeral.from(value, Float128Sort());

/// Creates a [BitVecNumeral] from an [int] value.
BitVecNumeral bvFrom(int value, [int size = 64]) =>
    BitVecNumeral.from(value, size: size);

/// Creates a [BitVecNumeral] from a [BigInt] value.
BitVecNumeral bvBig(BigInt value, BitVecSort sort) =>
    BitVecNumeral(value, sort);

/// Creates an [IntNumeral] from an [int] value.
IntNumeral intFrom(int value) => IntNumeral.from(value);

/// Creates an [IntNumeral] from a [BigInt] value.
IntNumeral intBig(BigInt value) => IntNumeral(value);

/// Creates a [RatNumeral] from a [Rat] value.
RatNumeral rat(Rat rat) => RatNumeral(rat);

/// Creates a [RatNumeral] from [int] numerator and denominator values.
RatNumeral ratFrom(int n, [int d = 1]) => RatNumeral(Rat.fromInt(n, d));

/// Creates a [Pat] which can be used in quantifiers.
Pat patN(Iterable<Expr> terms) => Pat(terms.toList()).declare();

/// Creates a [Lambda] quantifier.
Lambda lambda(Iterable<ConstVar> args, Expr body) =>
    currentContext.lambdaConst(args.toList(), body).declare();

/// Creates a [Lambda] quantifier, like [lambda] but arguments must manually
/// de-Bruijn indexed.
Lambda lambdaIndexed(Map<String, Sort> args, Expr body) =>
    Lambda(args.map((key, value) => MapEntry(Sym(key), value)), body).declare();

/// Creates a [Exists] quantifier.
Exists exists(
  List<ConstVar> bound,
  Expr body, {
  Expr? when,
  int weight = 0,
  List<Pat> patterns = const [],
  List<Expr> noPatterns = const [],
  Sym? id,
  Sym? skolem,
}) =>
    Exists.bind(
      currentContext,
      bound,
      when == null ? body : implies(when, body),
      weight: weight,
      patterns: patterns,
      noPatterns: noPatterns,
      id: id,
      skolem: skolem,
    ).declare();

/// Creates a [Exists] quantifier, like [exists] but arguments must manually
/// de-Bruijn indexed.
Exists existsIndexed(
  Map<String, Sort> args,
  Expr body, {
  Expr? when,
  int weight = 0,
  Iterable<Pat> patterns = const [],
  Iterable<Expr> noPatterns = const [],
  String? id,
  String? skolem,
}) =>
    Exists(
      args.map((key, value) => MapEntry(Sym(key), value)),
      when == null ? body : implies(when, body),
      weight: weight,
      patterns: patterns.toList(),
      noPatterns: noPatterns.toList(),
      id: id == null ? null : Sym(id),
      skolem: skolem == null ? null : Sym(skolem),
    ).declare();

/// Creates a [Forall] quantifier.
Forall forall(
  List<ConstVar> bound,
  Expr body, {
  Expr? when,
  int weight = 0,
  List<Pat> patterns = const [],
  List<Expr> noPatterns = const [],
  Sym? id,
  Sym? skolem,
}) =>
    Forall.bind(
      currentContext,
      bound,
      when == null ? body : implies(when, body),
      weight: weight,
      patterns: patterns,
      noPatterns: noPatterns,
      id: id,
      skolem: skolem,
    ).declare();

/// Creates a [Forall] quantifier, like [forall] but arguments must manually
/// de-Bruijn indexed.
Forall forallIndexed(
  Map<String, Sort> args,
  Expr body, {
  Expr? when,
  int weight = 0,
  Iterable<Pat> patterns = const [],
  Iterable<Expr> noPatterns = const [],
  String? id,
  String? skolem,
}) =>
    Forall(
      args.map((key, value) => MapEntry(Sym(key), value)),
      when == null ? body : implies(when, body),
      weight: weight,
      patterns: patterns.toList(),
      noPatterns: noPatterns.toList(),
      id: id == null ? null : Sym(id),
      skolem: skolem == null ? null : Sym(skolem),
    ).declare();

/// Creates a de-Bruijn indexed [BoundVar] expression for use in quantifiers.
BoundVar boundVar(int index, Sort sort) => BoundVar(index, sort).declare();

/// Creates a [ConstVar] variable expression.
ConstVar constVar(String name, Sort sort) =>
    ConstVar(Sym(name), sort).declare();

/// Creates a constant array such that all elements are equal to [value].
ConstArray constArray(Sort sort, Expr value) =>
    ConstArray(sort, value).declare();

/// Creates a [Str] expression.
Str str(String value) => Str(value).declare();

/// Creates an empty Seq expression.
EmptySeq emptySeq(Sort sort) => EmptySeq(sort).declare();

/// Creates a Seq expression with a single element.
UnitSeq unitSeq(Sort sort) => UnitSeq(sort).declare();

/// Create a regular expression that accepts all singleton sequences of the
/// regular expression sort.
ReAllchar reAllchar(Sort sort) => ReAllchar(sort).declare();

/// Create a regular expression loop. The supplied regular expression [expr] is
/// repeated between [low] and [high] times. The [low] should be below [high]
/// with one exception: when supplying the value [high] as 0, the meaning is to
/// repeat the argument [expr] at least [low] number of times, and with an
/// unbounded upper bound.
ReLoop reLoop(Expr expr, int low, int high) =>
    ReLoop(expr, low, high).declare();

/// Regular expression power. (?)
RePower rePower(Sort sort, int n) => RePower(sort, n).declare();

/// The regular expression of sort [sort] rejecting every sequence.
ReEmpty reEmpty(Sort sort) => ReEmpty(sort).declare();

/// The regular expression of sort [sort] accepting every sequence.
ReFull reFull(Sort sort) => ReFull(sort).declare();

/// Create a [Char] expression from code point.
Char char(int value) => Char(value).declare();

/// Create the pseudo-boolean relation `p1 + p2 + ... + pn <= k`.
PbAtMost pbAtMost(Iterable<Expr> args, int n) =>
    PbAtMost(args.toList(), n).declare();

/// Create the pseudo-boolean relation `p1 + p2 + ... + pn >= k`.
PbAtLeast pbAtLeast(Iterable<Expr> args, int n) =>
    PbAtLeast(args.toList(), n).declare();

/// Create the pseudo-boolean relation `p1 + p2 + ... + pn <= k`.
Expr pbLe(Map<Expr, int> args, int k) => currentContext.pbLe(args, k).declare();

/// Create the pseudo-boolean relation `p1 + p2 + ... + pn >= k`.
Expr pbGe(Map<Expr, int> args, int k) => currentContext.pbGe(args, k).declare();

/// Create the pseudo-boolean relation `p1 + p2 + ... + pn = k`.
PbEq pbEq(Map<Expr, int> args, int k) => PbEq(args, k).declare();

/// Create a division predicate that is true if [x] divides [y].
Divides divides(int x, Expr y) => Divides(x, y).declare();

/// Create a free (uninterpreted) type with the given [name].
Sort uninterpretedSort(String name) => UninterpretedSort(Sym(name)).declare();

/// The type of booleans.
BoolSort get boolSort => currentContext.boolSort;

/// The type of integers.
IntSort get intSort => currentContext.intSort;

/// The type of real numbers (integers, floats, rationals, irrationals).
RealSort get realSort => currentContext.realSort;

/// The type of strings.
StringSort get stringSort => currentContext.stringSort;

/// The type of characters.
CharSort get charSort => currentContext.charSort;

/// The type of a floating point rounding mode enum.
FpaRoundingModeSort get fpaRoundingModeSort =>
    currentContext.fpaRoundingModeSort;

/// The type of a bit-vector with the given [width].
BitVecSort bvSort(int width) => BitVecSort(width).declare();

/// The type of a finite domain with the given [size], for use in the Datalog
/// engine.
FiniteDomainSort finiteDomainSort(String name, int size) =>
    FiniteDomainSort(Sym(name), size).declare();

/// Creates a constructor used in a datatype declaration.
Constructor constructor(
  String name,
  Map<String, Sort> fields,
) =>
    Constructor(
      Sym(name),
      Sym('is_$name'),
      fields.map((key, value) => MapEntry(Sym(key), value)),
    );

/// The type of a datatype with the given [name] and [constructors].
DatatypeSort datatypeSort(String name, Iterable<Constructor> constructors) =>
    DatatypeSort(Sym(name), constructors.toList()).declare();

/// A forward reference to a datatype with the given [name], used in recursive
/// datatypes.
ForwardRefSort forwardRefSort(String name) =>
    ForwardRefSort(Sym(name)).declare();

/// The type of a sequence of elements of type [sort].
SeqSort seqSort(Sort sort) => SeqSort(sort).declare();

/// The type of a regular expression of sequences of elements of type [sort].
ReSort reSort(Sort sort) => ReSort(sort).declare();

/// The type of a floating point number with the given [ebits] exponent bits and
/// [sbits] significand bits.
FloatSort floatSort(int ebits, int sbits) => FloatSort(ebits, sbits).declare();

/// The type of an IEEE 16-bit floating point number with 5 exponent bits and 11
/// significand bits.
Float16Sort get float16Sort => Float16Sort().declare();

/// The type of an IEEE 32-bit floating point number with 8 exponent bits and 24
/// significand bits.
Float32Sort get float32Sort => Float32Sort().declare();

/// The type of an IEEE 64-bit floating point number with 11 exponent bits and
/// 53 significand bits.
Float64Sort get float64Sort => Float64Sort().declare();

/// The type of an IEEE 128-bit floating point number with 15 exponent bits and
/// 113 significand bits.
Float128Sort get float128Sort => Float128Sort().declare();

/// The sort of a set of elements of type [domain].
SetSort setSort(Sort domain) => SetSort(domain).declare();

/// A reference to a datatype at the index [index], only used in recursive
/// datatypes.
IndexRefSort indexRefSort(int index) => IndexRefSort(index).declare();

/// The type of an array from indices of type [domain] to elements of type
/// [range].
ArraySort arraySort(Sort domain, Sort range) =>
    ArraySort([domain], range).declare();

/// The type of an array from indices of types [domain] to elements of type
/// [range].
ArraySort arraySortN(List<Sort> domain, Sort range) =>
    ArraySort(domain, range).declare();

/// Declare an uninterpreted function with the given [name], [domain], and
/// [range].
Func func(String name, Iterable<Sort> domain, Sort range) =>
    Func(Sym(name), domain.toList(), range).declare();

/// Declare a recursive function with the given [name], [domain], and [range].
///
/// The body of this function should be declared later using
/// [defineRecursiveFunc].
RecursiveFunc recursiveFunc(
  String name,
  Iterable<Sort> domain,
  Sort range,
  Expr? body,
) {
  final result = RecursiveFunc(Sym(name), domain.toList(), range);
  if (body != null) {
    defineRecursiveFunc(result, body);
  }
  return result.declare();
}

/// Define the body of a recursive function declared using [recursiveFunc].
void defineRecursiveFunc(RecursiveFunc func, Expr body) {
  currentContext.defineRecursiveFunc(func, body);
}

/// Gets the [DatatypeInfo] for the given [sort].
DatatypeInfo getDatatypeInfo(DatatypeSort sort) =>
    currentContext.getDatatypeInfo(sort);

/// Declares a tuple with the given [name] and [sorts], the fields of the
/// tuple are named `name$0`, `name$1`, etc.
TupleInfo declareTuple(String name, Iterable<Sort> sorts) =>
    currentContext.declareTuple(
      Sym(name),
      {
        for (var i = 0; i < sorts.length; i++)
          Sym('$name\$$i'): sorts.elementAt(i),
      },
    );

/// Declares a datatype with a `nothing` and `just` constructor for the given
/// [sort], similar to the Haskell `Maybe` type.
MaybeInfo declareMaybe(Sort sort, {String? name}) {
  final info = declareDatatype(
    name ?? 'Maybe ${getSortName(sort)}',
    [
      constructor('nothing', {}),
      constructor('just', {'value': sort}),
    ],
  );
  return MaybeInfo(
    sort: info.sort,
    nothing: ConstVar.func(info.constructors[0].constructor),
    isNothing: info.constructors[0].recognizer,
    just: info.constructors[1].constructor,
    isJust: info.constructors[1].recognizer,
    value: info.constructors[1].accessors[0],
  );
}

/// Declares a tuple with the given [name] and [fields], like [declareTuple]
/// but the fields are explicitly named.
TupleInfo declareTupleNamed(String name, Map<String, Sort> fields) =>
    currentContext.declareTuple(
      Sym(name),
      fields.map((key, value) => MapEntry(Sym(key), value)),
    );

/// Declares an enum with the given [name] and [elements].
EnumInfo declareEnum(String name, Iterable<String> elements) =>
    currentContext.declareEnum(Sym(name), elements.map((e) => Sym(e)).toList());

/// Declares a list with the given [name] and [element] type.
ListInfo declareList(String name, Sort element) =>
    currentContext.declareList(Sym(name), element);

/// Declare mutually recursive datatypes given a map from their name to their
/// constructors.
Map<String, DatatypeInfo> declareDatatypes(
  Map<String, Iterable<Constructor>> datatypes,
) =>
    currentContext
        .declareDatatypes(datatypes.map(
          (key, value) => MapEntry(
            Sym(key),
            value.toList(),
          ),
        ))
        .map((key, value) => MapEntry((key as StringSym).value, value));

/// Declare a datatype with the given [name] and [constructors].
DatatypeInfo declareDatatype(String name, Iterable<Constructor> constructors) =>
    currentContext.declareDatatype(Sym(name), constructors.toList());

/// Declare an AST element in the current context, for most AST elements this
/// is not necessary as they are automatically declared when constructed.
A declare<A extends AST>(A ast) => currentContext.declare(ast);

/// Get the sort of an [Expr].
A getSort<A extends Sort>(Expr value) => currentContext.getSort(value) as A;

/// Get the name of a [Sort].
String getSortName(Sort sort) =>
    (currentContext.getSortName(sort) as StringSym).value;

/// Check if two [Sort]s are equal.
bool sortsEqual(Sort a, Sort b) => currentContext.sortsEqual(a, b);

/// Check if two [FuncDecl]s are equal.
bool funcDeclsEqual(FuncDecl a, FuncDecl b) =>
    currentContext.funcDeclsEqual(a, b);

/// Get the [App] representing an expression, this gives you access to the
/// underlying [FuncDecl] and parameters.
App? getExprApp(Expr expr) => currentContext.getExprApp(expr);

/// Simplifies an expression using basic algebraic rules and constant folding.
A simplify<A extends Expr>(Expr expr, [Params? params]) =>
    currentContext.simplify(expr) as A;

/// Gets a description of all of the available parameters to the simplify
/// function.
ParamDescs get simplifyParamDescriptions =>
    currentContext.simplifyParamDescriptions;

/// Updates the arguments of an [App], [Lambda], [Exists], or [Forall].
A updateTerm<A extends Expr>(A expr, Iterable<Expr> args) =>
    currentContext.updateTerm(expr, args.toList());

/// Substitutes expressions in [expr] where the keys of [substitutions] are
/// replaced with their corresponding values.
A substitute<A extends Expr>(Expr ast, Map<Expr, Expr> substitutions) =>
    currentContext.substitute(ast, substitutions) as A;

/// Substitute [BoundVar]s in [expr] with the expressions in [to].
A substituteVars<A extends Expr>(Expr expr, Iterable<Expr> to) =>
    currentContext.substituteVars(expr, to.toList()) as A;

/// Substitute the arguments to [FuncDecl]s in [expr] with the expressions in
/// [to].
A substituteFuncs<A extends Expr>(
  Expr expr,
  Map<FuncDecl, Expr> substitutions,
) =>
    currentContext.substituteFuncs(expr, substitutions) as A;

/// Sets the [ASTPrintMode] of the current context used in [astToString] and
/// some other places.
void setASTPrintMode(ASTPrintMode mode) => currentContext.setASTPrintMode(mode);

/// Prints an [AST] to a string.
String astToString(AST ast) => currentContext.astToString(ast);

/// Convert the given benchmark into a SMT-LIB string.
String benchmarkToSmtlib({
  required String name,
  required String logic,
  required String status,
  required String attributes,
  required Iterable<AST> assumptions,
  required AST formula,
}) =>
    currentContext.benchmarkToSmtlib(
      name: name,
      logic: logic,
      status: status,
      attributes: attributes,
      assumptions: assumptions.toList(),
      formula: formula,
    );

/// Parse a SMT-LIB string, returning all of its assertions.
List<AST> parse(
  String str, {
  Map<String, Sort> sorts = const {},
  Map<String, FuncDecl> decls = const {},
}) =>
    currentContext.parse(
      str,
      sorts: sorts.map((key, value) => MapEntry(Sym(key), value)),
      decls: decls.map((key, value) => MapEntry(Sym(key), value)),
    );

/// Evaluate an SMT-LIB string, returning the result as a string.
String eval(String str) => currentContext.eval(str);

/// Create a constant probe that always evaluates to [value].
Probe probe(double value) => currentContext.probe(value);

/// Translate the given AST element to another context.
A translateTo<A extends AST>(Context other, A ast) =>
    currentContext.translateTo(other, ast);

/// A map of all of the built in tactics.
Map<String, BuiltinTactic> get builtinTactics => currentContext.builtinTactics;

/// A map of all of the built in probes.
Map<String, BuiltinProbe> get builtinProbes => currentContext.builtinProbes;

/// Creates a solver.
Solver solver({LogicKind? logic, Map<String, Object> params = const {}}) {
  final result = currentContext.solver(logic: logic);
  final paramsObj = currentContext.emptyParams();
  for (final entry in params.entries) {
    paramsObj[entry.key] = entry.value;
  }
  result.setParams(paramsObj);
  return result;
}

/// Create a simple incremental solver.
///
/// This is equivalent to applying the "smt" tactic.
Solver simpleSolver() => currentContext.simpleSolver();

/// Create a context for parsing and evaluating SMT-LIB strings.
ParserContext parser() => currentContext.parser();

/// Create an optimization context.
Optimize optimize({Map<String, Object> params = const {}}) {
  final result = currentContext.optimize();
  final paramsObj = currentContext.emptyParams();
  for (final entry in params.entries) {
    paramsObj[entry.key] = entry.value;
  }
  result.setParams(paramsObj);
  return result;
}

/// Get the algebraic square root of [x].
///
/// This is equivalent to `pow(x, 1 / 2)`.
Expr sqrt(Expr x) => pow(x, ratFrom(1, 2));

/// Get the algebraic [n]th root of [x].
///
/// This is equivalent to `pow(x, 1 / n)`.
Expr root(Expr x, Expr n) => pow(x, div(ratFrom(1), n));

/// Create configuration parameters for various components of Z3.
Params params([Map<String, Object> params = const {}]) {
  final result = currentContext.emptyParams();
  for (final entry in params.entries) {
    result[entry.key] = entry.value;
  }
  return result;
}

final _declaredEnums = Expando<Map<Type, (List<Enum>, EnumInfo)>>();

/// Convert a Dart value to an [Expr].
///
/// This supports the following types:
///
/// * [Expr] (No-op)
/// * [bool]
/// * [int]
/// * [BigInt]
/// * [Rat]
/// * [double]
/// * [String]
/// * [Enum] (Must be declared using [declareEnumValues])
Expr $(Object e) {
  if (e is Expr) {
    return e;
  } else if (e is bool) {
    return e ? currentContext.trueExpr : currentContext.falseExpr;
  } else if (e is int) {
    return intFrom(e);
  } else if (e is BigInt) {
    return intBig(e);
  } else if (e is Rat) {
    return rat(e);
  } else if (e is double) {
    return float64(e);
  } else if (e is String) {
    return str(e);
  } else if (e is Enum) {
    final m = _declaredEnums[currentContext];
    if (m != null && m.containsKey(e.runtimeType)) {
      return m[e.runtimeType]!.$2.constants[Sym(e.name)]!;
    } else {
      throw ArgumentError.value(
        e,
        'e',
        'not declared, try using declareEnumValues',
      );
    }
  }
  throw ArgumentError.value(e, 'e', 'cant be converted to Expr');
}

/// Convert a Dart [Type] to a [Sort].
///
/// This supports the following types:
///
/// * [int]
/// * [BigInt]
/// * [Rat]
/// * [double]
/// * [String]
/// * [bool]
/// * [Enum] (Must be declared using [declareEnumValues])
Sort $s<T>() {
  if (T == int || T == BigInt) {
    return intSort;
  } else if (T == Rat) {
    return realSort;
  } else if (T == double) {
    return float64Sort;
  } else if (T == String) {
    return stringSort;
  } else if (T == bool) {
    return boolSort;
  } else if (<T>[] is List<Enum>) {
    final m = _declaredEnums[currentContext];
    if (m != null && m.containsKey(T)) {
      return m[T]!.$2.sort;
    } else {
      throw ArgumentError.value(
        T,
        'T',
        'not declared, try using declareEnumValues',
      );
    }
  }
  throw ArgumentError.value(T, 'T', 'cant be converted to Sort');
}

/// Declares an enum with the given [values].
///
/// For example:
///
/// ```dart
/// enum Color {
///   red,
///   green,
///   blue,
/// }
///
/// final EnumInfo color = declareEnumValues(Color.values);
/// final Expr x = constVar('x', color.sort);
/// final Expr red = $(Color.red);
/// print('red: ${red.to<Color>()}'); // red: Color.red
/// ```
EnumInfo declareEnumValues(List<Enum> values) {
  final t = values[0].runtimeType;
  final info = declareEnum('$t', values.map((e) => e.name));
  _declaredEnums[currentContext] ??= {};
  _declaredEnums[currentContext]![t] = (values, info);
  return info;
}

/// Extension methods for [AST]s.
extension ASTExtension<A extends AST> on A {
  /// Declare this AST element in the current context if it hasn't already.
  ///
  /// This also forces limited type checking on expressions that don't declare
  /// anything.
  A declare() => currentContext.declare(this);
}

/// Extension methods for [Expr]s.
extension ExprExtension on Expr {
  /// Convert this expression to an [int], requires that this expression is a
  /// [Numeral].
  int toInt() {
    if (this is Numeral) {
      return (this as Numeral).toInt();
    } else {
      throw ArgumentError('cant be converted to int: $this');
    }
  }

  /// Convert this expression to a [BigInt], requires that this expression is a
  /// [Numeral].
  BigInt toBigInt() {
    if (this is Numeral) {
      return (this as Numeral).toBigInt();
    } else {
      throw ArgumentError('cant be converted to BigInt: $this');
    }
  }

  /// Convert this expression to a [Rat], requires that this expression is a
  /// [Numeral].
  Rat toRat() {
    if (this is Numeral) {
      return (this as Numeral).toRat();
    } else {
      throw ArgumentError('cant be converted to Rat: $this');
    }
  }

  /// Convert this expression to a [double], requires that this expression is a
  /// [Numeral].
  double toDouble() {
    if (this is Numeral) {
      return (this as Numeral).toDouble();
    } else {
      throw ArgumentError('cant be converted to double: $this');
    }
  }

  /// Convert this expression to a [bool], requires that this expression is
  /// either [trueExpr] or [falseExpr].
  bool toBool() {
    if (this == currentContext.trueExpr) {
      return true;
    } else if (this == currentContext.falseExpr) {
      return false;
    } else {
      throw ArgumentError('cant be converted to bool: $this');
    }
  }

  /// Convert this expression to a [Map], requires that this expression
  /// constructs a datatype.
  Map<String, Expr> toMap() {
    final app = this;
    if (app is App) {
      final sort = getSort(this);
      if (sort is DatatypeSort) {
        final info = getDatatypeInfo(sort);
        for (var i = 0; i < info.constructors.length; i++) {
          final constructor = info.constructors[i];
          if (currentContext.funcDeclsEqual(
            app.decl,
            constructor.constructor,
          )) {
            final result = <String, Expr>{};
            for (var j = 0; j < constructor.accessors.length; j++) {
              final accessor = constructor.accessors[j];
              result[(accessor.name as StringSym).value] = app.args[j];
            }
            return result;
          }
        }
      }
    }
    throw ArgumentError('cant be converted to Map: $this');
  }

  /// Convert this expression to a [T].
  ///
  /// This supports the following types:
  ///
  /// * [int]
  /// * [BigInt]
  /// * [Rat]
  /// * [double]
  /// * [String]
  /// * [bool]
  /// * [Enum] (Must be declared using [declareEnumValues])
  T to<T>() {
    if (this is T) {
      return this as T;
    } else if (T == int) {
      return toInt() as T;
    } else if (T == BigInt) {
      return toBigInt() as T;
    } else if (T == Rat) {
      return toRat() as T;
    } else if (T == double) {
      return toDouble() as T;
    } else if (T == String) {
      return toString() as T;
    } else if (T == bool) {
      return toBool() as T;
    } else if (this is ConstVar && <T>[] is List<Enum>) {
      final m = _declaredEnums[currentContext];
      if (m != null && m.containsKey(T)) {
        final name = ((this as ConstVar).decl.name as StringSym).value;
        return m[T]!.$1.firstWhere((e) => e.name == name) as T;
      } else {
        throw ArgumentError.value(
          T,
          'T',
          'not declared, try using declareEnumValues',
        );
      }
    }
    throw ArgumentError.value(this, 'this', 'cant be converted to $T');
  }

  /// Indexes an array or tuple expression using the given [index].
  ///
  /// If the array has multiple domains, [index] should be a list of
  /// expressions.
  ///
  /// Note that this operator does not index an array directly, rather it
  /// returns an expression that represents the indexing operation. Pass the
  /// result to [Model.eval] to retrieve a concrete value.
  Expr operator [](Object index) {
    final sort = getSort(this);
    if (sort is ArraySort) {
      if (index is List<Object>) {
        return selectN(this, index.map($));
      } else {
        return select(this, $(index));
      }
    } else if (sort is DatatypeSort) {
      final info = getDatatypeInfo(sort);
      if (info.constructors.length != 1) {
        throw ArgumentError.value(
          this,
          'this',
          'datatype sort has more than one constructor',
        );
      }
      final accessors = info.constructors.single.accessors;
      if (index is Sym) {
        return app(accessors.singleWhere((e) => e.name == index), this);
      } else if (index is int) {
        return app(accessors[index], this);
      } else if (index is String) {
        return app(accessors.singleWhere((e) => e.name == Sym(index)), this);
      } else {
        throw ArgumentError.value(
          index,
          'index',
          'not a valid datatype accessor',
        );
      }
    } else {
      throw ArgumentError.value(this, 'this', 'not an array');
    }
  }

  /// Create a predicate that checks if this expression is greater or equal to
  /// [a] and less than [b].
  Expr between(Object a, Object b) => and(ge(this, $(a)), lt(this, $(b)));

  /// Create a predicate that checks if this expression is greater or equal to
  /// [a] and less than or equal to [b].
  Expr betweenIn(Object a, Object b) => and(ge(this, $(a)), le(this, $(b)));

  /// Boolean AND operator.
  ///
  /// Unfortunately Dart does not support overloading the logical `&&` operator
  /// so be careful about precedence.
  Expr operator &(Object other) => and(this, $(other));

  /// Boolean OR operator.
  ///
  /// Unfortunately Dart does not support overloading the logical `||` operator
  /// so be careful about precedence.
  Expr operator |(Object other) => or(this, $(other));

  /// Boolean XOR operator.
  Expr operator ^(Object other) => xor(this, $(other));

  /// Boolean NOT operator.
  ///
  /// Unfortunately Dart does not support overloading the unary `-` operator
  /// so be careful about precedence.
  Expr operator ~() => not(this);

  /// Arithmetic addition operator.
  Expr operator +(Object other) => add(this, $(other));

  /// Arithmetic subtraction operator.
  Expr operator -(Object other) => sub(this, $(other));

  /// Arithmetic multiplication operator.
  Expr operator *(Object other) => mul(this, $(other));

  /// Arithmetic division operator.
  Expr operator /(Object other) => div(this, $(other));

  /// Arithmetic modulo operator. This is not an euclidean modulo, it is
  /// equivalent to the `%` operator in Dart.
  Expr operator %(Object other) => mod(this, $(other));

  /// Negate this expression.
  Expr operator -() => $(0) - this;

  /// Predicate that checks if this expression is less than [other].
  Expr operator <(Object other) => lt(this, $(other));

  /// Predicate that checks if this expression is less or equal to [other].
  Expr operator <=(Object other) => le(this, $(other));

  /// Predicate that checks if this expression is equal to [other].
  Expr operator >(Object other) => gt(this, $(other));

  /// Predicate that checks if this expression is greater or equal to [other].
  Expr operator >=(Object other) => ge(this, $(other));

  /// Predicate that checks if this expression is equal to [other].
  Expr eq(Object other) => BinaryOp(BinaryOpKind.eq, this, $(other)).declare();

  /// Predicate that checks if this expression is not equal to [other].
  Expr notEq(Object other) => ~eq(other);

  /// Assert that if this expression is true [other] must also be true.
  Expr implies(Object other) =>
      BinaryOp(BinaryOpKind.implies, this, $(other)).declare();

  /// Assert that this expression is true if and only if [other] is true.
  Expr iff(Object other) => BinaryOp(BinaryOpKind.eq, this, $(other)).declare();

  /// If this is true then return [then], otherwise return [other].
  Expr thenElse(Object a, Object b) => ifThenElse(this, $(a), $(b));
}

/// Extension methods for [FuncDecl]s.
extension FuncDeclExtension on FuncDecl {
  /// Call this function with the given arguments.
  App call([
    Object? x1,
    Object? x2,
    Object? x3,
    Object? x4,
    Object? x5,
    Object? x6,
    Object? x7,
    Object? x8,
    Object? x9,
  ]) {
    if (x1 is Iterable<Object> && x2 == null) {
      return appN(this, x1.map($));
    }
    final args = <Expr>[
      if (x1 != null) $(x1),
      if (x2 != null) $(x2),
      if (x3 != null) $(x3),
      if (x4 != null) $(x4),
      if (x5 != null) $(x5),
      if (x6 != null) $(x6),
      if (x7 != null) $(x7),
      if (x8 != null) $(x8),
      if (x9 != null) $(x9),
    ];
    return appN(this, args);
  }
}

/// Extension methods for [Model]s.
extension ModelExtension on Model {
  /// Evaluate an expression in this model.
  Expr operator [](Expr expr) => this.eval(expr);
}

/// Extension methods for [TupleInfo]s.
extension TupleInfoExtension on TupleInfo {
  /// Construct this tuple with the given arguments.
  App call([
    Object? x1,
    Object? x2,
    Object? x3,
    Object? x4,
    Object? x5,
    Object? x6,
    Object? x7,
    Object? x8,
    Object? x9,
  ]) {
    if (x1 is Iterable<Object> && x2 == null) {
      return appN(this.constructor, x1.map($));
    } else if (x1 is Map<String, Object> && x2 == null) {
      return appN(
        this.constructor,
        [
          for (final key in sort.constructors.single.fields.keys)
            $(x1[(key as StringSym).value]!),
        ],
      );
    }
    final args = <Expr>[
      if (x1 != null) $(x1),
      if (x2 != null) $(x2),
      if (x3 != null) $(x3),
      if (x4 != null) $(x4),
      if (x5 != null) $(x5),
      if (x6 != null) $(x6),
      if (x7 != null) $(x7),
      if (x8 != null) $(x8),
      if (x9 != null) $(x9),
    ];
    return appN(this.constructor, args);
  }
}
