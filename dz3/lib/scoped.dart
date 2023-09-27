import 'nums.dart';
import 'z3.dart';

NullaryOp get trueExpr => NullaryOp(NullaryOpKind.trueExpr);
NullaryOp get falseExpr => NullaryOp(NullaryOpKind.falseExpr);
NullaryOp get fpaRne => NullaryOp(NullaryOpKind.fpaRne);
NullaryOp get fpaRoundNearestTiesToEven => fpaRne;
NullaryOp get fpaRna => NullaryOp(NullaryOpKind.fpaRna);
NullaryOp get fpaRoundNearestTiesToAway => fpaRna;
NullaryOp get fpaRtp => NullaryOp(NullaryOpKind.fpaRtp);
NullaryOp get fpaRoundTowardPositive => fpaRtp;
NullaryOp get fpaRtn => NullaryOp(NullaryOpKind.fpaRtn);
NullaryOp get fpaRoundTowardNegative => fpaRtn;
NullaryOp get fpaRtz => NullaryOp(NullaryOpKind.fpaRtz);
NullaryOp get fpaRoundTowardZero => fpaRtz;

UnaryOp not(Expr x) => UnaryOp(UnaryOpKind.not, x);
UnaryOp unaryMinus(Expr x) => UnaryOp(UnaryOpKind.unaryMinus, x);
UnaryOp int2real(Expr x) => UnaryOp(UnaryOpKind.int2real, x);
UnaryOp real2int(Expr x) => UnaryOp(UnaryOpKind.real2int, x);
UnaryOp isInt(Expr x) => UnaryOp(UnaryOpKind.isInt, x);
UnaryOp bvNot(Expr x) => UnaryOp(UnaryOpKind.bvNot, x);
UnaryOp bvRedAnd(Expr x) => UnaryOp(UnaryOpKind.bvRedAnd, x);
UnaryOp bvRedOr(Expr x) => UnaryOp(UnaryOpKind.bvRedOr, x);
UnaryOp bvNeg(Expr x) => UnaryOp(UnaryOpKind.bvNeg, x);

Expr bvNegNoOverflow(Expr x) {
  final s = getSort<BitVecSort>(x);
  return notEq(x, s.sMin());
}

Expr arrayDefault(Expr x) => UnaryOp(UnaryOpKind.arrayDefault, x);
Expr setComplement(Expr x) => UnaryOp(UnaryOpKind.setComplement, x);
Expr seqUnit(Expr x) => UnaryOp(UnaryOpKind.seqUnit, x);
Expr seqLength(Expr x) => UnaryOp(UnaryOpKind.seqLength, x);
Expr strToInt(Expr x) => UnaryOp(UnaryOpKind.strToInt, x);
Expr intToStr(Expr x) => UnaryOp(UnaryOpKind.intToStr, x);
Expr strToCode(Expr x) => UnaryOp(UnaryOpKind.strToCode, x);
Expr codeToStr(Expr x) => UnaryOp(UnaryOpKind.codeToStr, x);
Expr ubvToStr(Expr x) => UnaryOp(UnaryOpKind.ubvToStr, x);
Expr sbvToStr(Expr x) => UnaryOp(UnaryOpKind.sbvToStr, x);
Expr seqToRe(Expr x) => UnaryOp(UnaryOpKind.seqToRe, x);
Expr rePlus(Expr x) => UnaryOp(UnaryOpKind.rePlus, x);
Expr reStar(Expr x) => UnaryOp(UnaryOpKind.reStar, x);
Expr reOption(Expr x) => UnaryOp(UnaryOpKind.reOption, x);
Expr reComplement(Expr x) => UnaryOp(UnaryOpKind.reComplement, x);
Expr charToInt(Expr x) => UnaryOp(UnaryOpKind.charToInt, x);
Expr charToBv(Expr x) => UnaryOp(UnaryOpKind.charToBv, x);
Expr bvToChar(Expr x) => UnaryOp(UnaryOpKind.bvToChar, x);
Expr charIsDigit(Expr x) => UnaryOp(UnaryOpKind.charIsDigit, x);
Expr fpaAbs(Expr x) => UnaryOp(UnaryOpKind.fpaAbs, x);
Expr fpaNeg(Expr x) => UnaryOp(UnaryOpKind.fpaNeg, x);
Expr fpaIsNormal(Expr x) => UnaryOp(UnaryOpKind.fpaIsNormal, x);
Expr fpaIsSubnormal(Expr x) => UnaryOp(UnaryOpKind.fpaIsSubnormal, x);
Expr fpaIsZero(Expr x) => UnaryOp(UnaryOpKind.fpaIsZero, x);
Expr fpaIsInfinite(Expr x) => UnaryOp(UnaryOpKind.fpaIsInfinite, x);
Expr fpaIsNaN(Expr x) => UnaryOp(UnaryOpKind.fpaIsNaN, x);
Expr fpaIsNegative(Expr x) => UnaryOp(UnaryOpKind.fpaIsNegative, x);
Expr fpaIsPositive(Expr x) => UnaryOp(UnaryOpKind.fpaIsPositive, x);
Expr fpaToReal(Expr x) => UnaryOp(UnaryOpKind.fpaToReal, x);
Expr fpaToIeeeBv(Expr x) => UnaryOp(UnaryOpKind.fpaToIeeeBv, x);

BinaryOp eq(Expr x, Expr y) => BinaryOp(BinaryOpKind.eq, x, y);
UnaryOp notEq(Expr x, Expr y) => not(eq(x, y));
BinaryOp iff(Expr x, Expr y) => BinaryOp(BinaryOpKind.iff, x, y);
BinaryOp implies(Expr x, Expr y) => BinaryOp(BinaryOpKind.implies, x, y);
BinaryOp xor(Expr x, Expr y) => BinaryOp(BinaryOpKind.xor, x, y);
BinaryOp div(Expr x, Expr y) => BinaryOp(BinaryOpKind.div, x, y);
BinaryOp mod(Expr x, Expr y) => BinaryOp(BinaryOpKind.mod, x, y);
BinaryOp rem(Expr x, Expr y) => BinaryOp(BinaryOpKind.rem, x, y);
BinaryOp pow(Expr x, Expr y) => BinaryOp(BinaryOpKind.pow, x, y);
BinaryOp lt(Expr x, Expr y) => BinaryOp(BinaryOpKind.lt, x, y);
BinaryOp le(Expr x, Expr y) => BinaryOp(BinaryOpKind.le, x, y);
BinaryOp gt(Expr x, Expr y) => BinaryOp(BinaryOpKind.gt, x, y);
BinaryOp ge(Expr x, Expr y) => BinaryOp(BinaryOpKind.ge, x, y);
BinaryOp bvAnd(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvAnd, x, y);
BinaryOp bvOr(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvOr, x, y);
BinaryOp bvXor(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvXor, x, y);
BinaryOp bvNand(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvNand, x, y);
BinaryOp bvNor(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvNor, x, y);
BinaryOp bvXnor(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvXnor, x, y);
BinaryOp bvAdd(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvAdd, x, y);
BinaryOp bvSub(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSub, x, y);
BinaryOp bvMul(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvMul, x, y);
BinaryOp bvUdiv(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUdiv, x, y);
BinaryOp bvSdiv(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSdiv, x, y);
BinaryOp bvUrem(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUrem, x, y);
BinaryOp bvSrem(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSrem, x, y);
BinaryOp bvSmod(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSmod, x, y);
BinaryOp bvUlt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUlt, x, y);
BinaryOp bvSlt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSlt, x, y);
BinaryOp bvUle(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUle, x, y);
BinaryOp bvSle(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSle, x, y);
BinaryOp bvUge(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUge, x, y);
BinaryOp bvSge(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSge, x, y);
BinaryOp bvUgt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvUgt, x, y);
BinaryOp bvSgt(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvSgt, x, y);
BinaryOp bvConcat(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvConcat, x, y);
BinaryOp bvShl(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvShl, x, y);
BinaryOp bvLshr(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvLshr, x, y);
BinaryOp bvAshr(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvAshr, x, y);
BinaryOp bvRotl(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvRotl, x, y);
BinaryOp bvRotr(Expr x, Expr y) => BinaryOp(BinaryOpKind.bvRotr, x, y);

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
    return eq(ex, bvFrom(0, size: 1));
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
    );
Expr bvSdivNoOverflow(Expr x, Expr y) {
  final s = getSort<BitVecSort>(x);
  final min = s.msb();
  final a = eq(x, min);
  final b = eq(y, bvFrom(-1, size: s.size));
  final u = and(a, b);
  return not(u);
}

BinaryOp bvSMulNoUnderflow(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.bvSMulNoUnderflow, x, y);

BinaryOp select(Expr x, Expr y) => BinaryOp(BinaryOpKind.select, x, y);
BinaryOp setAdd(Expr x, Expr y) => BinaryOp(BinaryOpKind.setAdd, x, y);
BinaryOp setDel(Expr x, Expr y) => BinaryOp(BinaryOpKind.setDel, x, y);
BinaryOp setDifference(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.setDifference, x, y);
BinaryOp setMember(Expr x, Expr y) => BinaryOp(BinaryOpKind.setMember, x, y);
BinaryOp setSubset(Expr x, Expr y) => BinaryOp(BinaryOpKind.setSubset, x, y);
BinaryOp seqPrefix(Expr x, Expr y) => BinaryOp(BinaryOpKind.seqPrefix, x, y);
BinaryOp seqSuffix(Expr x, Expr y) => BinaryOp(BinaryOpKind.seqSuffix, x, y);
BinaryOp seqContains(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqContains, x, y);
BinaryOp strLt(Expr x, Expr y) => BinaryOp(BinaryOpKind.strLt, x, y);
BinaryOp strLe(Expr x, Expr y) => BinaryOp(BinaryOpKind.strLe, x, y);
BinaryOp seqAt(Expr x, Expr y) => BinaryOp(BinaryOpKind.seqAt, x, y);
BinaryOp seqNth(Expr x, Expr y) => BinaryOp(BinaryOpKind.seqNth, x, y);
BinaryOp seqLastIndex(Expr x, Expr y) =>
    BinaryOp(BinaryOpKind.seqLastIndex, x, y);
BinaryOp seqInRe(Expr x, Expr y) => BinaryOp(BinaryOpKind.seqInRe, x, y);
BinaryOp reRange(Expr x, Expr y) => BinaryOp(BinaryOpKind.reRange, x, y);
BinaryOp reDiff(Expr x, Expr y) => BinaryOp(BinaryOpKind.reDiff, x, y);
BinaryOp charLe(Expr x, Expr y) => BinaryOp(BinaryOpKind.charLe, x, y);
BinaryOp fpaSqrt(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaSqrt, x, y);
BinaryOp fpaRem(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaRem, x, y);
BinaryOp fpaMin(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaMin, x, y);
BinaryOp fpaMax(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaMax, x, y);
BinaryOp fpaLeq(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaLeq, x, y);
BinaryOp fpaLt(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaLt, x, y);
BinaryOp fpaGeq(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaGeq, x, y);
BinaryOp fpaGt(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaGt, x, y);
BinaryOp fpaEq(Expr x, Expr y) => BinaryOp(BinaryOpKind.fpaEq, x, y);

TernaryOp ite(Expr x, Expr y, Expr z) => TernaryOp(TernaryOpKind.ite, x, y, z);
TernaryOp ifThenElse(Expr x, Expr y, Expr z) => ite(x, y, z);
TernaryOp store(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.store, x, y, z);
TernaryOp seqExtract(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.seqExtract, x, y, z);
TernaryOp seqReplace(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.seqReplace, x, y, z);
TernaryOp seqIndex(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.seqIndex, x, y, z);
TernaryOp fpaFp(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.fpaFp, x, y, z);
TernaryOp fpaAdd(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.fpaAdd, x, y, z);
TernaryOp fpaSub(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.fpaSub, x, y, z);
TernaryOp fpaMul(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.fpaMul, x, y, z);
TernaryOp fpaDiv(Expr x, Expr y, Expr z) =>
    TernaryOp(TernaryOpKind.fpaDiv, x, y, z);

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
    ]);
NaryOp distinctN(List<Expr> args) => NaryOp(NaryOpKind.distinct, args);
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
    ]);
NaryOp andN(List<Expr> args) => NaryOp(NaryOpKind.and, args);
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
    ]);
NaryOp orN(List<Expr> args) => NaryOp(NaryOpKind.or, args);
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
    ]);
NaryOp addN(List<Expr> args) => NaryOp(NaryOpKind.add, args);
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
    ]);
NaryOp mulN(List<Expr> args) => NaryOp(NaryOpKind.mul, args);
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
    ]);
NaryOp subN(List<Expr> args) => NaryOp(NaryOpKind.sub, args);
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
    ]);
NaryOp setUnionN(List<Expr> args) => NaryOp(NaryOpKind.setUnion, args);
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
    ]);
NaryOp setIntersectN(List<Expr> args) => NaryOp(NaryOpKind.setIntersect, args);
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
    ]);
NaryOp seqConcatN(List<Expr> args) => NaryOp(NaryOpKind.seqConcat, args);
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
    ]);
NaryOp reUnionN(List<Expr> args) => NaryOp(NaryOpKind.reUnion, args);
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
    ]);
NaryOp reConcatN(List<Expr> args) => NaryOp(NaryOpKind.reConcat, args);
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
    ]);
NaryOp reIntersectN(List<Expr> args) => NaryOp(NaryOpKind.reIntersect, args);

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
    ]);
App appN(FuncDecl decl, List<Expr> args) => App(decl, args);

QuaternaryOp fpaFma(Expr x, Expr y, Expr z, Expr w) =>
    QuaternaryOp(QuaternaryOpKind.fpaFma, x, y, z, w);

PUnaryOp bvSignExt(Expr x, int y) => PUnaryOp(PUnaryOpKind.signExt, x, y);
PUnaryOp bvZeroExt(Expr x, int y) => PUnaryOp(PUnaryOpKind.zeroExt, x, y);
PUnaryOp repeat(Expr x, int y) => PUnaryOp(PUnaryOpKind.repeat, x, y);
PUnaryOp bitToBool(Expr x, int y) => PUnaryOp(PUnaryOpKind.bitToBool, x, y);
PUnaryOp rotateLeft(Expr x, int y) => PUnaryOp(PUnaryOpKind.rotateLeft, x, y);
PUnaryOp rotateRight(Expr x, int y) => PUnaryOp(PUnaryOpKind.rotateRight, x, y);
PUnaryOp intToBv(Expr x, int y) => PUnaryOp(PUnaryOpKind.intToBv, x, y);

BvExtract bvExtract(Expr x, int high, int low) => BvExtract(high, low, x);
Bv2Int bv2Int(Expr x, {required bool signed}) => Bv2Int(x, signed);
ArraySelect arraySelect(Expr x, Expr index) => ArraySelect(x, [index]);
ArraySelect arraySelectN(Expr array, List<Expr> indices) =>
    ArraySelect(array, indices);
ArrayStore arrayStore(Expr x, Expr index, Expr value) =>
    ArrayStore(x, [index], value);
ArrayStore arrayStoreN(Expr array, List<Expr> indices, Expr value) =>
    ArrayStore(array, indices, value);
ArrayMap arrayMap(FuncDecl f, List<Expr> arrays) => ArrayMap(f, arrays);
AsArray funcAsArray(FuncDecl f) => AsArray(f);
EmptySet emptySet(Sort sort) => EmptySet(sort);
FullSet fullSet(Sort sort) => FullSet(sort);
FloatNumeral float(num value, FloatSort sort) => FloatNumeral.from(value, sort);
FloatNumeral float16(num value) => FloatNumeral.from(value, Float16Sort());
FloatNumeral float32(num value) => FloatNumeral.from(value, Float32Sort());
FloatNumeral float64(num value) => FloatNumeral.from(value, Float64Sort());
FloatNumeral float128(num value) => FloatNumeral.from(value, Float128Sort());

BitVecNumeral bvFrom(int value, {int size = 64}) =>
    BitVecNumeral.from(value, size: size);
BitVecNumeral bigBv(BigInt value, BitVecSort sort) =>
    BitVecNumeral(value, sort);
IntNumeral intFrom(int value) => IntNumeral.from(value);
IntNumeral bigInt(BigInt value) => IntNumeral(value);
RatNumeral rat(Rat rat) => RatNumeral(rat);
RatNumeral ratFrom(int n, int d) => RatNumeral(Rat.fromInts(n, d));
Pat pat(List<Expr> terms) => Pat(terms);
Lambda lambda(Map<String, Sort> args, Expr body) =>
    Lambda(args.map((key, value) => MapEntry(Sym(key), value)), body);
Lambda lambdaConst(List<ConstVar> args, Expr body) =>
    currentContext.lambdaConst(args, body);
Exists exists(
  Map<String, Sort> args,
  Expr body, {
  int weight = 0,
  List<Pat> patterns = const [],
  List<Expr> noPatterns = const [],
  String? id,
  String? skolem,
}) =>
    Exists(
      args.map((key, value) => MapEntry(Sym(key), value)),
      body,
      weight: weight,
      patterns: patterns,
      noPatterns: noPatterns,
      id: id == null ? null : Sym(id),
      skolem: skolem == null ? null : Sym(skolem),
    );
Forall forall(
  Map<String, Sort> args,
  Expr body, {
  int weight = 0,
  List<Pat> patterns = const [],
  List<Expr> noPatterns = const [],
  String? id,
  String? skolem,
}) =>
    Forall(
      args.map((key, value) => MapEntry(Sym(key), value)),
      body,
      weight: weight,
      patterns: patterns,
      noPatterns: noPatterns,
      id: id == null ? null : Sym(id),
      skolem: skolem == null ? null : Sym(skolem),
    );
BoundVar boundVar(int index, Sort sort) => BoundVar(index, sort);
ConstVar constVar(String name, Sort sort) => ConstVar(Sym(name), sort);
ConstArray constArray(Sort sort, Expr value) => ConstArray(sort, value);
Str str(String value) => Str(value);
EmptySeq emptySeq(Sort sort) => EmptySeq(sort);
UnitSeq unitSeq(Sort sort) => UnitSeq(sort);
ReAllchar reAllchar(Sort sort) => ReAllchar(sort);
ReLoop reLoop(Sort sort, int low, int high) => ReLoop(sort, low, high);
RePower rePower(Sort sort, int n) => RePower(sort, n);
ReEmpty reEmpty(Sort sort) => ReEmpty(sort);
ReFull reFull(Sort sort) => ReFull(sort);
Char char(int value) => Char(value);
PbAtMost pbAtMost(List<Expr> args, int n) => PbAtMost(args, n);
PbAtLeast pbAtLeast(List<Expr> args, int n) => PbAtLeast(args, n);
Expr pbLe(Map<Expr, int> args, int k) => currentContext.pbLe(args, k);
Expr pbGe(Map<Expr, int> args, int k) => currentContext.pbGe(args, k);
PbEq pbEq(Map<Expr, int> args, int k) => PbEq(args, k);
Divides divides(int x, Expr y) => Divides(x, y);

Sort uninterpretedSort(String name) => UninterpretedSort(Sym(name));

BoolSort get boolSort => currentContext.boolSort;
IntSort get intSort => currentContext.intSort;
RealSort get realSort => currentContext.realSort;
StringSort get stringSort => currentContext.stringSort;
CharSort get charSort => currentContext.charSort;
FpaRoundingModeSort get fpaRoundingModeSort =>
    currentContext.fpaRoundingModeSort;
BitVecSort bvSort(int width) => BitVecSort(width);
FiniteDomainSort finiteDomainSort(String name, int size) =>
    FiniteDomainSort(Sym(name), size);
Constructor constructor(
        String name, String recognizer, Map<String, Sort> fields) =>
    Constructor(Sym(name), Sym(recognizer),
        fields.map((key, value) => MapEntry(Sym(key), value)));
DatatypeSort datatypeSort(String name, List<Constructor> constructors) =>
    DatatypeSort(Sym(name), constructors);
ForwardRefSort forwardRefSort(String name) => ForwardRefSort(Sym(name));
SeqSort seqSort(Sort sort) => SeqSort(sort);
ReSort reSort(Sort sort) => ReSort(sort);
FloatSort floatSort(int ebits, int sbits) => FloatSort(ebits, sbits);
Float16Sort get float16Sort => Float16Sort();
Float32Sort get float32Sort => Float32Sort();
Float64Sort get float64Sort => Float64Sort();
Float128Sort get float128Sort => Float128Sort();
SetSort setSort(Sort domain) => SetSort(domain);
IndexRefSort indexRefSort(int index) => IndexRefSort(index);

Func func(String name, List<Sort> domain, Sort range) =>
    Func(Sym(name), domain, range);
RecursiveFunc recursiveFunc(
  String name,
  List<Sort> domain,
  Sort range,
  Expr? body,
) {
  final result = RecursiveFunc(Sym(name), domain, range);
  if (body != null) {
    defineRecursiveFunc(result, body);
  }
  return result;
}

void defineRecursiveFunc(RecursiveFunc func, Expr body) {
  currentContext.defineRecursiveFunc(func, body);
}

DatatypeInfo getDatatypeInfo(DatatypeSort sort) =>
    currentContext.getDatatypeInfo(sort);
TupleInfo declareTuple(String name, Map<String, Sort> fields) =>
    currentContext.declareTuple(
        Sym(name), fields.map((key, value) => MapEntry(Sym(key), value)));
EnumInfo declareEnum(String name, List<String> elements) =>
    currentContext.declareEnum(Sym(name), elements.map((e) => Sym(e)).toList());
ListInfo declareList(String name, Sort element) =>
    currentContext.declareList(Sym(name), element);
Map<String, DatatypeInfo> declareDatatypes(
  Map<String, List<Constructor>> datatypes,
) =>
    currentContext
        .declareDatatypes(datatypes.map(
          (key, value) => MapEntry(
            Sym(key),
            value,
          ),
        ))
        .map((key, value) => MapEntry((key as StringSym).value, value));
DatatypeInfo declareDatatype(String name, List<Constructor> constructors) =>
    currentContext.declareDatatype(Sym(name), constructors);
A declare<A extends AST>(A ast) => currentContext.declare(ast);
A getSort<A extends Sort>(Expr value) => currentContext.getSort(value) as A;
String getSortName(Sort sort) =>
    (currentContext.getSortName(sort) as StringSym).value;
bool sortsEqual(Sort a, Sort b) => currentContext.sortsEqual(a, b);
bool funcDeclsEqual(FuncDecl a, FuncDecl b) =>
    currentContext.funcDeclsEqual(a, b);
App? getExprApp(Expr expr) => currentContext.getExprApp(expr);
AST simplify(AST ast, [Params? params]) => currentContext.simplify(ast);
ParamDescriptions get simplifyParamDescriptions =>
    currentContext.simplifyParamDescriptions;
AST updateTerm(AST ast, List<AST> args) => currentContext.updateTerm(ast, args);
AST substitute(AST ast, List<AST> from, List<AST> to) =>
    currentContext.substitute(ast, from, to);
AST substituteVars(AST ast, List<AST> to) =>
    currentContext.substituteVars(ast, to);
AST substituteFuncs(AST ast, List<FuncDecl> from, List<AST> to) =>
    currentContext.substituteFuncs(ast, from, to);
void setASTPrintMode(ASTPrintMode mode) => currentContext.setASTPrintMode(mode);
String astToString(AST ast) => currentContext.astToString(ast);
String benchmarkToSmtlib({
  required String name,
  required String logic,
  required String status,
  required String attributes,
  required List<AST> assumptions,
  required AST formula,
}) =>
    currentContext.benchmarkToSmtlib(
      name: name,
      logic: logic,
      status: status,
      attributes: attributes,
      assumptions: assumptions,
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
Solver solver({LogicKind? logic}) => currentContext.solver(logic: logic);
Solver simpleSolver() => currentContext.simpleSolver();
ParserContext parser() => currentContext.parser();
Optimize optimize() => currentContext.optimize();

Expr sqrt(Expr x) => pow(x, ratFrom(1, 2));
Expr root(Expr x, Expr n) => pow(x, div(intFrom(1), n));
