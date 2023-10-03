import 'dart:async';

import 'nums.dart';
import 'z3.dart';

T withContext<T>(Context context, T Function() fn) {
  return runZoned(() => fn(), zoneValues: {#z3_context: context});
}

Context? _rootContext;
Context get rootContext => _rootContext ??= Context(Config());
set rootContext(Context context) {
  if (_rootContext != null) {
    throw StateError('Root context already initialized');
  }
  _rootContext = context;
}

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

FloatNumeral float(num value, FloatSort sort) => FloatNumeral.from(value, sort);
FloatNumeral float16(num value) => FloatNumeral.from(value, Float16Sort());
FloatNumeral float32(num value) => FloatNumeral.from(value, Float32Sort());
FloatNumeral float64(num value) => FloatNumeral.from(value, Float64Sort());
FloatNumeral float128(num value) => FloatNumeral.from(value, Float128Sort());

BitVecNumeral bvFrom(int value, [int size = 64]) =>
    BitVecNumeral.from(value, size: size);
BitVecNumeral bvBig(BigInt value, BitVecSort sort) =>
    BitVecNumeral(value, sort);

IntNumeral intFrom(int value) => IntNumeral.from(value);
IntNumeral intBig(BigInt value) => IntNumeral(value);

RatNumeral rat(Rat rat) => RatNumeral(rat);
RatNumeral ratFrom(int n, int d) => RatNumeral(Rat.fromInts(n, d));

Pat patN(Iterable<Expr> terms) => Pat(terms.toList()).declare();
Lambda lambda(Map<String, Sort> args, Expr body) =>
    Lambda(args.map((key, value) => MapEntry(Sym(key), value)), body).declare();
Lambda lambdaConst(Iterable<ConstVar> args, Expr body) =>
    currentContext.lambdaConst(args.toList(), body).declare();
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

BoundVar boundVar(int index, Sort sort) => BoundVar(index, sort).declare();
ConstVar constVar(String name, Sort sort) =>
    ConstVar(Sym(name), sort).declare();
ConstArray constArray(Sort sort, Expr value) =>
    ConstArray(sort, value).declare();
Str str(String value) => Str(value).declare();
EmptySeq emptySeq(Sort sort) => EmptySeq(sort).declare();
UnitSeq unitSeq(Sort sort) => UnitSeq(sort).declare();
ReAllchar reAllchar(Sort sort) => ReAllchar(sort).declare();
ReLoop reLoop(Sort sort, int low, int high) =>
    ReLoop(sort, low, high).declare();
RePower rePower(Sort sort, int n) => RePower(sort, n).declare();
ReEmpty reEmpty(Sort sort) => ReEmpty(sort).declare();
ReFull reFull(Sort sort) => ReFull(sort).declare();
Char char(int value) => Char(value).declare();
PbAtMost pbAtMost(Iterable<Expr> args, int n) =>
    PbAtMost(args.toList(), n).declare();
PbAtLeast pbAtLeast(Iterable<Expr> args, int n) =>
    PbAtLeast(args.toList(), n).declare();
Expr pbLe(Map<Expr, int> args, int k) => currentContext.pbLe(args, k).declare();
Expr pbGe(Map<Expr, int> args, int k) => currentContext.pbGe(args, k).declare();
PbEq pbEq(Map<Expr, int> args, int k) => PbEq(args, k).declare();
Divides divides(int x, Expr y) => Divides(x, y).declare();

Sort uninterpretedSort(String name) => UninterpretedSort(Sym(name)).declare();

BoolSort get boolSort => currentContext.boolSort;
IntSort get intSort => currentContext.intSort;
RealSort get realSort => currentContext.realSort;
StringSort get stringSort => currentContext.stringSort;
CharSort get charSort => currentContext.charSort;
FpaRoundingModeSort get fpaRoundingModeSort =>
    currentContext.fpaRoundingModeSort;
BitVecSort bvSort(int width) => BitVecSort(width).declare();
FiniteDomainSort finiteDomainSort(String name, int size) =>
    FiniteDomainSort(Sym(name), size).declare();
Constructor constructor(
        String name, String recognizer, Map<String, Sort> fields) =>
    Constructor(Sym(name), Sym(recognizer),
        fields.map((key, value) => MapEntry(Sym(key), value)));
DatatypeSort datatypeSort(String name, Iterable<Constructor> constructors) =>
    DatatypeSort(Sym(name), constructors.toList()).declare();
ForwardRefSort forwardRefSort(String name) =>
    ForwardRefSort(Sym(name)).declare();
SeqSort seqSort(Sort sort) => SeqSort(sort).declare();
ReSort reSort(Sort sort) => ReSort(sort).declare();
FloatSort floatSort(int ebits, int sbits) => FloatSort(ebits, sbits).declare();
Float16Sort get float16Sort => Float16Sort().declare();
Float32Sort get float32Sort => Float32Sort().declare();
Float64Sort get float64Sort => Float64Sort().declare();
Float128Sort get float128Sort => Float128Sort().declare();
SetSort setSort(Sort domain) => SetSort(domain).declare();
IndexRefSort indexRefSort(int index) => IndexRefSort(index).declare();
ArraySort arraySort(Sort domain, Sort range) =>
    ArraySort([domain], range).declare();
ArraySort arraySortN(List<Sort> domain, Sort range) =>
    ArraySort(domain, range).declare();

Func func(String name, Iterable<Sort> domain, Sort range) =>
    Func(Sym(name), domain.toList(), range).declare();
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

void defineRecursiveFunc(RecursiveFunc func, Expr body) {
  currentContext.defineRecursiveFunc(func, body);
}

DatatypeInfo getDatatypeInfo(DatatypeSort sort) =>
    currentContext.getDatatypeInfo(sort);
TupleInfo declareTuple(String name, Iterable<Sort> sorts) =>
    currentContext.declareTuple(
      Sym(name),
      {
        for (var i = 0; i < sorts.length; i++)
          Sym('$name\$$i'): sorts.elementAt(i),
      },
    );
TupleInfo declareTupleNamed(String name, Map<String, Sort> fields) =>
    currentContext.declareTuple(
      Sym(name),
      fields.map((key, value) => MapEntry(Sym(key), value)),
    );
EnumInfo declareEnum(String name, Iterable<String> elements) =>
    currentContext.declareEnum(Sym(name), elements.map((e) => Sym(e)).toList());
ListInfo declareList(String name, Sort element) =>
    currentContext.declareList(Sym(name), element);
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
DatatypeInfo declareDatatype(String name, Iterable<Constructor> constructors) =>
    currentContext.declareDatatype(Sym(name), constructors.toList());
A declare<A extends AST>(A ast) => currentContext.declare(ast);
A getSort<A extends Sort>(Expr value) => currentContext.getSort(value) as A;
String getSortName(Sort sort) =>
    (currentContext.getSortName(sort) as StringSym).value;
bool sortsEqual(Sort a, Sort b) => currentContext.sortsEqual(a, b);
bool funcDeclsEqual(FuncDecl a, FuncDecl b) =>
    currentContext.funcDeclsEqual(a, b);
App? getExprApp(Expr expr) => currentContext.getExprApp(expr);
A simplify<A extends Expr>(Expr ast, [Params? params]) =>
    currentContext.simplify(ast) as A;
ParamDescs get simplifyParamDescriptions =>
    currentContext.simplifyParamDescriptions;
A updateTerm<A extends AST>(AST ast, Iterable<AST> args) =>
    currentContext.updateTerm(ast, args.toList()) as A;
A substitute<A extends AST>(AST ast, Iterable<AST> from, Iterable<AST> to) =>
    currentContext.substitute(ast, from.toList(), to.toList()) as A;
A substituteVars<A extends AST>(AST ast, Iterable<AST> to) =>
    currentContext.substituteVars(ast, to.toList()) as A;
A substituteFuncs<A extends AST>(
        AST ast, Iterable<FuncDecl> from, Iterable<AST> to) =>
    currentContext.substituteFuncs(ast, from.toList(), to.toList()) as A;
void setASTPrintMode(ASTPrintMode mode) => currentContext.setASTPrintMode(mode);
String astToString(AST ast) => currentContext.astToString(ast);
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
String eval(String str) => currentContext.eval(str);
Probe probe(double value) => currentContext.probe(value);
A translateTo<A extends AST>(Context other, A ast) =>
    currentContext.translateTo(other, ast);
Map<String, BuiltinTactic> get builtinTactics => currentContext.builtinTactics;
Map<String, BuiltinProbe> get builtinProbes => currentContext.builtinProbes;
Solver solver({LogicKind? logic, Map<String, Object> params = const {}}) {
  final result = currentContext.solver(logic: logic);
  final paramsObj = currentContext.emptyParams();
  for (final entry in params.entries) {
    paramsObj[entry.key] = entry.value;
  }
  result.setParams(paramsObj);
  return result;
}

Solver simpleSolver() => currentContext.simpleSolver();
ParserContext parser() => currentContext.parser();
Optimize optimize() => currentContext.optimize();

Expr sqrt(Expr x) => pow(x, ratFrom(1, 2));
Expr root(Expr x, Expr n) => pow(x, div(intFrom(1), n));

Params params([Map<String, Object> params = const {}]) {
  final result = currentContext.emptyParams();
  for (final entry in params.entries) {
    result[entry.key] = entry.value;
  }
  return result;
}

final _declaredEnums = Expando<Map<Type, (List<Enum>, EnumInfo)>>();

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

EnumInfo declareEnumValues(List<Enum> values) {
  final t = values[0].runtimeType;
  final info = declareEnum('$t', values.map((e) => e.name));
  _declaredEnums[currentContext] ??= {};
  _declaredEnums[currentContext]![t] = (values, info);
  return info;
}

extension ASTExtension<A extends AST> on A {
  A declare() => currentContext.declare(this);
}

extension ExprExtension on Expr {
  int toInt() {
    if (this is Numeral) {
      return (this as Numeral).toInt();
    } else {
      throw ArgumentError('cant be converted to int: $this');
    }
  }

  BigInt toBigInt() {
    if (this is Numeral) {
      return (this as Numeral).toBigInt();
    } else {
      throw ArgumentError('cant be converted to BigInt: $this');
    }
  }

  Rat toRat() {
    if (this is Numeral) {
      return (this as Numeral).toRat();
    } else {
      throw ArgumentError('cant be converted to Rat: $this');
    }
  }

  double toDouble() {
    if (this is Numeral) {
      return (this as Numeral).toDouble();
    } else {
      throw ArgumentError('cant be converted to double: $this');
    }
  }

  bool toBool() {
    if (this == currentContext.trueExpr) {
      return true;
    } else if (this == currentContext.falseExpr) {
      return false;
    } else {
      throw ArgumentError('cant be converted to bool: $this');
    }
  }

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

  Expr between(Object a, Object b) => and(ge(this, $(a)), lt(this, $(b)));

  Expr betweenIn(Object a, Object b) => and(ge(this, $(a)), le(this, $(b)));

  Expr operator &(Object other) => and(this, $(other));
  Expr operator |(Object other) => or(this, $(other));
  Expr operator ^(Object other) => xor(this, $(other));
  Expr operator ~() => not(this);
  Expr operator +(Object other) => add(this, $(other));
  Expr operator -(Object other) => sub(this, $(other));
  Expr operator *(Object other) => mul(this, $(other));
  Expr operator /(Object other) => div(this, $(other));
  Expr operator %(Object other) => mod(this, $(other));
  Expr operator -() => $(0) - this;
  Expr operator <(Object other) => lt(this, $(other));
  Expr operator <=(Object other) => le(this, $(other));
  Expr operator >(Object other) => gt(this, $(other));
  Expr operator >=(Object other) => ge(this, $(other));
  Expr eq(Object other) => BinaryOp(BinaryOpKind.eq, this, $(other)).declare();
  Expr notEq(Object other) => ~eq(other);
  Expr implies(Object other) =>
      BinaryOp(BinaryOpKind.implies, this, $(other)).declare();
  Expr iff(Object other) => BinaryOp(BinaryOpKind.eq, this, $(other)).declare();

  Expr thenElse(Object a, Object b) => ifThenElse(this, $(a), $(b));
}

extension FuncDeclExtension on FuncDecl {
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

extension ModelExtension on Model {
  Expr operator [](Expr expr) => this.eval(expr);
}

extension TupleInfoExtension on TupleInfo {
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
