import 'dart:collection';
import 'dart:ffi';
import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';

import 'nums.dart';
import 'z3_ffi.dart';
import 'z3_ffi.e.dart';

DynamicLibrary? libz3Override;

final _libz3 = Z3Lib(libz3Override ?? DynamicLibrary.open('libz3'));

// Context for trivial math operations that are cheap to translate and don't
// add definitions.
final _mathContext = Context(Config());

var _assertionsEnabled = true;
T _disableAssertions<T>(T Function() fn) {
  if (!_assertionsEnabled) {
    return fn();
  }
  try {
    _mathContext.eval('(set-option :enable-assertions false)');
  } on ContextError catch (e) {
    if (e.message.contains("unknown parameter 'enable_assertions'")) {
      _assertionsEnabled = false;
      return fn();
    }
  }
  _assertionsEnabled = false;
  try {
    return fn();
  } finally {
    _mathContext.eval('(set-option :enable-assertions true)');
    _assertionsEnabled = true;
  }
}

final Version z3GlobalVersion = () {
  final major = calloc<UnsignedInt>();
  final minor = calloc<UnsignedInt>();
  final build = calloc<UnsignedInt>();
  final revision = calloc<UnsignedInt>();
  try {
    _libz3.get_version(major, minor, build, revision);
    final result = Version(
      major.value,
      minor.value,
      build.value,
      pre: revision.value == 0 ? null : 'r$revision',
    );
    return result;
  } finally {
    malloc.free(major);
    malloc.free(minor);
    malloc.free(build);
    malloc.free(revision);
  }
}();

final String z3GlobalFullVersion =
    _libz3.get_full_version().cast<Utf8>().toDartString();

void z3GlobalEnableTrace(String tag) {
  final tagPtr = tag.toNativeUtf8();
  try {
    _libz3.enable_trace(tagPtr.cast());
  } finally {
    malloc.free(tagPtr);
  }
}

void z3GlobalDisableTrace(String tag) {
  final tagPtr = tag.toNativeUtf8();
  try {
    _libz3.disable_trace(tagPtr.cast());
  } finally {
    malloc.free(tagPtr);
  }
}

int z3GlobalGetEstimatedAllocatedMemory() => _libz3.get_estimated_alloc_size();

void z3GlobalOpenLog(File file) {
  final filePtr = file.path.toNativeUtf8();
  try {
    _libz3.open_log(filePtr.cast());
  } finally {
    malloc.free(filePtr);
  }
}

void z3GlobalAppendLog(File file) {
  final filePtr = file.path.toNativeUtf8();
  try {
    _libz3.append_log(filePtr.cast());
  } finally {
    malloc.free(filePtr);
  }
}

void z3GlobalCloseLog() => _libz3.close_log();

void z3GlobalWarningMessages(bool enabled) =>
    _libz3.toggle_warning_messages(enabled);

/// The character encoding of the String and Unicode sorts.
///
/// See [Config.encoding].
enum CharEncoding {
  unicode,
  ascii,
  bmp,
}

enum ParamKind {
  uint,
  bool,
  double,
  symbol,
  string,
  other,
  invalid,
}

enum ASTPrintMode {
  smtlibFull,
  lowLevel,
  smtlib2Compliant,
}

enum GoalPrecision {
  precise,
  under,
  over,
  underOver,
}

enum LogicKind {
  /// Use all logics available.
  all('ALL'),

  /// Difference Logic over the reals. In essence, Boolean combinations of
  /// inequations of the form x - y < b where x and y are real variables and b
  /// is a rational constant.
  qfRdl('QF_RDL'),

  /// Unquantified linear real arithmetic. In essence, Boolean combinations of
  /// inequations between linear polynomials over real variables.
  qfLra('QF_LRA'),

  /// Linear real arithmetic with uninterpreted sort and function symbols.
  uflra('UFLRA'),

  /// Closed linear formulas in linear real arithmetic.
  lra('LRA'),

  /// Difference Logic over the reals (in essence) but with uninterpreted
  /// sort and function symbols.
  rdl('RDL'),

  nra('NRA'),

  /// Quantifier-free real arithmetic.
  qfNra('QF_NRA'),

  /// Unquantified non-linear real arithmetic with uninterpreted sort and
  /// function symbols.
  qfUfnra('QF_UFNRA'),

  /// Unquantified linear real arithmetic with uninterpreted sort and function
  /// symbols.
  qfUflra('QF_UFLRA'),

  /// Unquantified linear integer arithmetic. In essence, Boolean combinations
  /// of inequations between linear polynomials over integer variables.
  qfLia('QF_LIA'),

  /// Difference Logic over the integers. In essence, Boolean combinations of
  /// inequations of the form x - y < b where x and y are integer variables and
  /// b is an integer constant.
  qfIdl('QF_IDL'),

  /// Closed quantifier-free linear formulas over the theory of integer arrays
  /// extended with free sort and function symbols.
  qfAuflia('QF_AUFLIA'),

  qfAlia('QF_ALIA'),

  qfAuflira('QF_AUFLIRA'),

  qfAufnia('QF_AUFNIA'),

  qfAufnira('QF_AUFNIRA'),

  qfAnia('QF_ANIA'),

  qfLira('QF_LIRA'),

  /// Unquantified linear integer arithmetic with uninterpreted sort and
  /// function symbols.
  qfUflia('QF_UFLIA'),

  /// Difference Logic over the integers (in essence) but with uninterpreted
  /// sort and function symbols.
  qfUfidl('QF_UFIDL'),

  qfUfrdl('QF_UFRDL'),

  /// Quantifier-free integer arithmetic.
  qfNia('QF_NIA'),

  qfNira('QF_NIRA'),

  qfUfnia('QF_UFNIA'),

  qfUfnira('QF_UFNIRA'),

  qfBvre('QF_BVRE'),

  alia('ALIA'),

  /// Closed formulas over the theory of linear integer arithmetic and arrays
  /// extended with free sort and function symbols but restricted to arrays with
  /// integer indices and values.
  auflia('AUFLIA'),

  /// Closed linear formulas with free sort and function symbols over one- and
  /// two-dimentional arrays of integer index and real value.
  auflira('AUFLIRA'),

  aufnia('AUFNIA'),

  /// Closed formulas with free function and predicate symbols over a theory of
  /// arrays of arrays of integer index and real value.
  aufnira('AUFNIRA'),

  uflia('UFLIA'),

  ufnra('UFNRA'),

  ufnira('UFNIRA'),

  nia('NIA'),

  /// Non-linear integer arithmetic with uninterpreted sort and function
  /// symbols.
  ufnia('UFNIA'),

  /// Closed linear formulas over linear integer arithmetic.
  lia('LIA'),

  ufidl('UFIDL'),

  qfFp('QF_FP'),

  fp('FP'),

  qfFpbv('QF_FPBV'),

  qfBvfp('QF_BVFP'),

  qfS('QF_S'),

  qfSlia('QF_SLIA'),

  qfFd('QF_FD'),

  horn('HORN'),

  qfFplra('QF_FPLRA'),

  ufbv('UFBV'),

  aufbv('AUFBV'),

  abv('ABV'),

  bv('BV'),

  /// Closed quantifier-free formulas over the theory of fixed-size bitvectors.
  qfBv('QF_BV'),

  /// Unquantified formulas over bitvectors with uninterpreted sort function and
  /// symbols.
  qfUfbv('QF_UFBV'),

  /// Closed quantifier-free formulas over the theory of bitvectors and
  /// bitvector arrays.
  qfAbv('QF_ABV'),

  /// Closed quantifier-free formulas over the theory of bitvectors and
  /// bitvector arrays extended with free sort and function symbols.
  qfAufbv('QF_AUFBV'),

  smtfd('SMTFD'),

  /// Closed quantifier-free formulas over the theory of arrays with
  /// extensionality.
  qfAx('QF_AX'),

  /// Unquantified formulas built over a signature of uninterpreted (i.e., free)
  /// sort and function symbols.
  qfUf('QF_UF'),

  uf('UF'),

  qfUfdt('QF_UFDT'),

  qfDt('QF_DT');

  const LogicKind(this.smtlibName);

  final String smtlibName;
}

@immutable
abstract class Sym {
  const factory Sym(String value) = StringSym;
  const Sym._();
}

class IntSym extends Sym {
  const IntSym(this.value) : super._();
  final int value;
  @override
  String toString() => '$value';
  @override
  bool operator ==(Object other) => other is IntSym && other.value == value;
  @override
  int get hashCode => value.hashCode;
}

class StringSym extends Sym {
  const StringSym(this.value) : super._();
  final String value;
  @override
  String toString() => value;
  @override
  bool operator ==(Object other) => other is StringSym && other.value == value;
  @override
  int get hashCode => value.hashCode;
}

abstract class ConfigBase {
  final _overridden = <String, String>{};

  String? operator [](String key) => _overridden[key];
  operator []=(String key, String value) {
    _overridden[key] = value;
  }

  /// The maximum amount of time to spend searching for a solution.
  ///
  /// Defaults to 4294967295 (UINT_MAX).
  set timeout(Duration duration) =>
      this['timeout'] = '${duration.inMilliseconds}';

  /// Resource limit on solver, resources are counted arbitrarily by the solver
  /// but should always be consumed over time.
  ///
  /// Defaults to no limit (0).
  set rlimit(int value) => this['rlimit'] = '$value';

  /// Whether to do type checking.
  ///
  /// Defaults to true.
  set typeCheck(bool value) => this['type_check'] = '$value';

  /// Whether to do type checking, same as [typeCheck].
  ///
  /// Defaults to true.
  set wellSortedCheck(bool value) => this['well_sorted_check'] = '$value';

  /// Whether to use heuristics to automatically select solver and configure it.
  ///
  /// Defaults to true.
  set autoConfig(bool value) => this['auto_config'] = '$value';

  /// Whether proofs can be constructed.
  ///
  /// Defaults to false.
  set proof(bool value) => this['proof'] = '$value';

  /// Whether model generation is enabled.
  ///
  /// Defaults to true.
  set model(bool value) => this['model'] = '$value';

  /// Whether models should be validated after solving.
  ///
  /// Defaults to false.
  set modelValidate(bool value) => this['model_validate'] = '$value';

  /// Whether to dump models whenever check-sat returns sat.
  ///
  /// Defaults to false.
  set dumpModels(bool value) => this['dump_models'] = '$value';

  /// Whether to enable statistics.
  ///
  /// Defaults to false.
  set stats(bool value) => this['stats'] = '$value';

  /// Whether to log trace messages.
  ///
  /// Defaults to false.
  set trace(bool value) => this['trace'] = '$value';

  /// What file to store the trace messages in.
  ///
  /// Defaults to 'z3.log'.
  set traceFileName(File file) => this['trace_file_name'] = file.path;

  /// The file to output graphical proofs.
  ///
  /// Defaults to 'proof.dot'.
  set dotProofFile(File file) => this['dot_proof_file'] = file.path;

  /// Whether we can obtain unsatisfiable cores with `get-unsat-core`.
  ///
  /// Defaults to false.
  set unsatCore(bool value) => this['unsat_core'] = '$value';

  /// Debugging for the AST reference counter.
  ///
  /// Defaults to false.
  set debugRefCount(bool value) => this['debug_ref_count'] = '$value';

  /// Enables strict compliance with the SMT-LIB 2.0 standard.
  ///
  /// Defaults to false.
  set smtlib2Compliant(bool value) => this['smtlib2_compliant'] = '$value';

  /// Character encoding of the String and Unicode sorts.
  ///
  /// Defaults to [CharEncoding.unicode].
  set encoding(CharEncoding value) => this['encoding'] = value.name;
  CharEncoding get encoding =>
      CharEncoding.values.firstWhere((e) => e.name == this['encoding'],
          orElse: () => CharEncoding.unicode);
}

/// Configuration for a [Context].
class Config extends ConfigBase {
  Config() {
    _finalizer.attach(this, _config);
  }

  final _config = _libz3.mk_config();
  static final _finalizer = Finalizer<Z3_config>(_libz3.del_config);

  @override
  operator []=(String key, String value) {
    final keyPtr = key.toNativeUtf8();
    final valuePtr = value.toNativeUtf8();
    try {
      _libz3.set_param_value(_config, keyPtr.cast(), valuePtr.cast());
    } finally {
      malloc.free(keyPtr);
      malloc.free(valuePtr);
    }
  }
}

class ContextConfig extends ConfigBase {
  ContextConfig._(this._context);
  final Context _context;

  @override
  void operator []=(String key, String value) {
    final keyPtr = key.toNativeUtf8();
    final valuePtr = value.toNativeUtf8();
    try {
      _context._z3.update_param_value(keyPtr.cast(), valuePtr.cast());
    } finally {
      malloc.free(keyPtr);
      malloc.free(valuePtr);
    }
  }
}

class Registry<H extends Object, P extends Pointer> {
  Registry(this.acquire, this.release);

  final to = Expando<P>();
  final from = <P, WeakReference<H>>{};
  final void Function(P value) acquire;
  final void Function(P value) release;
  late final finalizer = Finalizer<P>((v) {
    if (from.remove(v) != null) {
      release(v);
    }
  });

  P? getPtr(H key) => to[key];
  H? getHandle(P value) => from[value]?.target;

  P putHandle(H key, P Function() f) {
    final existing = to[key];
    if (existing != null) {
      return existing;
    }
    final value = f();
    if (value == nullptr) {
      throw AssertionError('Builder returned null: $key');
    }
    if (from.containsKey(value)) {
      return value;
    }
    acquire(value);
    to[key] = value;
    from[value] = WeakReference(key);
    finalizer.attach(key, value);
    return value;
  }

  H putPtr(P value, H Function() f) {
    if (value == nullptr) {
      throw AssertionError('Value is null');
    }
    final existing = from[value]?.target;
    if (existing != null) {
      return existing;
    }
    final key = f();
    if (to[key] != null) {
      return key;
    }
    acquire(value);
    to[key] = value;
    from[value] = WeakReference(key);
    finalizer.attach(key, value);
    return key;
  }

  void clear() {
    from.keys.forEach(release);
    from.clear();
  }
}

/// The kind of error that occurred in a [ContextError].
enum ContextErrorKind {
  /// User tried to build an invalid AST.
  sortError,

  /// Index out of bounds.
  outOfBounds,

  /// Invalid argument was passed to a function.
  invalidArg,

  /// An error occurred while parsing a string or file.
  parserError,

  /// Parser output is not available.
  noParser,

  /// An invalid pattern was used to build a quantifier.
  invalidPattern,

  /// A memory allocation failure was encountered.
  memoutFail,

  /// A file could not be accessed.
  fileAccessError,

  /// API call is invalid in the current state.
  invalidUsage,

  /// A fatal error internal to Z3 occurred.
  internalFatal,

  /// There was an error decrementing the reference count of an AST.
  decRefError,

  /// An unknown error occured, more details may be available in the message.
  unknown,
}

class ContextError extends Error {
  ContextError(this.context, this.kind, this.message, {this.additional});

  final Context context;
  final ContextErrorKind kind;
  final String message;
  final ContextError? additional;

  @override
  String toString() =>
      'ContextError${kind == ContextErrorKind.unknown ? '' : '(${kind.name})'}: $message'
      '${additional == null ? '' : 'additional \n$additional'}';
}

class Context {
  Context(this._originalConfig)
      : _context = _libz3.mk_context_rc(_originalConfig._config) {
    _finalizer.attach(this, _context);
    _instances[_context] = WeakReference(this);
    _libz3.set_error_handler(_context, Pointer.fromFunction(_errorHandler));
  }

  late final _z3 = Z3LibWrapper(_libz3, _context, _checkError);

  static void _errorHandler(Z3_context c, int e) {
    var kind = ContextErrorKind.unknown;
    switch (e) {
      case (Z3_error_code.SORT_ERROR):
        kind = ContextErrorKind.sortError;
        break;
      case (Z3_error_code.IOB):
        kind = ContextErrorKind.outOfBounds;
        break;
      case (Z3_error_code.INVALID_ARG):
        kind = ContextErrorKind.invalidArg;
        break;
      case (Z3_error_code.PARSER_ERROR):
        kind = ContextErrorKind.parserError;
        break;
      case (Z3_error_code.NO_PARSER):
        kind = ContextErrorKind.noParser;
        break;
      case (Z3_error_code.INVALID_PATTERN):
        kind = ContextErrorKind.invalidPattern;
        break;
      case (Z3_error_code.MEMOUT_FAIL):
        kind = ContextErrorKind.memoutFail;
        break;
      case (Z3_error_code.FILE_ACCESS_ERROR):
        kind = ContextErrorKind.fileAccessError;
        break;
      case (Z3_error_code.INTERNAL_FATAL):
        kind = ContextErrorKind.internalFatal;
        break;
      case (Z3_error_code.DEC_REF_ERROR):
        kind = ContextErrorKind.decRefError;
        break;
    }
    final reason = _libz3.get_error_msg(c, e).cast<Utf8>().toDartString();
    final context = _instances[c]?.target;
    final err = ContextError(
      context!,
      kind,
      reason,
      additional: context._pendingError,
    );
    context._pendingError = err;
  }

  ContextError? _pendingError;

  final _finalizer = Finalizer<Z3_context>((c) {
    _libz3.del_context(c);
    _instances.remove(c);
  });
  static final _instances = <Z3_context, WeakReference<Context>>{};

  final Config _originalConfig;
  final Z3_context _context;
  final _symbols = <Z3_symbol, Sym>{};
  late final config = ContextConfig._(this)
    .._overridden.addAll(_originalConfig._overridden);
  late final _astReg = Registry<AST, Z3_ast>(_z3.inc_ref, _z3.dec_ref);
  late final _paramDescriptionsReg = Registry<ParamDescs, Z3_param_descrs>(
      _z3.param_descrs_inc_ref, _z3.param_descrs_dec_ref);
  late final _modelReg =
      Registry<Model, Z3_model>(_z3.model_inc_ref, _z3.model_dec_ref);
  late final _funcInterpReg = Registry<FuncInterp, Z3_func_interp>(
      _z3.func_interp_inc_ref, _z3.func_interp_dec_ref);
  late final _funcEntryReg = Registry<FuncEntry, Z3_func_entry>(
      _z3.func_entry_inc_ref, _z3.func_entry_dec_ref);
  late final _parserContextReg = Registry<ParserContext, Z3_parser_context>(
      _z3.parser_context_inc_ref, _z3.parser_context_dec_ref);
  late final _goalReg =
      Registry<Goal, Z3_goal>(_z3.goal_inc_ref, _z3.goal_dec_ref);
  late final _tacticReg =
      Registry<Tactic, Z3_tactic>(_z3.tactic_inc_ref, _z3.tactic_dec_ref);
  late final _probeReg =
      Registry<Probe, Z3_probe>(_z3.probe_inc_ref, _z3.probe_dec_ref);
  late final _applyResultReg = Registry<ApplyResult, Z3_apply_result>(
      _z3.apply_result_inc_ref, _z3.apply_result_dec_ref);
  late final _solverReg =
      Registry<Solver, Z3_solver>(_z3.solver_inc_ref, _z3.solver_dec_ref);
  late final _statsReg =
      Registry<Stats, Z3_stats>(_z3.stats_inc_ref, _z3.stats_dec_ref);
  late final _optimizeReg = Registry<Optimize, Z3_optimize>(
      _z3.optimize_inc_ref, _z3.optimize_dec_ref);

  Z3_ast _createAST(AST ast) => _astReg.putHandle(ast, () => ast.build(this));
  Z3_sort _createSort(Sort sort) => _createAST(sort).cast();
  Z3_func_decl _createFuncDecl(FuncDecl funcDecl) =>
      _createAST(funcDecl).cast();
  Z3_pattern _createPattern(Pat pattern) => _createAST(pattern).cast();

  Z3_ast _translateTo(Context other, AST handle, Z3_ast ast) {
    if (other == this) {
      return ast;
    }
    return other._astReg.putHandle(
      handle,
      () => _libz3.translate(_context, ast, other._context),
    );
  }

  List<Expr> _getAppArgs(Z3_app app) {
    final numArgs = _z3.get_app_num_args(app);
    final args = <Expr>[];
    for (var i = 0; i < numArgs; i++) {
      final arg = _z3.get_app_arg(app, i);
      args.add(_getAST(arg) as Expr);
    }
    return args;
  }

  AST _getAST(Z3_ast ast) {
    if (ast == nullptr) {
      throw ArgumentError.notNull('ast');
    }
    _z3.inc_ref(ast);
    try {
      var handle = _astReg.getHandle(ast);
      if (handle != null) {
        return handle;
      }
      final kind = _z3.get_ast_kind(ast);
      switch (kind) {
        case Z3_ast_kind.NUMERAL_AST:
        case Z3_ast_kind.APP_AST:
          final Z3_app app = ast.cast();
          final appDecl = _z3.get_app_decl(app);
          final decl = _getFuncDecl(appDecl);
          final sort = _getSort(_z3.get_sort(ast));
          if (decl.kind == FuncKind.anum) {
            if (sort is RealSort) {
              handle = RatNumeral._(
                this,
                ast,
                sort,
                Rat.parse(
                  _z3.get_numeral_string(ast).cast<Utf8>().toDartString(),
                ),
              );
            } else {
              assert(sort is IntSort);
              handle = IntNumeral._(
                this,
                ast,
                BigInt.parse(
                  _z3.get_numeral_string(ast).cast<Utf8>().toDartString(),
                ),
              );
            }
          } else if (decl.kind == FuncKind.agnum) {
            handle = IrrationalNumeral._(this, ast, sort);
          } else if (decl.kind == FuncKind.bnum) {
            handle = BitVecNumeral._(
              this,
              ast,
              sort as BitVecSort,
              BigInt.parse(
                _z3.get_numeral_string(ast).cast<Utf8>().toDartString(),
              ),
            );
          } else if (decl.kind == FuncKind.fpaNum ||
              decl.kind == FuncKind.fpaPlusZero) {
            handle = FloatNumeral._(
              this,
              ast,
              sort as FloatSort,
              _z3.get_numeral_double(ast),
              _z3.fpa_is_numeral_negative(ast),
            );
          } else {
            final args = _getAppArgs(app);
            final NullaryOpKind? nullaryOpKind;
            final UnaryOpKind? unaryOpKind;
            final PUnaryOpKind? pUnaryOpKind;
            final BinaryOpKind? binaryOpKind;
            final TernaryOpKind? ternaryOpKind;
            final QuaternaryOpKind? quaternaryOpKind;
            final NaryOpKind? naryOpKind;
            if ((nullaryOpKind = NullaryOpKind._fromFuncKind(decl.kind)) !=
                null) {
              assert(args.isEmpty);
              assert(decl.parameters.isEmpty);
              handle = NullaryOp(nullaryOpKind!);
            } else if ((unaryOpKind = UnaryOpKind._fromFuncKind(decl.kind)) !=
                null) {
              assert(args.length == 1);
              assert(decl.parameters.isEmpty);
              handle = UnaryOp(unaryOpKind!, args[0]);
            } else if ((pUnaryOpKind = PUnaryOpKind._fromFuncKind(decl.kind)) !=
                null) {
              assert(args.length == 1);
              handle = PUnaryOp(
                pUnaryOpKind!,
                args[0],
                decl.parameters.single as int,
              );
            } else if ((binaryOpKind = BinaryOpKind._fromFuncKind(decl.kind)) !=
                null) {
              assert(args.length == 2);
              assert(decl.parameters.isEmpty);
              handle = BinaryOp(binaryOpKind!, args[0], args[1]);
            } else if ((ternaryOpKind =
                    TernaryOpKind._fromFuncKind(decl.kind)) !=
                null) {
              assert(args.length == 3);
              assert(decl.parameters.isEmpty);
              handle = TernaryOp(ternaryOpKind!, args[0], args[1], args[2]);
            } else if ((quaternaryOpKind =
                    QuaternaryOpKind._fromFuncKind(decl.kind)) !=
                null) {
              assert(args.length == 4);
              assert(decl.parameters.isEmpty);
              handle = QuaternaryOp(
                quaternaryOpKind!,
                args[0],
                args[1],
                args[2],
                args[3],
              );
            } else if ((naryOpKind = NaryOpKind._fromFuncKind(decl.kind)) !=
                null) {
              assert(decl.parameters.isEmpty);
              handle = NaryOp(naryOpKind!, args);
            } else {
              handle = App(decl, args);
            }
          }
        case Z3_ast_kind.VAR_AST:
          final sort = _getSort(_z3.get_sort(ast));
          return BoundVar(_z3.get_index_value(ast), sort);
        case Z3_ast_kind.QUANTIFIER_AST:
          final isExists = _z3.is_quantifier_exists(ast);
          if (isExists || _z3.is_quantifier_forall(ast)) {
            final weight = _z3.get_quantifier_weight(ast);
            final patterns = <Pat>[];
            final numPatterns = _z3.get_quantifier_num_patterns(ast);
            for (var i = 0; i < numPatterns; i++) {
              final pattern = _z3.get_quantifier_pattern_ast(ast, i);
              patterns.add(_getAST(pattern.cast()) as Pat);
            }
            final noPatterns = <Expr>[];
            final numNoPatterns = _z3.get_quantifier_num_no_patterns(ast);
            for (var i = 0; i < numNoPatterns; i++) {
              final noPattern = _z3.get_quantifier_no_pattern_ast(ast, i);
              noPatterns.add(_getAST(noPattern.cast()) as Expr);
            }
            final numBound = _z3.get_quantifier_num_bound(ast);
            final bound = <Sym, Sort>{};
            for (var i = 0; i < numBound; i++) {
              final name = _z3.get_quantifier_bound_name(ast, i);
              final sort = _getSort(_z3.get_quantifier_bound_sort(ast, i));
              bound[Sym(name.cast<Utf8>().toDartString())] = sort;
            }
            final body = _getAST(_z3.get_quantifier_body(ast).cast()) as Expr;
            if (isExists) {
              return Exists(
                bound,
                body,
                weight: weight,
                patterns: patterns,
                noPatterns: noPatterns,
              );
            } else {
              return Forall(
                bound,
                body,
                weight: weight,
                patterns: patterns,
                noPatterns: noPatterns,
              );
            }
          } else {
            assert(_z3.is_lambda(ast));
            final bound = <Sym, Sort>{};
            final numBound = _z3.get_quantifier_num_bound(ast);
            for (var i = 0; i < numBound; i++) {
              final name = _z3.get_quantifier_bound_name(ast, i);
              final sort = _getSort(_z3.get_quantifier_bound_sort(ast, i));
              bound[Sym(name.cast<Utf8>().toDartString())] = sort;
            }
            final body = _getAST(_z3.get_quantifier_body(ast).cast()) as Expr;
            return Lambda(bound, body);
          }
        case Z3_ast_kind.SORT_AST:
          final Z3_sort sort = ast.cast();
          final sortKind = _z3.get_sort_kind(sort);
          switch (sortKind) {
            case Z3_sort_kind.UNINTERPRETED_SORT:
              final name = _z3.get_sort_name(sort);
              handle = UninterpretedSort(_getSymbol(name));
            case Z3_sort_kind.BOOL_SORT:
              handle = BoolSort();
            case Z3_sort_kind.INT_SORT:
              handle = IntSort();
            case Z3_sort_kind.REAL_SORT:
              handle = RealSort();
            case Z3_sort_kind.BV_SORT:
              final size = _z3.get_bv_sort_size(sort);
              handle = BitVecSort(size);
            case Z3_sort_kind.ARRAY_SORT:
              final domains = <Sort>[];
              for (var i = 0;; i++) {
                try {
                  domains.add(_getSort(_z3.get_array_sort_domain_n(sort, i)));
                } on ContextError catch (e) {
                  if (e.kind == ContextErrorKind.invalidArg && i > 0) {
                    break;
                  }
                  rethrow;
                }
              }
              final range = _getSort(_z3.get_array_sort_range(sort));
              handle = ArraySort(domains, range);
            case Z3_sort_kind.DATATYPE_SORT:
              final name = _z3.get_sort_name(sort);
              // Forward declare since it may be recursive
              final datatypeSort = DatatypeSort._(_getSymbol(name));
              handle = datatypeSort;
              _astReg.putPtr(ast, () => handle!);
              final numConstructors =
                  _z3.get_datatype_sort_num_constructors(sort);
              final constructors = <Constructor>[];
              for (var i = 0; i < numConstructors; i++) {
                final constructor = _z3.get_datatype_sort_constructor(sort, i);
                final constructorName = _z3.get_decl_name(constructor);
                final recognizer = _z3.get_datatype_sort_recognizer(sort, i);
                final recognizerName = _z3.get_decl_name(recognizer);
                final numAccessors = _z3.get_arity(constructor);
                final accessors = <Sym, Sort>{};
                for (var j = 0; j < numAccessors; j++) {
                  final accessor =
                      _z3.get_datatype_sort_constructor_accessor(sort, i, j);
                  final accessorName = _z3.get_decl_name(accessor);
                  final accessorSort = _getSort(_z3.get_range(accessor));
                  accessors[_getSymbol(accessorName)] = accessorSort;
                }
                constructors.add(Constructor(
                  _getSymbol(constructorName),
                  _getSymbol(recognizerName),
                  accessors,
                ));
              }
              datatypeSort._constructors = constructors;
              return handle;
            case Z3_sort_kind.FINITE_DOMAIN_SORT:
              final sizePtr = calloc<Uint64>();
              try {
                _z3.get_finite_domain_sort_size(sort, sizePtr);
                final size = sizePtr.value;
                final name = _z3.get_sort_name(sort);
                handle = FiniteDomainSort(_getSymbol(name), size);
              } finally {
                malloc.free(sizePtr);
              }
            case Z3_sort_kind.FLOATING_POINT_SORT:
              final ebits = _z3.fpa_get_ebits(sort);
              final sbits = _z3.fpa_get_sbits(sort);
              handle = FloatSort(ebits, sbits);
            case Z3_sort_kind.ROUNDING_MODE_SORT:
              return FpaRoundingModeSort();
            case Z3_sort_kind.SEQ_SORT:
              final basis = _z3.get_seq_sort_basis(sort);
              handle = SeqSort(_getSort(basis));
            case Z3_sort_kind.RE_SORT:
              final basis = _z3.get_re_sort_basis(sort);
              handle = ReSort(_getSort(basis));
            case Z3_sort_kind.CHAR_SORT:
              handle = charSort;
            case Z3_sort_kind.UNKNOWN_SORT:
            default:
              handle = UnknownSort._(this, ast);
          }
        case Z3_ast_kind.FUNC_DECL_AST:
          final Z3_func_decl funcDecl = ast.cast();
          final numParameters = _z3.get_decl_num_parameters(funcDecl);
          final parameters = <Parameter>[];
          for (var i = 0; i < numParameters; i++) {
            // get_decl_parameter_kind throws an assertion when encountering
            // PARAM_EXTERNAL, so we disable assertions temporarily /shrug
            final declKind = _disableAssertions(
              () => _libz3.get_decl_parameter_kind(_context, funcDecl, i),
            );
            switch (declKind) {
              case Z3_parameter_kind.PARAMETER_INT:
                final value = _z3.get_decl_int_parameter(funcDecl, i);
                parameters.add(value);
              case Z3_parameter_kind.PARAMETER_DOUBLE:
                final value = _z3.get_decl_double_parameter(funcDecl, i);
                parameters.add(value);
              case Z3_parameter_kind.PARAMETER_RATIONAL:
                final value = _z3.get_decl_rational_parameter(funcDecl, i);
                parameters.add(Rat.parse(value.cast<Utf8>().toDartString()));
              case Z3_parameter_kind.PARAMETER_SYMBOL:
                final symbol = _z3.get_decl_symbol_parameter(funcDecl, i);
                parameters.add(_getSymbol(symbol));
              case Z3_parameter_kind.PARAMETER_SORT:
                final value = _z3.get_decl_sort_parameter(funcDecl, i);
                parameters.add(_getSort(value));
              case Z3_parameter_kind.PARAMETER_AST:
                final value = _z3.get_decl_ast_parameter(funcDecl, i);
                parameters.add(_getAST(value));
              case Z3_parameter_kind.PARAMETER_FUNC_DECL:
                late final Z3_func_decl value;
                try {
                  value = _z3.get_decl_func_decl_parameter(funcDecl, i);
                } on ContextError catch (e) {
                  // get_decl_parameter_kind returns PARAMETER_FUNC_DECL when
                  // encountering PARAM_EXTERNAL, get_decl_func_decl_parameter
                  // returns null when the parameter is not a func decl, so we
                  // assume its external.
                  if (e.kind == ContextErrorKind.invalidArg) {
                    parameters.add(const ExternalParameter._());
                    break;
                  }
                  rethrow;
                }
                parameters.add(_getFuncDecl(value));
              default:
                throw AssertionError('Unknown parameter kind: $kind');
            }
          }
          final declKind = _z3.get_decl_kind(funcDecl);
          final name = _getSymbol(_z3.get_decl_name(funcDecl));
          final range = _getSort(_z3.get_range(funcDecl));
          final domainSize = _z3.get_domain_size(funcDecl);
          final domain = <Sort>[];
          for (var i = 0; i < domainSize; i++) {
            domain.add(_getSort(_z3.get_domain(funcDecl, i)));
          }
          final funcKind = FuncKind._fromCode(declKind);
          switch (declKind) {
            case Z3_decl_kind.OP_UNINTERPRETED:
              handle = Func._(name, parameters, domain, range);
            case Z3_decl_kind.OP_RECURSIVE:
              handle = RecursiveFunc._(name, parameters, domain, range);
            case Z3_decl_kind.OP_SPECIAL_RELATION_LO:
              handle = LinearOrder(domain.single, parameters.single as int);
            case Z3_decl_kind.OP_SPECIAL_RELATION_PO:
              handle = PartialOrder(domain.single, parameters.single as int);
            case Z3_decl_kind.OP_SPECIAL_RELATION_PLO:
              handle =
                  PiecewiseLinearOrder(domain.single, parameters.single as int);
            case Z3_decl_kind.OP_SPECIAL_RELATION_TO:
              handle = TreeOrder(domain.single, parameters.single as int);
            case Z3_decl_kind.OP_SPECIAL_RELATION_TRC:
              handle = TransitiveClosure(parameters.single as FuncDecl);
            default:
              handle = InterpretedFunc._(
                this,
                funcDecl,
                name,
                funcKind,
                parameters,
                domain,
                range,
              );
          }
        case Z3_ast_kind.UNKNOWN_AST:
        default:
          handle = Unknown._(this, ast);
      }
      _astReg.putPtr(ast, () => handle!);
      return handle;
    } finally {
      _z3.dec_ref(ast);
    }
  }

  Sort _getSort(Z3_sort sort) => _getAST(sort.cast()) as Sort;
  AlgebraicNumeral _getAlgebraicNumeral(Z3_ast ast) =>
      _getAST(ast) as AlgebraicNumeral;
  FuncDecl _getFuncDecl(Z3_func_decl funcDecl) =>
      _getAST(funcDecl.cast()) as FuncDecl;
  Expr _getExpr(Z3_ast ptr) => _getAST(ptr) as Expr;
  ParamDescs _getParamDescriptions(Z3_param_descrs ptr) =>
      _paramDescriptionsReg.putPtr(ptr, () => ParamDescs._(this, ptr));
  Model _getModel(Z3_model ptr) =>
      _modelReg.putPtr(ptr, () => Model._(this, ptr));
  FuncInterp _getFuncInterp(Z3_func_interp ptr) =>
      _funcInterpReg.putPtr(ptr, () => FuncInterp._(this, ptr));
  FuncEntry _getFuncEntry(Z3_func_entry ptr) =>
      _funcEntryReg.putPtr(ptr, () => FuncEntry._(this, ptr));
  ParserContext _getParserContext(Z3_parser_context ptr) =>
      _parserContextReg.putPtr(ptr, () => ParserContext._(this, ptr));
  Goal _getGoal(Z3_goal ptr) => _goalReg.putPtr(ptr, () => Goal._(this, ptr));
  Tactic _getTactic(Z3_tactic ptr) =>
      _tacticReg.putPtr(ptr, () => Tactic._(this, ptr));
  Probe _getProbe(Z3_probe ptr) =>
      _probeReg.putPtr(ptr, () => Probe._(this, ptr));
  ApplyResult _getApplyResult(Z3_apply_result ptr) =>
      _applyResultReg.putPtr(ptr, () => ApplyResult._(this, ptr));
  Solver _getSolver(Z3_solver ptr) =>
      _solverReg.putPtr(ptr, () => Solver._(this, ptr));
  Stats _getStats(Z3_stats ptr) =>
      _statsReg.putPtr(ptr, () => Stats._(this, ptr));
  Optimize _getOptimize(Z3_optimize ptr) =>
      _optimizeReg.putPtr(ptr, () => Optimize._(this, ptr));

  Z3_symbol _createSymbol(Sym? value) {
    if (value is StringSym) {
      final namePtr = value.value.toNativeUtf8();
      try {
        final symbol = _z3.mk_string_symbol(namePtr.cast());
        _symbols.putIfAbsent(symbol, () => value);
        return symbol;
      } finally {
        malloc.free(namePtr);
      }
    } else if (value is IntSym) {
      final symbol = _z3.mk_int_symbol(value.value);
      _symbols.putIfAbsent(symbol, () => value);
      return symbol;
    } else if (value == null) {
      return nullptr.cast();
    } else {
      throw ArgumentError.value(value, 'value', 'must be String or int');
    }
  }

  Sym _getSymbol(Z3_symbol symbol) {
    final result = _symbols[symbol];
    if (result != null) {
      return result;
    }
    final kind = _z3.get_symbol_kind(symbol);
    if (kind == Z3_symbol_kind.INT_SYMBOL) {
      final value = _z3.get_symbol_int(symbol);
      final result = IntSym(value);
      _symbols[symbol] = result;
      return result;
    } else if (kind == Z3_symbol_kind.STRING_SYMBOL) {
      final value = _z3.get_symbol_string(symbol);
      final result = StringSym(value.cast<Utf8>().toDartString());
      _symbols[symbol] = result;
      return result;
    } else {
      throw AssertionError('Unknown symbol kind: $kind');
    }
  }

  late final _trueExpr = _z3.mk_true();
  late final _falseExpr = _z3.mk_false();
  late final _fpaRne = _z3.mk_fpa_round_nearest_ties_to_even();
  late final _fpaRna = _z3.mk_fpa_round_nearest_ties_to_away();
  late final _fpaRtp = _z3.mk_fpa_round_toward_positive();
  late final _fpaRtn = _z3.mk_fpa_round_toward_negative();
  late final _fpaRtz = _z3.mk_fpa_round_toward_zero();

  late final trueExpr = _getExpr(_trueExpr);
  late final falseExpr = _getExpr(_falseExpr);
  late final fpaRne = _getExpr(_fpaRne);
  late final fpaRoundNearestTiesToEven = fpaRne;
  late final fpaRna = _getExpr(_fpaRna);
  late final fpaRoundNearestTiesToAway = fpaRna;
  late final fpaRtp = _getExpr(_fpaRtp);
  late final fpaRoundTowardPositive = fpaRtp;
  late final fpaRtn = _getExpr(_fpaRtn);
  late final fpaRoundTowardNegative = fpaRtn;
  late final fpaRtz = _getExpr(_fpaRtz);
  late final fpaRoundTowardZero = fpaRtz;

  late final _boolSort = _z3.mk_bool_sort();
  late final _intSort = _z3.mk_int_sort();
  late final _realSort = _z3.mk_real_sort();
  late final _stringSort = _z3.mk_string_sort();
  late final _charSort = _z3.mk_char_sort();
  late final _fpaRoundingModeSort = _z3.mk_fpa_rounding_mode_sort();

  late final boolSort = _getSort(_boolSort) as BoolSort;
  late final intSort = _getSort(_intSort) as IntSort;
  late final realSort = _getSort(_realSort) as RealSort;
  late final stringSort = _getSort(_stringSort) as StringSort;
  late final charSort = _getSort(_charSort) as CharSort;
  late final fpaRoundingModeSort =
      _getSort(_fpaRoundingModeSort) as FpaRoundingModeSort;

  DatatypeInfo getDatatypeInfo(DatatypeSort sort) {
    final zsort = _createSort(sort);
    final numConstructors = _z3.get_datatype_sort_num_constructors(zsort);
    final constructors = <ConstructorInfo>[];
    for (var i = 0; i < numConstructors; i++) {
      final constructor =
          _getFuncDecl(_z3.get_datatype_sort_constructor(zsort, i));
      final recognizer =
          _getFuncDecl(_z3.get_datatype_sort_recognizer(zsort, i));
      final numAccessors = _z3.get_arity(_createFuncDecl(constructor));
      final accessors = <FuncDecl>[];
      for (var j = 0; j < numAccessors; j++) {
        final accessor =
            _z3.get_datatype_sort_constructor_accessor(zsort, i, j);
        accessors.add(_getFuncDecl(accessor));
      }
      constructors.add(ConstructorInfo(
        constructor,
        recognizer,
        accessors,
      ));
    }
    return DatatypeInfo(sort, constructors);
  }

  TupleInfo declareTuple(
    Sym name,
    Map<Sym, Sort> fields,
  ) {
    final decls = calloc<Z3_func_decl>(fields.length + 1);
    final sortsPtr = calloc<Z3_sort>(fields.length);
    final namesPtr = calloc<Z3_symbol>(fields.length);
    try {
      var i = 0;
      for (final MapEntry(:key, :value) in fields.entries) {
        namesPtr[i] = _createSymbol(key);
        sortsPtr[i] = _createSort(value);
        i++;
      }
      final result = _z3.mk_tuple_sort(
        _createSymbol(name),
        fields.length,
        namesPtr,
        sortsPtr,
        decls.elementAt(i),
        decls,
      );
      _z3.inc_ref(result.cast());
      try {
        final con = decls.elementAt(i).value;
        final proj =
            List.generate(fields.length, (i) => _getFuncDecl(decls[i]));
        return TupleInfo(
          _getSort(result) as DatatypeSort,
          _getFuncDecl(con),
          proj,
        );
      } finally {
        _z3.dec_ref(result.cast());
      }
    } finally {
      malloc.free(decls);
      malloc.free(sortsPtr);
      malloc.free(namesPtr);
    }
  }

  EnumInfo declareEnum(
    Sym name,
    List<Sym> elements,
  ) {
    final constsPtr = calloc<Z3_func_decl>(elements.length);
    final testersPtr = calloc<Z3_func_decl>(elements.length);
    final elementsPtr = calloc<Z3_symbol>(elements.length);
    try {
      for (var i = 0; i < elements.length; i++) {
        elementsPtr[i] = _createSymbol(elements[i]);
      }
      final result = _z3.mk_enumeration_sort(
        _createSymbol(name),
        elements.length,
        elementsPtr,
        constsPtr,
        testersPtr,
      );
      _z3.inc_ref(result.cast());
      // Annoying but we need to increment the reference to these beforehand
      // because _getAST makes api calls that will probably free them.
      final consts = List.generate(elements.length, (i) => constsPtr[i]);
      final testers = List.generate(elements.length, (i) => testersPtr[i]);
      for (var i = 0; i < elements.length; i++) {
        _z3.inc_ref(constsPtr[i].cast());
        _z3.inc_ref(testersPtr[i].cast());
      }
      try {
        return EnumInfo(
          _getSort(result) as DatatypeSort,
          {
            for (final e in consts)
              _getSymbol(_z3.get_decl_name(e)): ConstVar.func(_getFuncDecl(e))
          },
          testers.map(_getFuncDecl).toList(),
        );
      } finally {
        _z3.dec_ref(result.cast());
        for (var i = 0; i < elements.length; i++) {
          _z3.dec_ref(constsPtr[i].cast());
          _z3.dec_ref(testersPtr[i].cast());
        }
      }
    } finally {
      malloc.free(constsPtr);
      malloc.free(testersPtr);
      malloc.free(elementsPtr);
    }
  }

  ListInfo declareList(
    Sym name,
    Sort element,
  ) {
    final decls = calloc<Z3_func_decl>(6);
    try {
      final result = _z3.mk_list_sort(
        _createSymbol(name),
        _createSort(element),
        decls.elementAt(0),
        decls.elementAt(1),
        decls.elementAt(2),
        decls.elementAt(3),
        decls.elementAt(4),
        decls.elementAt(5),
      );
      final nil = decls[0];
      final isNil = decls[1];
      final cons = decls[2];
      final isCons = decls[3];
      final head = decls[4];
      final tail = decls[5];
      _z3.inc_ref(result.cast());
      _z3.inc_ref(nil.cast());
      _z3.inc_ref(isNil.cast());
      _z3.inc_ref(cons.cast());
      _z3.inc_ref(isCons.cast());
      _z3.inc_ref(head.cast());
      _z3.inc_ref(tail.cast());
      try {
        return ListInfo(
          _getSort(result) as DatatypeSort,
          ConstVar.func(_getFuncDecl(nil)),
          _getFuncDecl(isNil),
          _getFuncDecl(cons),
          _getFuncDecl(isCons),
          _getFuncDecl(head),
          _getFuncDecl(tail),
        );
      } finally {
        _z3.dec_ref(result.cast());
        _z3.dec_ref(nil.cast());
        _z3.dec_ref(isNil.cast());
        _z3.dec_ref(cons.cast());
        _z3.dec_ref(isCons.cast());
        _z3.dec_ref(head.cast());
        _z3.dec_ref(tail.cast());
      }
    } finally {
      malloc.free(decls);
    }
  }

  Z3_constructor_list _constructorList(List<Z3_constructor> constructors) {
    final constructorsPtr = calloc<Z3_constructor>(constructors.length);
    try {
      for (var i = 0; i < constructors.length; i++) {
        constructorsPtr[i] = constructors[i];
      }
      final result = _z3.mk_constructor_list(
        constructors.length,
        constructorsPtr,
      );
      return result;
    } finally {
      malloc.free(constructorsPtr);
    }
  }

  Map<Sym, DatatypeInfo> declareDatatypes(
    Map<Sym, List<Constructor>> datatypes,
  ) {
    final sortsPtr = calloc<Z3_sort>(datatypes.length);
    final namesPtr = calloc<Z3_symbol>(datatypes.length);
    final constructorsPtr = calloc<Z3_constructor_list>(datatypes.length);
    final allConstructors = <Z3_constructor>[];
    try {
      var i = 0;
      for (final MapEntry(:key, :value) in datatypes.entries) {
        namesPtr[i] = _createSymbol(key);
        final constructors =
            value.map((e) => e.buildConstructor(this)).toList();
        allConstructors.addAll(constructors);
        constructorsPtr[i] = _constructorList(constructors);
        i++;
      }

      _z3.mk_datatypes(
        datatypes.length,
        namesPtr,
        sortsPtr,
        constructorsPtr,
      );

      final result = <Sym, DatatypeInfo>{};
      for (var i = 0; i < datatypes.length; i++) {
        final sort = _getSort(sortsPtr[i]) as DatatypeSort;
        result[sort.name] = getDatatypeInfo(sort);
      }
      return result;
    } finally {
      for (var i = 0; i < datatypes.length; i++) {
        if (constructorsPtr[i] != nullptr) {
          _z3.del_constructor_list(constructorsPtr[i]);
        }
      }
      allConstructors.forEach(_z3.del_constructor);
      malloc.free(sortsPtr);
      malloc.free(namesPtr);
      malloc.free(constructorsPtr);
    }
  }

  DatatypeInfo declareDatatype(Sym name, List<Constructor> constructors) {
    return getDatatypeInfo(DatatypeSort(name, constructors));
  }

  void _checkError() {
    if (_pendingError != null) {
      final error = _pendingError!;
      _pendingError = null;
      throw error;
    }
  }

  bool _bool(int value) {
    if (value == Z3_lbool.L_TRUE) {
      return true;
    } else if (value == Z3_lbool.L_FALSE) {
      return false;
    } else {
      throw AssertionError('Unexpected lbool: $value');
    }
  }

  bool? _maybeBool(int value) {
    if (value == Z3_lbool.L_UNDEF) {
      return null;
    } else {
      return _bool(value);
    }
  }

  List<AST> _unpackAstVector(Z3_ast_vector vector) {
    final size = _z3.ast_vector_size(vector);
    _z3.ast_vector_inc_ref(vector);
    final asts = <Z3_ast>[];
    for (var i = 0; i < size; i++) {
      final ast = _z3.ast_vector_get(vector, i);
      _z3.inc_ref(ast);
      asts.add(ast);
    }
    _z3.ast_vector_dec_ref(vector);
    final result = asts.map(_getAST).toList();
    asts.forEach(_z3.dec_ref);
    return result;
  }

  Z3_ast_vector _packAstVector(List<AST> asts) {
    final result = _z3.mk_ast_vector();
    _z3.ast_vector_inc_ref(result);
    for (final ast in asts) {
      _z3.ast_vector_push(result, _createAST(ast));
    }
    return result;
  }

  T declare<T extends AST>(T ast) {
    _createAST(ast);
    return ast;
  }

  void defineRecursiveFunc(
    RecursiveFunc decl,
    AST body, [
    List<Expr> args = const [],
  ]) {
    final funcDecl = _createFuncDecl(decl);
    final bodyAst = _createAST(body);
    final argsPtr = calloc<Z3_ast>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = _createAST(args[i]);
      }
      _z3.add_rec_def(
        funcDecl,
        args.length,
        argsPtr,
        bodyAst,
      );
    } finally {
      malloc.free(argsPtr);
    }
  }

  Sort getSort(Expr value) {
    return _getSort(_z3.get_sort(_createAST(value)));
  }

  Sym getSortName(Sort sort) {
    final symbol = _z3.get_sort_name(_createSort(sort));
    return _getSymbol(symbol);
  }

  int getSortId(Sort sort) {
    return _z3.get_sort_id(_createSort(sort));
  }

  bool sortsEqual(Sort a, Sort b) {
    return _z3.is_eq_sort(_createSort(a), _createSort(b));
  }

  bool funcDeclsEqual(FuncDecl a, FuncDecl b) {
    return _z3.is_eq_func_decl(_createFuncDecl(a), _createFuncDecl(b));
  }

  App? getExprApp(Expr app) {
    final ast = _createAST(app);
    final kind = _z3.get_ast_kind(ast);
    if (kind == Z3_ast_kind.APP_AST || kind == Z3_ast_kind.NUMERAL_AST) {
      final Z3_app app = ast.cast();
      final decl = _z3.get_app_decl(app);
      return App._(
        _getFuncDecl(decl),
        _getAppArgs(app),
        this,
        ast.cast(),
      );
    } else {
      return null;
    }
  }

  AST simplify(AST ast, [Params? params]) {
    if (params == null) {
      return _getAST(_z3.simplify(_createAST(ast)));
    } else {
      return _getAST(_z3.simplify_ex(_createAST(ast), params._params));
    }
  }

  ParamDescs get simplifyParamDescriptions =>
      _getParamDescriptions(_z3.simplify_get_param_descrs());

  AST updateTerm(AST ast, List<AST> args) {
    final argsPtr = calloc<Z3_ast>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = _createAST(args[i]);
      }
      final result = _z3.update_term(_createAST(ast), args.length, argsPtr);
      return _getAST(result);
    } finally {
      malloc.free(argsPtr);
    }
  }

  AST substitute(AST ast, List<AST> from, List<AST> to) {
    assert(from.length == to.length);
    final fromPtr = calloc<Z3_ast>(from.length);
    final toPtr = calloc<Z3_ast>(to.length);
    try {
      for (var i = 0; i < from.length; i++) {
        fromPtr[i] = _createAST(from[i]);
        toPtr[i] = _createAST(to[i]);
      }
      final result = _z3.substitute(
        _createAST(ast),
        from.length,
        fromPtr,
        toPtr,
      );
      return _getAST(result);
    } finally {
      malloc.free(fromPtr);
      malloc.free(toPtr);
    }
  }

  AST substituteVars(AST ast, List<AST> to) {
    final toPtr = calloc<Z3_ast>(to.length);
    try {
      for (var i = 0; i < to.length; i++) {
        toPtr[i] = _createAST(to[i]);
      }
      final result = _z3.substitute_vars(
        _createAST(ast),
        to.length,
        toPtr,
      );
      return _getAST(result);
    } finally {
      malloc.free(toPtr);
    }
  }

  AST substituteFuncs(AST ast, List<FuncDecl> from, List<AST> to) {
    assert(from.length == to.length);
    final fromPtr = calloc<Z3_func_decl>(from.length);
    final toPtr = calloc<Z3_ast>(to.length);
    try {
      for (var i = 0; i < from.length; i++) {
        fromPtr[i] = _createFuncDecl(from[i]);
        toPtr[i] = _createAST(to[i]);
      }
      final result = _z3.substitute_funs(
        _createAST(ast),
        from.length,
        fromPtr,
        toPtr,
      );
      return _getAST(result);
    } finally {
      malloc.free(fromPtr);
      malloc.free(toPtr);
    }
  }

  void setASTPrintMode(ASTPrintMode mode) {
    switch (mode) {
      case ASTPrintMode.smtlibFull:
        _z3.set_ast_print_mode(Z3_ast_print_mode.PRINT_SMTLIB_FULL);
      case ASTPrintMode.lowLevel:
        _z3.set_ast_print_mode(Z3_ast_print_mode.PRINT_LOW_LEVEL);
      case ASTPrintMode.smtlib2Compliant:
        _z3.set_ast_print_mode(Z3_ast_print_mode.PRINT_SMTLIB2_COMPLIANT);
    }
  }

  String astToString(AST ast) {
    return _z3.ast_to_string(_createAST(ast)).cast<Utf8>().toDartString();
  }

  String benchmarkToSmtlib({
    required String name,
    required String logic,
    required String status,
    required String attributes,
    required List<AST> assumptions,
    required AST formula,
  }) {
    final namePtr = name.toNativeUtf8();
    final logicPtr = logic.toNativeUtf8();
    final statusPtr = status.toNativeUtf8();
    final attributesPtr = attributes.toNativeUtf8();
    final assumptionsPtr = calloc<Z3_ast>(assumptions.length);
    try {
      for (var i = 0; i < assumptions.length; i++) {
        assumptionsPtr[i] = _createAST(assumptions[i]);
      }
      final result = _z3.benchmark_to_smtlib_string(
        namePtr.cast(),
        logicPtr.cast(),
        statusPtr.cast(),
        attributesPtr.cast(),
        assumptions.length,
        assumptionsPtr,
        _createAST(formula),
      );
      return result.cast<Utf8>().toDartString();
    } finally {
      malloc.free(assumptionsPtr);
      malloc.free(namePtr);
      malloc.free(logicPtr);
      malloc.free(statusPtr);
      malloc.free(attributesPtr);
    }
  }

  List<AST> parse(
    String str, {
    Map<Sym, Sort> sorts = const {},
    Map<Sym, FuncDecl> decls = const {},
  }) {
    final sortsPtr = calloc<Z3_symbol>(sorts.length);
    final sortsSortsPtr = calloc<Z3_sort>(sorts.length);
    final declsPtr = calloc<Z3_symbol>(decls.length);
    final declsFuncDeclsPtr = calloc<Z3_func_decl>(decls.length);
    final strPtr = str.toNativeUtf8();
    try {
      var i = 0;
      for (final MapEntry(:key, :value) in sorts.entries) {
        sortsPtr[i] = _createSymbol(key);
        sortsSortsPtr[i] = _createSort(value);
        i++;
      }
      for (final MapEntry(:key, :value) in decls.entries) {
        declsPtr[i] = _createSymbol(key);
        declsFuncDeclsPtr[i] = _createFuncDecl(value);
        i++;
      }
      final vec = _z3.parse_smtlib2_string(
        strPtr.cast(),
        sorts.length,
        sortsPtr,
        sortsSortsPtr,
        decls.length,
        declsPtr,
        declsFuncDeclsPtr,
      );
      return _unpackAstVector(vec);
    } finally {
      malloc.free(sortsPtr);
      malloc.free(sortsSortsPtr);
      malloc.free(declsPtr);
      malloc.free(declsFuncDeclsPtr);
      malloc.free(strPtr);
    }
  }

  String eval(String str) {
    final strPtr = str.toNativeUtf8();
    try {
      final result = _z3.eval_smtlib2_string(strPtr.cast());
      return result.cast<Utf8>().toDartString();
    } finally {
      malloc.free(strPtr);
    }
  }

  Probe probe(double value) {
    final result = _z3.probe_const(value);
    return _getProbe(result);
  }

  A translateTo<A extends AST>(Context other, A ast) {
    return other._getAST(_translateTo(other, ast, _createAST(ast))) as A;
  }

  late final Map<String, BuiltinTactic> builtinTactics = () {
    final result = <String, BuiltinTactic>{};
    final count = _z3.get_num_tactics();
    for (var i = 0; i < count; i++) {
      final name = _z3.get_tactic_name(i);
      final nameStr = name.cast<Utf8>().toDartString();
      final tactic = _z3.mk_tactic(name);
      result[nameStr] = _tacticReg.putPtr(
        tactic,
        () => BuiltinTactic._(this, tactic, nameStr),
      ) as BuiltinTactic;
    }
    return result;
  }();

  late final Map<String, BuiltinProbe> builtinProbes = () {
    final result = <String, BuiltinProbe>{};
    final count = _z3.get_num_probes();
    for (var i = 0; i < count; i++) {
      final name = _z3.get_probe_name(i);
      final nameStr = name.cast<Utf8>().toDartString();
      final probe = _z3.mk_probe(name);
      result[nameStr] = _probeReg.putPtr(
        probe,
        () => BuiltinProbe._(this, probe, nameStr),
      ) as BuiltinProbe;
    }
    return result;
  }();

  Solver solver({LogicKind? logic}) {
    if (logic == null) {
      return _getSolver(_z3.mk_solver());
    } else {
      return _getSolver(_z3.mk_solver_for_logic(
        _createSymbol(StringSym(logic.smtlibName)),
      ));
    }
  }

  Solver simpleSolver() => _getSolver(_z3.mk_simple_solver());

  ParserContext parser() => _getParserContext(_z3.mk_parser_context());

  Optimize optimize() => _getOptimize(_z3.mk_optimize());

  Expr pbLe(Map<Expr, int> args, int k) {
    final argsPtr = calloc<Z3_ast>(args.length);
    final coeffsPtr = calloc<Int>(args.length);
    try {
      var i = 0;
      for (final MapEntry(:key, :value) in args.entries) {
        argsPtr[i] = _createAST(key);
        coeffsPtr[i] = value;
        i++;
      }
      final result = _z3.mk_pble(args.length, argsPtr, coeffsPtr, k);
      return _getExpr(result);
    } finally {
      malloc.free(argsPtr);
      malloc.free(coeffsPtr);
    }
  }

  Expr pbGe(Map<Expr, int> args, int k) {
    final argsPtr = calloc<Z3_ast>(args.length);
    final coeffsPtr = calloc<Int>(args.length);
    try {
      var i = 0;
      for (final MapEntry(:key, :value) in args.entries) {
        argsPtr[i] = _createAST(key);
        coeffsPtr[i] = value;
        i++;
      }
      final result = _z3.mk_pbge(args.length, argsPtr, coeffsPtr, k);
      return _getExpr(result);
    } finally {
      malloc.free(argsPtr);
      malloc.free(coeffsPtr);
    }
  }

  Lambda lambdaConst(List<ConstVar> args, Expr body) {
    final argsPtr = calloc<Z3_app>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = _createAST(args[i]).cast();
      }
      final result = _z3.mk_lambda_const(
        args.length,
        argsPtr,
        _createAST(body),
      );
      return _getExpr(result) as Lambda;
    } finally {
      malloc.free(argsPtr);
    }
  }

  late final paramDesc = ParamDescs._(this, _z3.get_global_param_descrs());

  Params emptyParams() => Params._(this, _z3.mk_params());
}

class Params {
  Params._(this._c, this._params);
  final Context _c;
  final Z3_params _params;

  operator []=(String key, Object value) {
    final k = _c._createSymbol(StringSym(key));
    if (value is String) {
      final v = _c._createSymbol(StringSym(value));
      _c._z3.params_set_symbol(_params, k, v);
    } else if (value is int) {
      _c._z3.params_set_uint(_params, k, value);
    } else if (value is double) {
      _c._z3.params_set_double(_params, k, value);
    } else if (value is bool) {
      _c._z3.params_set_bool(_params, k, value);
    } else if (value is Sym) {
      _c._z3.params_set_symbol(_params, k, _c._createSymbol(value));
    } else {
      throw ArgumentError.value(
        value,
        'value',
        'must be String, int, double, bool, or Sym, got ${value.runtimeType}',
      );
    }
  }

  void validate(ParamDescs descriptions) {
    _c._z3.params_validate(_params, descriptions._desc);
  }

  @override
  String toString() {
    return _c._z3.params_to_string(_params).cast<Utf8>().toDartString();
  }
}

class Fixedpoint {
  Fixedpoint._(this._c, this._fp) {
    _instances[_fp] = WeakReference(this);
    _finalizer.attach(this, _fp);
    _c._z3.fixedpoint_init(_fp, _fp.cast());
  }

  final Context _c;
  final Z3_fixedpoint _fp;

  void Function(List<AST> args, List<AST> outs)? _onReduceAssign;
  AST? Function(FuncDecl func, List<AST> args)? _onReduceApply;
  void Function(AST, int level)? _onLemma;
  void Function()? _onPredecessor;
  void Function()? _onUnfold;

  static final _instances = <Z3_fixedpoint, WeakReference<Fixedpoint>>{};
  static final _finalizer =
      Finalizer<Z3_fixedpoint>((e) => _instances.remove(e));

  void addRule(AST rule, Z3_symbol name) {
    _c._z3.fixedpoint_add_rule(_fp, _c._createAST(rule), name);
  }

  void addFact(FuncDecl relation, List<int> args) {
    final argsPtr = calloc<UnsignedInt>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = args[i];
      }
      _c._z3.fixedpoint_add_fact(
        _fp,
        _c._createFuncDecl(relation),
        args.length,
        argsPtr,
      );
    } finally {
      malloc.free(argsPtr);
    }
  }

  void assertConstraint(AST axiom) {
    _c._z3.fixedpoint_assert(_fp, _c._createAST(axiom));
  }

  void addConstraint(AST axiom, int level) {
    _c._z3.fixedpoint_add_constraint(_fp, _c._createAST(axiom), level);
  }

  bool query(AST query) {
    final result = _c._z3.fixedpoint_query(_fp, _c._createAST(query));
    return _c._bool(result);
  }

  bool queryRelations(List<FuncDecl> relations) {
    final relationsPtr = calloc<Z3_func_decl>(relations.length);
    try {
      for (var i = 0; i < relations.length; i++) {
        relationsPtr[i] = _c._createFuncDecl(relations[i]);
      }
      final result = _c._z3.fixedpoint_query_relations(
        _fp,
        relations.length,
        relationsPtr,
      );
      return _c._bool(result);
    } finally {
      malloc.free(relationsPtr);
    }
  }

  AST getAnswer() {
    return _c._getAST(_c._z3.fixedpoint_get_answer(_fp));
  }

  String getReasonUnknown() {
    return _c._z3
        .fixedpoint_get_reason_unknown(_fp)
        .cast<Utf8>()
        .toDartString();
  }

  void updateRule(AST rule, Z3_symbol name) {
    _c._z3.fixedpoint_update_rule(_fp, _c._createAST(rule), name);
  }

  void getNumLevels(FuncDecl pred) {
    _c._z3.fixedpoint_get_num_levels(_fp, _c._createFuncDecl(pred));
  }

  void getCoverDelta(int level, FuncDecl pred) {
    _c._z3.fixedpoint_get_cover_delta(
      _fp,
      level,
      _c._createFuncDecl(pred),
    );
  }

  void addCover(int level, FuncDecl pred, AST property) {
    _c._z3.fixedpoint_add_cover(
      _fp,
      level,
      _c._createFuncDecl(pred),
      _c._createAST(property),
    );
  }

  Stats getStatistics() {
    return _c._getStats(_c._z3.fixedpoint_get_statistics(_fp));
  }

  void registerRelation(FuncDecl relation) {
    _c._z3.fixedpoint_register_relation(
      _fp,
      _c._createFuncDecl(relation),
    );
  }

  void setPredicateRepresentation(FuncDecl relation, List<Sym> kinds) {
    final kindsPtr = calloc<Z3_symbol>(kinds.length);
    try {
      for (var i = 0; i < kinds.length; i++) {
        kindsPtr[i] = _c._createSymbol(kinds[i]);
      }
      _c._z3.fixedpoint_set_predicate_representation(
        _fp,
        _c._createFuncDecl(relation),
        kinds.length,
        kindsPtr,
      );
    } finally {
      malloc.free(kindsPtr);
    }
  }

  List<Expr> getRules() {
    final result = _c._z3.fixedpoint_get_rules(_fp);
    return _c._unpackAstVector(result).cast();
  }

  List<Expr> getAssertions() {
    final result = _c._z3.fixedpoint_get_assertions(_fp);
    return _c._unpackAstVector(result).cast();
  }

  void setParams(Params params) {
    _c._z3.fixedpoint_set_params(_fp, params._params);
  }

  String getHelp() {
    return _c._z3.fixedpoint_get_help(_fp).cast<Utf8>().toDartString();
  }

  ParamDescs getParamDescriptions() {
    return _c._getParamDescriptions(_c._z3.fixedpoint_get_param_descrs(_fp));
  }

  List<AST> addSmtlib(String s) {
    final sPtr = s.toNativeUtf8();
    try {
      final result = _c._z3.fixedpoint_from_string(_fp, sPtr.cast());
      return _c._unpackAstVector(result);
    } finally {
      malloc.free(sPtr);
    }
  }

  List<AST> addSmtlibFile(File file) {
    final pathPtr = file.path.toNativeUtf8();
    try {
      final result = _c._z3.fixedpoint_from_file(_fp, pathPtr.cast());
      return _c._unpackAstVector(result);
    } finally {
      malloc.free(pathPtr);
    }
  }

  static void _onReduceAssignCallback(
    Pointer<Void> state,
    Z3_func_decl decl,
    int numArgs,
    Pointer<Z3_ast> args,
    int numOuts,
    Pointer<Z3_ast> outs,
  ) {
    final fp = _instances[state.cast()]!.target!;
    final out = List.generate(numOuts, (i) => fp._c._getAST(outs[i]));
    final outCopy = out;
    fp._onReduceAssign!(
      List.generate(numArgs, (i) => fp._c._getAST(args[i])),
      out,
    );
    for (var i = 0; i < numOuts; i++) {
      if (out[i] != outCopy[i]) {
        outs[i] = fp._c._createAST(out[i]);
      }
    }
  }

  void setOnReduceAssign(
      List<AST> Function(List<AST> args, List<AST> outs)? f) {
    if (f == null && _onReduceAssign != null) {
      _c._z3.fixedpoint_set_reduce_assign_callback(
        _fp,
        nullptr,
      );
      _onReduceAssign = null;
    } else if (f != null && _onReduceAssign == null) {
      _c._z3.fixedpoint_set_reduce_assign_callback(
        _fp,
        Pointer.fromFunction<
            Void Function(
              Pointer<Void>,
              Z3_func_decl,
              UnsignedInt,
              Pointer<Z3_ast>,
              UnsignedInt,
              Pointer<Z3_ast>,
            )>(_onReduceAssignCallback),
      );
    }
    _onReduceAssign = f;
  }

  static void _onReduceApplyCallback(
    Pointer<Void> state,
    Z3_func_decl decl,
    int numArgs,
    Pointer<Z3_ast> args,
    Pointer<Z3_ast> out,
  ) {
    final fp = _instances[state.cast()]!.target!;
    final result = fp._onReduceApply!(
      fp._c._getFuncDecl(decl),
      List.generate(numArgs, (i) => fp._c._getAST(args[i])),
    );
    if (result != null) {
      out.value = fp._c._createAST(result);
    }
  }

  void setOnReduceApply(AST? Function(FuncDecl func, List<AST> args)? f) {
    if (f == null && _onReduceApply != null) {
      _c._z3.fixedpoint_set_reduce_app_callback(
        _fp,
        nullptr,
      );
      _onReduceApply = null;
    } else if (f != null && _onReduceApply == null) {
      _c._z3.fixedpoint_set_reduce_app_callback(
        _fp,
        Pointer.fromFunction<
            Void Function(
              Pointer<Void>,
              Z3_func_decl,
              UnsignedInt,
              Pointer<Z3_ast>,
              Pointer<Z3_ast>,
            )>(_onReduceApplyCallback),
      );
    }
    _onReduceApply = f;
  }

  static void _onLemmaCallback(
    Pointer<Void> state,
    Z3_ast lemma,
    int level,
  ) {
    final fp = _instances[state.cast()]!.target!;
    fp._onLemma!(
      fp._c._getAST(lemma),
      level,
    );
  }

  static void _onPredecessorCallback(
    Pointer<Void> state,
  ) {
    final fp = _instances[state.cast()]!.target!;
    fp._onPredecessor!();
  }

  static void _onUnfoldCallback(
    Pointer<Void> state,
  ) {
    final fp = _instances[state.cast()]!.target!;
    fp._onUnfold!();
  }

  bool get _areLemmaCallbacksNull =>
      _onLemma == null && _onPredecessor == null && _onUnfold == null;

  void _updateCallbacks(bool wasNull) {
    final isNull = _areLemmaCallbacksNull;
    if (wasNull && !isNull) {
      _c._z3.fixedpoint_add_callback(
        _fp,
        _fp.cast(),
        Pointer.fromFunction<
            Void Function(
              Pointer<Void>,
              Z3_ast,
              UnsignedInt,
            )>(_onLemmaCallback),
        Pointer.fromFunction<Void Function(Pointer<Void>)>(
            _onPredecessorCallback),
        Pointer.fromFunction<Void Function(Pointer<Void>)>(_onUnfoldCallback),
      );
    } else if (!wasNull && isNull) {
      _c._z3.fixedpoint_add_callback(
        _fp,
        _fp.cast(),
        nullptr,
        nullptr,
        nullptr,
      );
    }
  }

  void setOnLemma(void Function(AST, int level)? f) {
    final wasNull = _areLemmaCallbacksNull;
    _onLemma = f;
    _updateCallbacks(wasNull);
  }

  void setOnPredecessor(void Function()? f) {
    final wasNull = _areLemmaCallbacksNull;
    _onPredecessor = f;
    _updateCallbacks(wasNull);
  }

  void setOnUnfold(void Function()? f) {
    final wasNull = _areLemmaCallbacksNull;
    _onUnfold = f;
    _updateCallbacks(wasNull);
  }

  @override
  String toString([List<AST>? extra]) {
    final extraPtr = calloc<Z3_ast>(extra?.length ?? 0);
    try {
      for (var i = 0; i < (extra?.length ?? 0); i++) {
        extraPtr[i] = _c._createAST(extra![i]);
      }
      final result = _c._z3
          .fixedpoint_to_string(
            _fp,
            extra?.length ?? 0,
            extraPtr,
          )
          .cast<Utf8>()
          .toDartString();
      return result;
    } finally {
      malloc.free(extraPtr);
    }
  }
}

class Model {
  Model._(this._c, this._model);

  final Context _c;
  final Z3_model _model;

  A eval<A extends Expr?>(Expr query, {bool completion = true}) {
    final resultPtr = calloc<Z3_ast>();
    try {
      final success = _c._z3.model_eval(
        _model,
        _c._createAST(query),
        completion,
        resultPtr,
      );
      if (success) {
        return _c._getAST(resultPtr.value) as A;
      }
      return null as A;
    } finally {
      malloc.free(resultPtr);
    }
  }

  A? evalConst<A extends Expr>(ConstVar query) {
    final result = _c._z3.model_get_const_interp(
      _model,
      _c._createFuncDecl(query.decl),
    );
    if (result == nullptr) {
      return null;
    }
    return _c._getAST(result) as A;
  }

  FuncInterp? getFuncInterp(FuncDecl decl) {
    final result = _c._z3.model_get_func_interp(
      _model,
      _c._createFuncDecl(decl),
    );
    if (result == nullptr) {
      return null;
    }
    return _c._getFuncInterp(result);
  }

  List<FuncDecl> getConsts() {
    final result = <FuncDecl>[];
    final size = _c._z3.model_get_num_consts(_model);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getFuncDecl(_c._z3.model_get_const_decl(_model, i)),
      );
    }
    return result;
  }

  List<FuncDecl> getFuncs() {
    final result = <FuncDecl>[];
    final size = _c._z3.model_get_num_funcs(_model);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getFuncDecl(_c._z3.model_get_func_decl(_model, i)),
      );
    }
    return result;
  }

  List<Sort> getSorts() {
    final result = <Sort>[];
    final size = _c._z3.model_get_num_sorts(_model);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getSort(_c._z3.model_get_sort(_model, i)),
      );
    }
    return result;
  }

  List<Expr> getSortUniverse(Sort s) {
    final vector = _c._z3.model_get_sort_universe(
      _model,
      _c._createSort(s),
    );
    return _c._unpackAstVector(vector).cast();
  }

  Model toContext(Context c) {
    final ptr = _c._z3.model_translate(_model, c._context);
    return c._getModel(ptr);
  }

  FuncInterp addFuncInterp(FuncDecl decl, Expr defaultValue) {
    final result = _c._z3.add_func_interp(
      _model,
      _c._createFuncDecl(decl),
      _c._createAST(defaultValue),
    );
    return _c._getFuncInterp(result);
  }

  void addConstInterp(FuncDecl decl, Expr value) {
    _c._z3.add_const_interp(
      _model,
      _c._createFuncDecl(decl),
      _c._createAST(value),
    );
  }

  @override
  String toString() {
    return _c._z3.model_to_string(_model).cast<Utf8>().toDartString();
  }
}

class FuncInterp {
  FuncInterp._(this._c, this._f);

  final Context _c;
  final Z3_func_interp _f;

  List<FuncEntry> getEntries() {
    final result = <FuncEntry>[];
    final size = _c._z3.func_interp_get_num_entries(_f);
    for (var i = 0; i < size; i++) {
      final e = _c._z3.func_interp_get_entry(_f, i);
      result.add(_c._getFuncEntry(e));
    }
    return result;
  }

  Expr getElse() {
    return _c._getExpr(_c._z3.func_interp_get_else(_f));
  }

  void setElse(Expr value) {
    _c._z3.func_interp_set_else(_f, _c._createAST(value));
  }

  void addEntry(List<Expr> args, Expr value) {
    final vec = _c._z3.mk_ast_vector();
    _c._z3.ast_vector_inc_ref(vec);
    for (var i = 0; i < args.length; i++) {
      _c._z3.ast_vector_push(vec, _c._createAST(args[i]));
    }
    _c._z3.func_interp_add_entry(
      _f,
      vec,
      _c._createAST(value),
    );
    _c._z3.ast_vector_dec_ref(vec);
  }

  int getArity() {
    return _c._z3.func_interp_get_arity(_f);
  }
}

class FuncEntry {
  FuncEntry._(this._c, this._e);

  final Context _c;
  final Z3_func_entry _e;

  Expr getValue() {
    return _c._getExpr(_c._z3.func_entry_get_value(_e));
  }

  List<Expr> getArgs() {
    final result = <Expr>[];
    final size = _c._z3.func_entry_get_num_args(_e);
    for (var i = 0; i < size; i++) {
      result.add(_c._getExpr(_c._z3.func_entry_get_arg(_e, i)));
    }
    return result;
  }
}

class ParserContext {
  ParserContext._(this._c, this._pc);

  final Context _c;
  final Z3_parser_context _pc;

  void addSort(Sort sort) {
    _c._z3.parser_context_add_sort(
      _pc,
      _c._createSort(sort),
    );
  }

  void addDecl(FuncDecl decl) {
    _c._z3.parser_context_add_decl(
      _pc,
      _c._createFuncDecl(decl),
    );
  }

  List<AST> parse(String str) {
    final strPtr = str.toNativeUtf8();
    try {
      final result = _c._z3.parser_context_from_string(
        _pc,
        strPtr.cast(),
      );
      return _c._unpackAstVector(result);
    } finally {
      malloc.free(strPtr);
    }
  }
}

class Goal {
  Goal._(this._c, this._goal);

  final Context _c;
  final Z3_goal _goal;

  GoalPrecision getPrecision() {
    final result = _c._z3.goal_precision(_goal);
    switch (result) {
      case Z3_goal_prec.GOAL_PRECISE:
        return GoalPrecision.precise;
      case Z3_goal_prec.GOAL_UNDER:
        return GoalPrecision.under;
      case Z3_goal_prec.GOAL_OVER:
        return GoalPrecision.over;
      case Z3_goal_prec.GOAL_UNDER_OVER:
        return GoalPrecision.underOver;
      default:
        throw AssertionError('Unknown goal precision: $result');
    }
  }

  void assertExpr(AST a) {
    _c._z3.goal_assert(_goal, _c._createAST(a));
  }

  bool isInconsistent() {
    return _c._z3.goal_inconsistent(_goal);
  }

  int getDepth() {
    return _c._z3.goal_depth(_goal);
  }

  void reset() {
    _c._z3.goal_reset(_goal);
  }

  int getSize() {
    return _c._z3.goal_size(_goal);
  }

  int getNumExprs() {
    return _c._z3.goal_num_exprs(_goal);
  }

  bool isDecidedSat() {
    return _c._z3.goal_is_decided_sat(_goal);
  }

  bool isDecidedUnsat() {
    return _c._z3.goal_is_decided_unsat(_goal);
  }

  Goal toContext(Context c) {
    final ptr = _c._z3.goal_translate(_goal, c._context);
    return c._getGoal(ptr);
  }

  Model convert(Model? m) {
    final ptr = _c._z3.goal_convert_model(_goal, m?._model ?? nullptr);
    return _c._getModel(ptr);
  }

  @override
  String toString() {
    return _c._z3.goal_to_string(_goal).cast<Utf8>().toDartString();
  }

  String toDimacs({bool includeNames = true}) {
    return _c._z3
        .goal_to_dimacs_string(_goal, includeNames)
        .cast<Utf8>()
        .toDartString();
  }
}

class Tactic {
  Tactic._(this._c, this._tactic);

  factory Tactic.parallelOr(List<Tactic> tactics) {
    final tacticsPtr = calloc<Z3_tactic>(tactics.length);
    try {
      for (var i = 0; i < tactics.length; i++) {
        tacticsPtr[i] = tactics[i]._tactic;
      }
      final c = tactics[0]._c;
      final result = c._z3.tactic_par_or(
        tactics.length,
        tacticsPtr,
      );
      return c._getTactic(result);
    } finally {
      malloc.free(tacticsPtr);
    }
  }

  final Context _c;
  final Z3_tactic _tactic;

  Tactic andThen(Tactic other) {
    final result = _c._z3.tactic_and_then(_tactic, other._tactic);
    return _c._getTactic(result);
  }

  Tactic orElse(Tactic other) {
    final result = _c._z3.tactic_or_else(_tactic, other._tactic);
    return _c._getTactic(result);
  }

  Tactic parAndThen(Tactic other) {
    final result = _c._z3.tactic_par_and_then(_tactic, other._tactic);
    return _c._getTactic(result);
  }

  Tactic tryFor(Duration duration) {
    final result = _c._z3.tactic_try_for(
      _tactic,
      duration.inMilliseconds,
    );
    return _c._getTactic(result);
  }

  Tactic when(Probe p) {
    final result = _c._z3.tactic_when(p._probe, _tactic);
    return _c._getTactic(result);
  }

  Tactic cond(Tactic otherwise, Probe p) {
    final result = _c._z3.tactic_cond(
      p._probe,
      _tactic,
      otherwise._tactic,
    );
    return _c._getTactic(result);
  }

  Tactic repeat(int max) {
    final result = _c._z3.tactic_repeat(_tactic, max);
    return _c._getTactic(result);
  }

  Tactic skip() {
    final result = _c._z3.tactic_skip();
    return _c._getTactic(result);
  }

  Tactic fail() {
    final result = _c._z3.tactic_fail();
    return _c._getTactic(result);
  }

  Tactic failIf(Probe p) {
    final result = _c._z3.tactic_fail_if(p._probe);
    return _c._getTactic(result);
  }

  Tactic failIfNotDecided() {
    final result = _c._z3.tactic_fail_if_not_decided();
    return _c._getTactic(result);
  }

  Tactic usingParams(Params params) {
    final result = _c._z3.tactic_using_params(_tactic, params._params);
    return _c._getTactic(result);
  }

  String getParamHelp() {
    return _c._z3.tactic_get_help(_tactic).cast<Utf8>().toDartString();
  }

  ParamDescs getParamDescriptions() {
    return _c._getParamDescriptions(_c._z3.tactic_get_param_descrs(_tactic));
  }

  ApplyResult apply(Goal g, {Params? params}) {
    if (params != null) {
      return _c._getApplyResult(
        _c._z3.tactic_apply_ex(
          _tactic,
          g._goal,
          params._params,
        ),
      );
    } else {
      return _c._getApplyResult(_c._z3.tactic_apply(_tactic, g._goal));
    }
  }

  Solver toSolver() {
    return _c._getSolver(_c._z3.mk_solver_from_tactic(_tactic));
  }
}

class BuiltinTactic extends Tactic {
  BuiltinTactic._(Context c, Z3_tactic tactic, this.name) : super._(c, tactic);

  final String name;
  String getHelp() {
    final namePtr = name.toNativeUtf8();
    try {
      final result = _c._z3.tactic_get_descr(namePtr.cast());
      return result.cast<Utf8>().toDartString();
    } finally {
      malloc.free(namePtr);
    }
  }
}

class Probe {
  Probe._(this._c, this._probe);

  final Context _c;
  final Z3_probe _probe;

  Probe operator <(Probe other) {
    final result = _c._z3.probe_lt(_probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator >(Probe other) {
    final result = _c._z3.probe_gt(_probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator <=(Probe other) {
    final result = _c._z3.probe_le(_probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator >=(Probe other) {
    final result = _c._z3.probe_ge(_probe, other._probe);
    return _c._getProbe(result);
  }

  Probe equals(Probe other) {
    final result = _c._z3.probe_eq(_probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator &(Probe other) {
    final result = _c._z3.probe_and(_probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator |(Probe other) {
    final result = _c._z3.probe_or(_probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator ~() {
    final result = _c._z3.probe_not(_probe);
    return _c._getProbe(result);
  }

  double apply(Goal g) {
    return _c._z3.probe_apply(_probe, g._goal);
  }
}

class BuiltinProbe extends Probe {
  BuiltinProbe._(Context c, Z3_probe probe, this.name) : super._(c, probe);

  final String name;
  String getHelp() {
    final namePtr = name.toNativeUtf8();
    try {
      final result = _c._z3.probe_get_descr(namePtr.cast());
      return result.cast<Utf8>().toDartString();
    } finally {
      malloc.free(namePtr);
    }
  }
}

class ApplyResult {
  ApplyResult._(this._c, this._result);

  final Context _c;
  final Z3_apply_result _result;

  List<Goal> getSubgoals() {
    final result = <Goal>[];
    final size = _c._z3.apply_result_get_num_subgoals(_result);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getGoal(_c._z3.apply_result_get_subgoal(_result, i)),
      );
    }
    return result;
  }

  @override
  String toString() {
    return _c._z3.apply_result_to_string(_result).cast<Utf8>().toDartString();
  }
}

class Solver {
  Solver._(this._c, this._solver) {
    _instances[_solver] = WeakReference(this);
    _finalizer.attach(this, _solver);
  }

  final Context _c;
  final Z3_solver _solver;

  static final _instances = <Z3_solver, WeakReference<Solver>>{};
  static final _finalizer = Finalizer<Z3_solver>((e) {
    _instances.remove(e);
  });

  Context get context => _c;

  Solver toContext(Context c) {
    final ptr = _c._z3.solver_translate(_solver, c._context);
    return c._getSolver(ptr);
  }

  void importConverterFrom(Solver other) {
    _c._z3.solver_import_model_converter(other._solver, _solver);
  }

  String getHelp() {
    return _c._z3.solver_get_help(_solver).cast<Utf8>().toDartString();
  }

  ParamDescs getParamDescs() {
    return _c._getParamDescriptions(_c._z3.solver_get_param_descrs(_solver));
  }

  void setParams(Params params) {
    _c._z3.solver_set_params(_solver, params._params);
  }

  void push() {
    _c._z3.solver_push(_solver);
  }

  void pop([int n = 1]) {
    _c._z3.solver_pop(_solver, n);
  }

  void reset() {
    _c._z3.solver_reset(_solver);
  }

  int getNumScopes() {
    return _c._z3.solver_get_num_scopes(_solver);
  }

  void add(Expr a, {ConstVar? constant}) {
    if (constant != null) {
      _c._z3.solver_assert_and_track(
        _solver,
        _c._createAST(a),
        _c._createAST(constant),
      );
    } else {
      _c._z3.solver_assert(_solver, _c._createAST(a));
    }
  }

  void addAll(Iterable<Expr> a) {
    a.forEach(add);
  }

  void addSmtlibFile(File file) {
    final pathPtr = file.path.toNativeUtf8();
    try {
      _c._z3.solver_from_file(_solver, pathPtr.cast());
    } finally {
      malloc.free(pathPtr);
    }
  }

  void addSmtlib(String str) {
    final strPtr = str.toNativeUtf8();
    try {
      _c._z3.solver_from_string(_solver, strPtr.cast());
    } finally {
      malloc.free(strPtr);
    }
  }

  List<Expr> getAssertions() {
    final vec = _c._z3.solver_get_assertions(_solver);
    return _c._unpackAstVector(vec).cast();
  }

  List<Expr> getUnits() {
    final vec = _c._z3.solver_get_units(_solver);
    return _c._unpackAstVector(vec).cast();
  }

  List<Expr> getTrail() {
    final vec = _c._z3.solver_get_trail(_solver);
    return _c._unpackAstVector(vec).cast();
  }

  List<Expr> getNonUnits() {
    final vec = _c._z3.solver_get_non_units(_solver);
    return _c._unpackAstVector(vec).cast();
  }

  Expr congruenceRoot(Expr a) {
    return _c._getExpr(_c._z3.solver_congruence_root(
      _solver,
      _c._createAST(a),
    ));
  }

  Expr congruenceNext(Expr a) {
    return _c._getExpr(_c._z3.solver_congruence_next(
      _solver,
      _c._createAST(a),
    ));
  }

  bool? check() {
    return _c._maybeBool(_c._z3.solver_check(_solver));
  }

  Model ensureSat() {
    final result = check();
    if (result == false) {
      final core = getUnsatCore();
      throw Exception('Not satisfiable: $core');
    } else if (result == null) {
      final reason = getReasonUnknown();
      throw Exception('Unknown satisfiability: $reason');
    }
    return getModel();
  }

  void ensureUnsat() {
    final result = check();
    if (result == true) {
      final model = getModel();
      throw Exception('Not unsatisfiable: $model');
    } else if (result == null) {
      final reason = getReasonUnknown();
      throw Exception('Unknown satisfiability: $reason');
    }
  }

  bool? checkAssumptions(List<AST> assumptions) {
    final assumptionsPtr = calloc<Z3_ast>(assumptions.length);
    try {
      for (var i = 0; i < assumptions.length; i++) {
        assumptionsPtr[i] = _c._createAST(assumptions[i]);
      }
      final result = _c._maybeBool(_c._z3.solver_check_assumptions(
        _solver,
        assumptions.length,
        assumptionsPtr,
      ));
      return result;
    } finally {
      malloc.free(assumptionsPtr);
    }
  }

  List<int>? getImpliedEqualities(List<Expr> terms) {
    final termsPtr = calloc<Z3_ast>(terms.length);
    final classIdsPtr = calloc<UnsignedInt>(terms.length);
    try {
      for (var i = 0; i < terms.length; i++) {
        termsPtr[i] = _c._createAST(terms[i]);
      }
      final result = _c._bool(_c._z3.get_implied_equalities(
        _solver,
        terms.length,
        termsPtr,
        classIdsPtr,
      ));
      final classIds = <int>[];
      for (var i = 0; i < terms.length; i++) {
        classIds.add(classIdsPtr[i]);
      }
      if (result == false) {
        return null;
      }
      return classIds;
    } finally {
      malloc.free(termsPtr);
      malloc.free(classIdsPtr);
    }
  }

  List<Expr>? getConsequences(List<Expr> assumptions, List<Expr> variables) {
    final assumptionsVec = _c._packAstVector(assumptions);
    _c._z3.ast_vector_inc_ref(assumptionsVec);
    final variablesVec = _c._packAstVector(variables);
    _c._z3.ast_vector_inc_ref(variablesVec);
    final consequencesVec = _c._z3.mk_ast_vector();
    _c._z3.ast_vector_inc_ref(consequencesVec);
    final result = _c._bool(_c._z3.solver_get_consequences(
      _solver,
      assumptionsVec,
      variablesVec,
      consequencesVec,
    ));
    final consequences = _c._unpackAstVector(consequencesVec).cast<Expr>();
    _c._z3.ast_vector_dec_ref(assumptionsVec);
    _c._z3.ast_vector_dec_ref(variablesVec);
    _c._z3.ast_vector_dec_ref(consequencesVec);
    if (result == false) {
      return null;
    }
    return consequences;
  }

  List<AST> cube(List<Expr> variables, int backtrackLevel) {
    final variablesVec = _c._packAstVector(variables);
    _c._z3.ast_vector_inc_ref(variablesVec);
    final result = _c._unpackAstVector(_c._z3.solver_cube(
      _solver,
      variablesVec,
      backtrackLevel,
    ));
    _c._z3.ast_vector_dec_ref(variablesVec);
    return result.cast();
  }

  Model getModel() {
    final result = _c._z3.solver_get_model(_solver);
    return _c._getModel(result);
  }

  Expr getProof() {
    return _c._getExpr(_c._z3.solver_get_proof(_solver));
  }

  List<Expr> getUnsatCore() {
    final result = _c._z3.solver_get_unsat_core(_solver);
    return _c._unpackAstVector(result).cast();
  }

  String getReasonUnknown() {
    return _c._z3
        .solver_get_reason_unknown(_solver)
        .cast<Utf8>()
        .toDartString();
  }

  Stats getStats() {
    return _c._getStats(_c._z3.solver_get_statistics(_solver));
  }

  @override
  String toString() {
    return _c._z3.solver_to_string(_solver).cast<Utf8>().toDartString();
  }

  String toDimacs({bool includeNames = true}) {
    return _c._z3
        .solver_to_dimacs_string(_solver, includeNames)
        .cast<Utf8>()
        .toDartString();
  }
}

class Stats {
  Stats._(this._c, this._stats);

  final Context _c;
  final Z3_stats _stats;

  Map<String, num> getData() {
    final result = <String, num>{};
    final size = _c._z3.stats_size(_stats);
    for (var i = 0; i < size; i++) {
      final key = _c._z3.stats_get_key(_stats, i).cast<Utf8>().toDartString();
      if (_c._z3.stats_is_uint(_stats, i)) {
        result[key] = _c._z3.stats_get_uint_value(
          _stats,
          i,
        );
      } else if (_c._z3.stats_is_double(_stats, i)) {
        result[key] = _c._z3.stats_get_double_value(
          _stats,
          i,
        );
      } else {
        throw AssertionError('Unknown stat type at index $i');
      }
    }
    return result;
  }

  @override
  String toString() {
    return _c._z3.stats_to_string(_stats).cast<Utf8>().toDartString();
  }
}

class Bound {
  Bound({
    required this.infinity,
    required this.rational,
    required this.infinitesimal,
  });

  final Rat infinity;
  final Rat rational;
  final Rat infinitesimal;
}

class OptimizeObjective {
  OptimizeObjective({
    required this.lowerBound,
    required this.lowerValue,
    required this.upperBound,
    required this.upperValue,
    required this.objective,
  });

  final Bound lowerBound;
  final AST lowerValue;
  final Bound upperBound;
  final AST upperValue;
  final AST objective;
}

class Optimize {
  Optimize._(this._c, this._optimize) {
    _instances[_optimize] = WeakReference(this);
    _finalizer.attach(this, _optimize);
  }

  final Context _c;
  final Z3_optimize _optimize;

  static final _instances = <Z3_optimize, WeakReference<Optimize>>{};
  static final _finalizer = Finalizer<Z3_optimize>((e) {
    _instances.remove(e);
  });

  void add(AST a, {Expr? constant}) {
    if (constant != null) {
      _c._z3.optimize_assert_and_track(
        _optimize,
        _c._createAST(a),
        _c._createAST(constant),
      );
    } else {
      _c._z3.optimize_assert(_optimize, _c._createAST(a));
    }
  }

  int addSoft(AST a, {required Rat weight, required Sym id}) {
    final weightPtr = '$weight'.toNativeUtf8();
    try {
      return _c._z3.optimize_assert_soft(
        _optimize,
        _c._createAST(a),
        weightPtr.cast(),
        _c._createSymbol(id),
      );
    } finally {
      malloc.free(weightPtr);
    }
  }

  int maximize(AST a) {
    return _c._z3.optimize_maximize(_optimize, _c._createAST(a));
  }

  int minimize(AST a) {
    return _c._z3.optimize_minimize(_optimize, _c._createAST(a));
  }

  void push() {
    _c._z3.optimize_push(_optimize);
  }

  void pop() {
    _c._z3.optimize_pop(_optimize);
  }

  bool? check([List<AST> assumptions = const []]) {
    final assumptionsPtr = calloc<Z3_ast>(assumptions.length);
    try {
      for (var i = 0; i < assumptions.length; i++) {
        assumptionsPtr[i] = _c._createAST(assumptions[i]);
      }
      final result = _c._maybeBool(_c._z3.optimize_check(
        _optimize,
        assumptions.length,
        assumptionsPtr,
      ));
      return result;
    } finally {
      malloc.free(assumptionsPtr);
    }
  }

  String getReasonUnknown() {
    return _c._z3
        .optimize_get_reason_unknown(_optimize)
        .cast<Utf8>()
        .toDartString();
  }

  Model getModel() {
    final result = _c._z3.optimize_get_model(_optimize);
    return _c._getModel(result);
  }

  List<Expr> getUnsatCore() {
    final result = _c._z3.optimize_get_unsat_core(_optimize);
    return _c._unpackAstVector(result).cast();
  }

  void setParams(Params params) {
    _c._z3.optimize_set_params(_optimize, params._params);
  }

  ParamDescs getParamDescriptions() {
    return _c
        ._getParamDescriptions(_c._z3.optimize_get_param_descrs(_optimize));
  }

  void addSmtlib(String str) {
    final strPtr = str.toNativeUtf8();
    try {
      _c._z3.optimize_from_string(_optimize, strPtr.cast());
    } finally {
      malloc.free(strPtr);
    }
  }

  void addSmtlibFile(File file) {
    final pathPtr = file.path.toNativeUtf8();
    try {
      _c._z3.optimize_from_file(_optimize, pathPtr.cast());
    } finally {
      malloc.free(pathPtr);
    }
  }

  String getHelp() {
    return _c._z3.optimize_get_help(_optimize).cast<Utf8>().toDartString();
  }

  Stats getStats() {
    return _c._getStats(_c._z3.optimize_get_statistics(_optimize));
  }

  List<Expr> getAssertions() {
    final vec = _c._z3.optimize_get_assertions(_optimize);
    return _c._unpackAstVector(vec).cast();
  }

  List<OptimizeObjective> getObjectives() {
    final objectives = _c._unpackAstVector(
      _c._z3.optimize_get_objectives(_optimize),
    );
    final result = <OptimizeObjective>[];
    for (var i = 0; i < objectives.length; i++) {
      final objective = objectives[i];
      final lower = _c
          ._unpackAstVector(_c._z3.optimize_get_lower_as_vector(_optimize, i))
          .cast<Numeral>();
      final upper = _c
          ._unpackAstVector(_c._z3.optimize_get_upper_as_vector(_optimize, i))
          .cast<Numeral>();
      final lowerValue = _c._getAST(_c._z3.optimize_get_lower(_optimize, i));
      final upperValue = _c._getAST(_c._z3.optimize_get_upper(_optimize, i));
      result.add(
        OptimizeObjective(
          lowerBound: Bound(
            infinity: lower[0].toRat(),
            rational: lower[1].toRat(),
            infinitesimal: lower[2].toRat(),
          ),
          lowerValue: lowerValue,
          upperBound: Bound(
            infinity: upper[0].toRat(),
            rational: upper[1].toRat(),
            infinitesimal: upper[2].toRat(),
          ),
          upperValue: upperValue,
          objective: objective,
        ),
      );
    }
    return result;
  }

  @override
  String toString() {
    return _c._z3.optimize_to_string(_optimize).cast<Utf8>().toDartString();
  }
}

class ParamDesc {
  ParamDesc(this.name, this.kind, this.docs);

  final Sym name;
  final ParamKind kind;
  final String docs;
}

class ParamDescs extends ListBase<ParamDesc> {
  ParamDescs._(this.context, this._desc);
  final Context context;
  final Z3_param_descrs _desc;

  ParamKind getKind(Sym key) {
    final kind = context._z3.param_descrs_get_kind(
      _desc,
      context._createSymbol(key),
    );
    if (kind == Z3_param_kind.PK_BOOL) {
      return ParamKind.bool;
    } else if (kind == Z3_param_kind.PK_DOUBLE) {
      return ParamKind.double;
    } else if (kind == Z3_param_kind.PK_INVALID) {
      return ParamKind.invalid;
    } else if (kind == Z3_param_kind.PK_OTHER) {
      return ParamKind.other;
    } else if (kind == Z3_param_kind.PK_STRING) {
      return ParamKind.string;
    } else if (kind == Z3_param_kind.PK_SYMBOL) {
      return ParamKind.symbol;
    } else if (kind == Z3_param_kind.PK_UINT) {
      return ParamKind.uint;
    } else {
      throw AssertionError('Unknown param kind: $kind');
    }
  }

  String getDocs(Sym key) => context._z3
      .param_descrs_get_documentation(_desc, context._createSymbol(key))
      .cast<Utf8>()
      .toDartString();

  late final List<Sym> allKeys = () {
    final count = context._z3.param_descrs_size(_desc);
    final result = <Sym>[];
    for (var i = 0; i < count; i++) {
      final symbol = context._z3.param_descrs_get_name(_desc, i);
      result.add(context._getSymbol(symbol));
    }
    return result;
  }();

  @override
  String toString() =>
      context._z3.param_descrs_to_string(_desc).cast<Utf8>().toDartString();

  @override
  int get length => allKeys.length;

  @override
  ParamDesc operator [](int index) {
    final key = allKeys[index];
    return ParamDesc(
      key,
      getKind(key),
      getDocs(key),
    );
  }

  @override
  void operator []=(int index, ParamDesc value) {
    throw UnsupportedError('ParamDescriptions is immutable');
  }

  @override
  set length(int newLength) {
    throw UnsupportedError('ParamDescriptions is immutable');
  }
}

class ExternalParameter {
  const ExternalParameter._();
  @override
  String toString() => 'external';
}

typedef Parameter
    = /* int | double | Rat | Z3Symbol | Sort | AST | FuncDecl | ExternalParameter */ Object;

abstract class AST {
  Z3_ast build(Context c);
}

abstract class Expr extends AST {}

class App extends Expr {
  factory App(FuncDecl decl, List<Expr> args) {
    if (args.isEmpty) {
      return ConstVar.func(decl);
    }
    return App._(decl, args);
  }
  App._(this.decl, this.args, [this._context, this._cached]);

  final FuncDecl decl;
  final List<Expr> args;
  final Context? _context;
  final Z3_ast? _cached;

  @override
  Z3_ast build(Context c) {
    if (_cached != null) {
      return _context!._translateTo(c, this, _cached!);
    }
    final argsPtr = calloc<Z3_ast>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = c._createAST(args[i]);
      }
      final result = c._z3.mk_app(
        c._createFuncDecl(decl),
        args.length,
        argsPtr,
      );
      return result.cast();
    } finally {
      malloc.free(argsPtr);
    }
  }

  @override
  String toString() => args.isEmpty
      ? 'app(${decl.name})'
      : 'app(${decl.name}, ${args.join(', ')})';
}

class ConstVar extends App {
  ConstVar(Sym name, Sort sort) : super._(Func(name, [], sort), []);
  ConstVar.func(FuncDecl decl) : super._(decl, []);

  @override
  String toString() => 'const(${decl.name})';
}

class Pat extends Expr {
  Pat(this.terms);

  final List<Expr> terms;

  @override
  Z3_ast build(Context c) {
    final termsPtr = calloc<Z3_ast>(terms.length);
    try {
      for (var i = 0; i < terms.length; i++) {
        termsPtr[i] = c._createAST(terms[i]);
      }
      final result = c._z3.mk_pattern(terms.length, termsPtr);
      return result.cast();
    } finally {
      malloc.free(termsPtr);
    }
  }

  @override
  String toString() {
    return 'pat(${terms.join(', ')})';
  }
}

enum NullaryOpKind {
  // Logic
  trueExpr,
  falseExpr,

  // Floating Point
  fpaRne,
  fpaRna,
  fpaRtp,
  fpaRtn,
  fpaRtz;

  static NullaryOpKind? _fromFuncKind(FuncKind kind) {
    switch (kind) {
      case FuncKind.trueFunc:
        return NullaryOpKind.trueExpr;
      case FuncKind.falseFunc:
        return NullaryOpKind.falseExpr;
      case FuncKind.fpaRmNearestTiesToEven:
        return NullaryOpKind.fpaRne;
      case FuncKind.fpaRmNearestTiesToAway:
        return NullaryOpKind.fpaRna;
      case FuncKind.fpaRmTowardPositive:
        return NullaryOpKind.fpaRtp;
      case FuncKind.fpaRmTowardNegative:
        return NullaryOpKind.fpaRtn;
      case FuncKind.fpaRmTowardZero:
        return NullaryOpKind.fpaRtz;
      default:
        return null;
    }
  }
}

class NullaryOp extends Expr {
  NullaryOp(this.kind);

  final NullaryOpKind kind;

  @override
  Z3_ast build(Context c) {
    switch (kind) {
      case NullaryOpKind.trueExpr:
        return c._trueExpr;
      case NullaryOpKind.falseExpr:
        return c._falseExpr;
      case NullaryOpKind.fpaRne:
        return c._fpaRne;
      case NullaryOpKind.fpaRna:
        return c._fpaRna;
      case NullaryOpKind.fpaRtp:
        return c._fpaRtp;
      case NullaryOpKind.fpaRtn:
        return c._fpaRtn;
      case NullaryOpKind.fpaRtz:
        return c._fpaRtz;
    }
  }

  @override
  String toString() {
    return kind.name;
  }
}

enum UnaryOpKind {
  // Logic
  not,

  // Arithmetic
  unaryMinus,
  intToReal,
  realToInt,
  isInt,

  // Bit Vectors
  bvNot,
  bvRedAnd,
  bvRedOr,
  bvNeg,

  // Arrays
  arrayDefault,

  // Sets
  setComplement,

  // Sequences
  seqUnit,
  seqLength,
  strToInt,
  intToStr,
  strToCode,
  codeToStr,
  ubvToStr,
  sbvToStr,
  seqToRe,
  rePlus,
  reStar,
  reOption,
  reComplement,
  charToInt,
  charToBv,
  bvToChar,
  charIsDigit,

  // Floating Point
  fpaAbs,
  fpaNeg,
  fpaIsNormal,
  fpaIsSubnormal,
  fpaIsZero,
  fpaIsInfinite,
  fpaIsNaN,
  fpaIsNegative,
  fpaIsPositive,
  fpaToReal,

  // Z3-specific Floating Point
  fpaToIeeeBv;

  static UnaryOpKind? _fromFuncKind(FuncKind kind) {
    switch (kind) {
      case FuncKind.not:
        return UnaryOpKind.not;
      case FuncKind.uminus:
        return UnaryOpKind.unaryMinus;
      case FuncKind.toReal:
        return UnaryOpKind.intToReal;
      case FuncKind.toInt:
        return UnaryOpKind.realToInt;
      case FuncKind.isInt:
        return UnaryOpKind.isInt;
      case FuncKind.bnot:
        return UnaryOpKind.bvNot;
      case FuncKind.bredand:
        return UnaryOpKind.bvRedAnd;
      case FuncKind.bredor:
        return UnaryOpKind.bvRedOr;
      case FuncKind.bneg:
        return UnaryOpKind.bvNeg;
      case FuncKind.arrayDefault:
        return UnaryOpKind.arrayDefault;
      case FuncKind.setComplement:
        return UnaryOpKind.setComplement;
      case FuncKind.seqUnit:
        return UnaryOpKind.seqUnit;
      case FuncKind.seqLength:
        return UnaryOpKind.seqLength;
      case FuncKind.strToInt:
        return UnaryOpKind.strToInt;
      case FuncKind.intToStr:
        return UnaryOpKind.intToStr;
      case FuncKind.strToCode:
        return UnaryOpKind.strToCode;
      case FuncKind.strFromCode:
        return UnaryOpKind.codeToStr;
      case FuncKind.ubvToStr:
        return UnaryOpKind.ubvToStr;
      case FuncKind.sbvToStr:
        return UnaryOpKind.sbvToStr;
      case FuncKind.seqToRe:
        return UnaryOpKind.seqToRe;
      case FuncKind.rePlus:
        return UnaryOpKind.rePlus;
      case FuncKind.reStar:
        return UnaryOpKind.reStar;
      case FuncKind.reOption:
        return UnaryOpKind.reOption;
      case FuncKind.reComplement:
        return UnaryOpKind.reComplement;
      case FuncKind.charToInt:
        return UnaryOpKind.charToInt;
      case FuncKind.charToBv:
        return UnaryOpKind.charToBv;
      case FuncKind.charFromBv:
        return UnaryOpKind.bvToChar;
      case FuncKind.charIsDigit:
        return UnaryOpKind.charIsDigit;
      case FuncKind.fpaAbs:
        return UnaryOpKind.fpaAbs;
      case FuncKind.fpaNeg:
        return UnaryOpKind.fpaNeg;
      case FuncKind.fpaIsNormal:
        return UnaryOpKind.fpaIsNormal;
      case FuncKind.fpaIsSubnormal:
        return UnaryOpKind.fpaIsSubnormal;
      case FuncKind.fpaIsZero:
        return UnaryOpKind.fpaIsZero;
      case FuncKind.fpaIsInf:
        return UnaryOpKind.fpaIsInfinite;
      case FuncKind.fpaIsNan:
        return UnaryOpKind.fpaIsNaN;
      case FuncKind.fpaIsNegative:
        return UnaryOpKind.fpaIsNegative;
      case FuncKind.fpaIsPositive:
        return UnaryOpKind.fpaIsPositive;
      case FuncKind.fpaToReal:
        return UnaryOpKind.fpaToReal;
      case FuncKind.fpaToIeeeBv:
        return UnaryOpKind.fpaToIeeeBv;
      default:
        return null;
    }
  }
}

class UnaryOp extends Expr {
  UnaryOp(this.kind, this.arg);

  final UnaryOpKind kind;
  final Expr arg;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    switch (kind) {
      case UnaryOpKind.not:
        return c._z3.mk_not(a);
      case UnaryOpKind.unaryMinus:
        return c._z3.mk_unary_minus(a);
      case UnaryOpKind.intToReal:
        return c._z3.mk_int2real(a);
      case UnaryOpKind.realToInt:
        return c._z3.mk_real2int(a);
      case UnaryOpKind.isInt:
        return c._z3.mk_is_int(a);
      case UnaryOpKind.bvNot:
        return c._z3.mk_bvnot(a);
      case UnaryOpKind.bvRedAnd:
        return c._z3.mk_bvredand(a);
      case UnaryOpKind.bvRedOr:
        return c._z3.mk_bvredor(a);
      case UnaryOpKind.bvNeg:
        return c._z3.mk_bvneg(a);
      case UnaryOpKind.arrayDefault:
        return c._z3.mk_array_default(a);
      case UnaryOpKind.setComplement:
        return c._z3.mk_set_complement(a);
      case UnaryOpKind.seqUnit:
        return c._z3.mk_seq_unit(a);
      case UnaryOpKind.seqLength:
        return c._z3.mk_seq_length(a);
      case UnaryOpKind.strToInt:
        return c._z3.mk_str_to_int(a);
      case UnaryOpKind.intToStr:
        return c._z3.mk_int_to_str(a);
      case UnaryOpKind.strToCode:
        return c._z3.mk_string_to_code(a);
      case UnaryOpKind.codeToStr:
        return c._z3.mk_string_from_code(a);
      case UnaryOpKind.ubvToStr:
        return c._z3.mk_ubv_to_str(a);
      case UnaryOpKind.sbvToStr:
        return c._z3.mk_sbv_to_str(a);
      case UnaryOpKind.seqToRe:
        return c._z3.mk_seq_to_re(a);
      case UnaryOpKind.rePlus:
        return c._z3.mk_re_plus(a);
      case UnaryOpKind.reStar:
        return c._z3.mk_re_star(a);
      case UnaryOpKind.reOption:
        return c._z3.mk_re_option(a);
      case UnaryOpKind.reComplement:
        return c._z3.mk_re_complement(a);
      case UnaryOpKind.charToInt:
        return c._z3.mk_char_to_int(a);
      case UnaryOpKind.charToBv:
        return c._z3.mk_char_to_bv(a);
      case UnaryOpKind.bvToChar:
        return c._z3.mk_char_from_bv(a);
      case UnaryOpKind.charIsDigit:
        return c._z3.mk_char_is_digit(a);
      case UnaryOpKind.fpaAbs:
        return c._z3.mk_fpa_abs(a);
      case UnaryOpKind.fpaNeg:
        return c._z3.mk_fpa_neg(a);
      case UnaryOpKind.fpaIsNormal:
        return c._z3.mk_fpa_is_normal(a);
      case UnaryOpKind.fpaIsSubnormal:
        return c._z3.mk_fpa_is_subnormal(a);
      case UnaryOpKind.fpaIsZero:
        return c._z3.mk_fpa_is_zero(a);
      case UnaryOpKind.fpaIsInfinite:
        return c._z3.mk_fpa_is_infinite(a);
      case UnaryOpKind.fpaIsNaN:
        return c._z3.mk_fpa_is_nan(a);
      case UnaryOpKind.fpaIsNegative:
        return c._z3.mk_fpa_is_negative(a);
      case UnaryOpKind.fpaIsPositive:
        return c._z3.mk_fpa_is_positive(a);
      case UnaryOpKind.fpaToReal:
        return c._z3.mk_fpa_to_real(a);
      case UnaryOpKind.fpaToIeeeBv:
        return c._z3.mk_fpa_to_ieee_bv(a);
    }
  }

  @override
  String toString() {
    return '${kind.name}($arg)';
  }
}

enum NaryOpKind {
  // Logic
  distinct,
  and,
  or,

  // Arithmetic
  add,
  mul,
  sub,

  // Sets
  setUnion,
  setIntersect,

  // Sequences
  seqConcat,
  reUnion,
  reConcat,
  reIntersect;

  static NaryOpKind? _fromFuncKind(FuncKind kind) {
    switch (kind) {
      case FuncKind.distinct:
        return NaryOpKind.distinct;
      case FuncKind.and:
        return NaryOpKind.and;
      case FuncKind.or:
        return NaryOpKind.or;
      case FuncKind.add:
        return NaryOpKind.add;
      case FuncKind.mul:
        return NaryOpKind.mul;
      case FuncKind.sub:
        return NaryOpKind.sub;
      case FuncKind.setUnion:
        return NaryOpKind.setUnion;
      case FuncKind.setIntersect:
        return NaryOpKind.setIntersect;
      case FuncKind.seqConcat:
        return NaryOpKind.seqConcat;
      case FuncKind.reUnion:
        return NaryOpKind.reUnion;
      case FuncKind.reConcat:
        return NaryOpKind.reConcat;
      case FuncKind.reIntersect:
        return NaryOpKind.reIntersect;
      default:
        return null;
    }
  }
}

class NaryOp extends Expr {
  NaryOp(this.kind, this.args);

  final NaryOpKind kind;
  final List<Expr> args;

  @override
  Z3_ast build(Context c) {
    final argsPtr = calloc<Z3_ast>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = c._createAST(args[i]);
      }
      final Z3_ast result;
      switch (kind) {
        case NaryOpKind.distinct:
          result = c._z3.mk_distinct(args.length, argsPtr);
        case NaryOpKind.and:
          result = c._z3.mk_and(args.length, argsPtr);
        case NaryOpKind.or:
          result = c._z3.mk_or(args.length, argsPtr);
        case NaryOpKind.add:
          result = c._z3.mk_add(args.length, argsPtr);
        case NaryOpKind.mul:
          result = c._z3.mk_mul(args.length, argsPtr);
        case NaryOpKind.sub:
          result = c._z3.mk_sub(args.length, argsPtr);
        case NaryOpKind.setUnion:
          result = c._z3.mk_set_union(args.length, argsPtr);
        case NaryOpKind.setIntersect:
          result = c._z3.mk_set_intersect(args.length, argsPtr);
        case NaryOpKind.seqConcat:
          result = c._z3.mk_seq_concat(args.length, argsPtr);
        case NaryOpKind.reUnion:
          result = c._z3.mk_re_union(args.length, argsPtr);
        case NaryOpKind.reConcat:
          result = c._z3.mk_re_concat(args.length, argsPtr);
        case NaryOpKind.reIntersect:
          result = c._z3.mk_re_intersect(args.length, argsPtr);
      }
      return result;
    } finally {
      malloc.free(argsPtr);
    }
  }

  @override
  String toString() {
    return '${kind.name}(${args.join(', ')})';
  }
}

enum BinaryOpKind {
  // Logic
  eq,
  implies,
  xor,

  // Arithmetic
  div,
  mod,
  rem,
  pow,
  lt,
  le,
  gt,
  ge,

  // Bit Vectors
  bvAnd,
  bvOr,
  bvXor,
  bvNand,
  bvNor,
  bvXnor,
  bvAdd,
  bvSub,
  bvMul,
  bvUdiv,
  bvSdiv,
  bvUrem,
  bvSrem,
  bvSmod,
  bvUlt,
  bvSlt,
  bvUle,
  bvSle,
  bvUge,
  bvSge,
  bvUgt,
  bvSgt,
  bvConcat,
  bvShl,
  bvLshr,
  bvAshr,
  bvRotl,
  bvRotr,
  bvUMulNoOverflow,
  bvSMulNoOverflow,
  bvSMulNoUnderflow,

  // Sets
  setDifference,
  setSubset,

  // Sequences
  seqPrefix,
  seqSuffix,
  seqContains,
  strLt,
  strLe,
  seqAt,
  seqNth,
  seqLastIndex,
  seqInRe,
  reRange,
  reDiff,
  charLe,

  // Floating Point
  fpaSqrt,
  fpaRem,
  fpaMin,
  fpaMax,
  fpaLeq,
  fpaLt,
  fpaGeq,
  fpaGt,
  fpaEq;

  static BinaryOpKind? _fromFuncKind(FuncKind kind) {
    switch (kind) {
      case FuncKind.eq:
        return BinaryOpKind.eq;
      case FuncKind.implies:
        return BinaryOpKind.implies;
      case FuncKind.xor:
        return BinaryOpKind.xor;
      case FuncKind.idiv:
        return BinaryOpKind.div;
      case FuncKind.mod:
        return BinaryOpKind.mod;
      case FuncKind.rem:
        return BinaryOpKind.rem;
      case FuncKind.power:
        return BinaryOpKind.pow;
      case FuncKind.lt:
        return BinaryOpKind.lt;
      case FuncKind.le:
        return BinaryOpKind.le;
      case FuncKind.gt:
        return BinaryOpKind.gt;
      case FuncKind.ge:
        return BinaryOpKind.ge;
      case FuncKind.band:
        return BinaryOpKind.bvAnd;
      case FuncKind.bor:
        return BinaryOpKind.bvOr;
      case FuncKind.bxor:
        return BinaryOpKind.bvXor;
      case FuncKind.bnand:
        return BinaryOpKind.bvNand;
      case FuncKind.bnor:
        return BinaryOpKind.bvNor;
      case FuncKind.bxnor:
        return BinaryOpKind.bvXnor;
      case FuncKind.badd:
        return BinaryOpKind.bvAdd;
      case FuncKind.bsub:
        return BinaryOpKind.bvSub;
      case FuncKind.bmul:
        return BinaryOpKind.bvMul;
      case FuncKind.budiv:
        return BinaryOpKind.bvUdiv;
      case FuncKind.bsdiv:
        return BinaryOpKind.bvSdiv;
      case FuncKind.burem:
        return BinaryOpKind.bvUrem;
      case FuncKind.bsrem:
        return BinaryOpKind.bvSrem;
      case FuncKind.bsmod:
        return BinaryOpKind.bvSmod;
      case FuncKind.ult:
        return BinaryOpKind.bvUlt;
      case FuncKind.slt:
        return BinaryOpKind.bvSlt;
      case FuncKind.uleq:
        return BinaryOpKind.bvUle;
      case FuncKind.sleq:
        return BinaryOpKind.bvSle;
      case FuncKind.ugeq:
        return BinaryOpKind.bvUge;
      case FuncKind.sgeq:
        return BinaryOpKind.bvSge;
      case FuncKind.ugt:
        return BinaryOpKind.bvUgt;
      case FuncKind.sgt:
        return BinaryOpKind.bvSgt;
      case FuncKind.concat:
        return BinaryOpKind.bvConcat;
      case FuncKind.bshl:
        return BinaryOpKind.bvShl;
      case FuncKind.blshr:
        return BinaryOpKind.bvLshr;
      case FuncKind.bashr:
        return BinaryOpKind.bvAshr;
      case FuncKind.extRotateLeft:
        return BinaryOpKind.bvRotl;
      case FuncKind.extRotateRight:
        return BinaryOpKind.bvRotr;
      case FuncKind.bumulNoOvfl:
        return BinaryOpKind.bvUMulNoOverflow;
      case FuncKind.bsmulNoOvfl:
        return BinaryOpKind.bvSMulNoOverflow;
      case FuncKind.bsmulNoUdfl:
        return BinaryOpKind.bvSMulNoUnderflow;
      case FuncKind.setDifference:
        return BinaryOpKind.setDifference;
      case FuncKind.setSubset:
        return BinaryOpKind.setSubset;
      case FuncKind.seqPrefix:
        return BinaryOpKind.seqPrefix;
      case FuncKind.seqSuffix:
        return BinaryOpKind.seqSuffix;
      case FuncKind.seqContains:
        return BinaryOpKind.seqContains;
      case FuncKind.stringLt:
        return BinaryOpKind.strLt;
      case FuncKind.stringLe:
        return BinaryOpKind.strLe;
      case FuncKind.seqAt:
        return BinaryOpKind.seqAt;
      case FuncKind.seqNth:
        return BinaryOpKind.seqNth;
      case FuncKind.internal:
        return BinaryOpKind.seqLastIndex;
      case FuncKind.seqInRe:
        return BinaryOpKind.seqInRe;
      case FuncKind.reRange:
        return BinaryOpKind.reRange;
      case FuncKind.reDiff:
        return BinaryOpKind.reDiff;
      case FuncKind.charLe:
        return BinaryOpKind.charLe;
      case FuncKind.fpaSqrt:
        return BinaryOpKind.fpaSqrt;
      case FuncKind.fpaRem:
        return BinaryOpKind.fpaRem;
      case FuncKind.fpaMin:
        return BinaryOpKind.fpaMin;
      case FuncKind.fpaMax:
        return BinaryOpKind.fpaMax;
      case FuncKind.fpaLe:
        return BinaryOpKind.fpaLeq;
      case FuncKind.fpaLt:
        return BinaryOpKind.fpaLt;
      case FuncKind.fpaGe:
        return BinaryOpKind.fpaGeq;
      case FuncKind.fpaGt:
        return BinaryOpKind.fpaGt;
      case FuncKind.fpaEq:
        return BinaryOpKind.fpaEq;
      default:
        return null;
    }
  }
}

class BinaryOp extends Expr {
  BinaryOp(this.kind, this.arg0, this.arg1);

  final BinaryOpKind kind;
  final Expr arg0;
  final Expr arg1;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    switch (kind) {
      case BinaryOpKind.eq:
        return c._z3.mk_eq(a, b);
      case BinaryOpKind.implies:
        return c._z3.mk_implies(a, b);
      case BinaryOpKind.xor:
        return c._z3.mk_xor(a, b);
      case BinaryOpKind.div:
        return c._z3.mk_div(a, b);
      case BinaryOpKind.mod:
        return c._z3.mk_mod(a, b);
      case BinaryOpKind.rem:
        return c._z3.mk_rem(a, b);
      case BinaryOpKind.pow:
        return c._z3.mk_power(a, b);
      case BinaryOpKind.lt:
        return c._z3.mk_lt(a, b);
      case BinaryOpKind.le:
        return c._z3.mk_le(a, b);
      case BinaryOpKind.gt:
        return c._z3.mk_gt(a, b);
      case BinaryOpKind.ge:
        return c._z3.mk_ge(a, b);
      case BinaryOpKind.bvAnd:
        return c._z3.mk_bvand(a, b);
      case BinaryOpKind.bvOr:
        return c._z3.mk_bvor(a, b);
      case BinaryOpKind.bvXor:
        return c._z3.mk_bvxor(a, b);
      case BinaryOpKind.bvNand:
        return c._z3.mk_bvnand(a, b);
      case BinaryOpKind.bvNor:
        return c._z3.mk_bvnor(a, b);
      case BinaryOpKind.bvXnor:
        return c._z3.mk_bvxnor(a, b);
      case BinaryOpKind.bvAdd:
        return c._z3.mk_bvadd(a, b);
      case BinaryOpKind.bvSub:
        return c._z3.mk_bvsub(a, b);
      case BinaryOpKind.bvMul:
        return c._z3.mk_bvmul(a, b);
      case BinaryOpKind.bvUdiv:
        return c._z3.mk_bvudiv(a, b);
      case BinaryOpKind.bvSdiv:
        return c._z3.mk_bvsdiv(a, b);
      case BinaryOpKind.bvUrem:
        return c._z3.mk_bvurem(a, b);
      case BinaryOpKind.bvSrem:
        return c._z3.mk_bvsrem(a, b);
      case BinaryOpKind.bvSmod:
        return c._z3.mk_bvsmod(a, b);
      case BinaryOpKind.bvUlt:
        return c._z3.mk_bvult(a, b);
      case BinaryOpKind.bvSlt:
        return c._z3.mk_bvslt(a, b);
      case BinaryOpKind.bvUle:
        return c._z3.mk_bvule(a, b);
      case BinaryOpKind.bvSle:
        return c._z3.mk_bvsle(a, b);
      case BinaryOpKind.bvUge:
        return c._z3.mk_bvuge(a, b);
      case BinaryOpKind.bvSge:
        return c._z3.mk_bvsge(a, b);
      case BinaryOpKind.bvUgt:
        return c._z3.mk_bvugt(a, b);
      case BinaryOpKind.bvSgt:
        return c._z3.mk_bvsgt(a, b);
      case BinaryOpKind.bvConcat:
        return c._z3.mk_concat(a, b);
      case BinaryOpKind.bvShl:
        return c._z3.mk_bvshl(a, b);
      case BinaryOpKind.bvLshr:
        return c._z3.mk_bvlshr(a, b);
      case BinaryOpKind.bvAshr:
        return c._z3.mk_bvashr(a, b);
      case BinaryOpKind.bvRotl:
        return c._z3.mk_ext_rotate_left(a, b);
      case BinaryOpKind.bvRotr:
        return c._z3.mk_ext_rotate_right(a, b);
      case BinaryOpKind.bvSMulNoUnderflow:
        return c._z3.mk_bvmul_no_underflow(a, b);
      case BinaryOpKind.bvUMulNoOverflow:
        return c._z3.mk_bvmul_no_overflow(a, b, false);
      case BinaryOpKind.bvSMulNoOverflow:
        return c._z3.mk_bvmul_no_overflow(a, b, true);
      case BinaryOpKind.setDifference:
        return c._z3.mk_set_difference(a, b);
      case BinaryOpKind.setSubset:
        return c._z3.mk_set_subset(a, b);
      case BinaryOpKind.seqPrefix:
        return c._z3.mk_seq_prefix(a, b);
      case BinaryOpKind.seqSuffix:
        return c._z3.mk_seq_suffix(a, b);
      case BinaryOpKind.seqContains:
        return c._z3.mk_seq_contains(a, b);
      case BinaryOpKind.strLt:
        return c._z3.mk_str_lt(a, b);
      case BinaryOpKind.strLe:
        return c._z3.mk_str_le(a, b);
      case BinaryOpKind.seqAt:
        return c._z3.mk_seq_at(a, b);
      case BinaryOpKind.seqNth:
        return c._z3.mk_seq_nth(a, b);
      case BinaryOpKind.seqLastIndex:
        return c._z3.mk_seq_last_index(a, b);
      case BinaryOpKind.seqInRe:
        return c._z3.mk_seq_in_re(a, b);
      case BinaryOpKind.reRange:
        return c._z3.mk_re_range(a, b);
      case BinaryOpKind.reDiff:
        return c._z3.mk_re_diff(a, b);
      case BinaryOpKind.charLe:
        return c._z3.mk_char_le(a, b);
      case BinaryOpKind.fpaSqrt:
        return c._z3.mk_fpa_sqrt(a, b);
      case BinaryOpKind.fpaRem:
        return c._z3.mk_fpa_rem(a, b);
      case BinaryOpKind.fpaMin:
        return c._z3.mk_fpa_min(a, b);
      case BinaryOpKind.fpaMax:
        return c._z3.mk_fpa_max(a, b);
      case BinaryOpKind.fpaLeq:
        return c._z3.mk_fpa_leq(a, b);
      case BinaryOpKind.fpaLt:
        return c._z3.mk_fpa_lt(a, b);
      case BinaryOpKind.fpaGeq:
        return c._z3.mk_fpa_geq(a, b);
      case BinaryOpKind.fpaGt:
        return c._z3.mk_fpa_gt(a, b);
      case BinaryOpKind.fpaEq:
        return c._z3.mk_fpa_eq(a, b);
    }
  }

  @override
  String toString() {
    return '${kind.name}($arg0, $arg1)';
  }
}

enum TernaryOpKind {
  // Logic
  ite,

  // Arrays
  store,

  // Sequences
  seqExtract,
  seqReplace,
  seqIndex,

  // Floating Point
  fpaFp,
  fpaAdd,
  fpaSub,
  fpaMul,
  fpaDiv;

  static TernaryOpKind? _fromFuncKind(FuncKind kind) {
    switch (kind) {
      case FuncKind.ite:
        return TernaryOpKind.ite;
      case FuncKind.store:
        return TernaryOpKind.store;
      case FuncKind.seqExtract:
        return TernaryOpKind.seqExtract;
      case FuncKind.seqReplace:
        return TernaryOpKind.seqReplace;
      case FuncKind.seqIndex:
        return TernaryOpKind.seqIndex;
      case FuncKind.fpaFp:
        return TernaryOpKind.fpaFp;
      case FuncKind.fpaAdd:
        return TernaryOpKind.fpaAdd;
      case FuncKind.fpaSub:
        return TernaryOpKind.fpaSub;
      case FuncKind.fpaMul:
        return TernaryOpKind.fpaMul;
      case FuncKind.fpaDiv:
        return TernaryOpKind.fpaDiv;
      default:
        return null;
    }
  }
}

class TernaryOp extends Expr {
  TernaryOp(this.kind, this.arg0, this.arg1, this.arg2);

  final TernaryOpKind kind;
  final Expr arg0;
  final Expr arg1;
  final Expr arg2;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    final d = c._createAST(arg2);
    switch (kind) {
      case TernaryOpKind.ite:
        return c._z3.mk_ite(a, b, d);
      case TernaryOpKind.store:
        return c._z3.mk_store(a, b, d);
      case TernaryOpKind.seqExtract:
        return c._z3.mk_seq_extract(a, b, d);
      case TernaryOpKind.seqReplace:
        return c._z3.mk_seq_replace(a, b, d);
      case TernaryOpKind.seqIndex:
        return c._z3.mk_seq_index(a, b, d);
      case TernaryOpKind.fpaFp:
        final sort = c.getSort(arg0);
        assert(sort is BitVecSort && sort.size == 1);
        return c._z3.mk_fpa_fp(a, b, d);
      case TernaryOpKind.fpaAdd:
        return c._z3.mk_fpa_add(a, b, d);
      case TernaryOpKind.fpaSub:
        return c._z3.mk_fpa_sub(a, b, d);
      case TernaryOpKind.fpaMul:
        return c._z3.mk_fpa_mul(a, b, d);
      case TernaryOpKind.fpaDiv:
        return c._z3.mk_fpa_div(a, b, d);
    }
  }

  @override
  String toString() {
    return '${kind.name}($arg0, $arg1, $arg2)';
  }
}

enum QuaternaryOpKind {
  // Sequences
  fpaFma;

  static QuaternaryOpKind? _fromFuncKind(FuncKind kind) {
    switch (kind) {
      case FuncKind.fpaFma:
        return QuaternaryOpKind.fpaFma;
      default:
        return null;
    }
  }
}

class QuaternaryOp extends Expr {
  QuaternaryOp(this.kind, this.arg0, this.arg1, this.arg2, this.arg3);

  final QuaternaryOpKind kind;
  final Expr arg0;
  final Expr arg1;
  final Expr arg2;
  final Expr arg3;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    final d = c._createAST(arg2);
    final e = c._createAST(arg3);
    switch (kind) {
      case QuaternaryOpKind.fpaFma:
        return c._z3.mk_fpa_fma(a, b, d, e);
    }
  }
}

enum PUnaryOpKind {
  signExt,
  zeroExt,
  repeat,
  bitToBool,
  rotateLeft,
  rotateRight,
  intToBv;

  static PUnaryOpKind? _fromFuncKind(FuncKind kind) {
    switch (kind) {
      case FuncKind.signExt:
        return PUnaryOpKind.signExt;
      case FuncKind.zeroExt:
        return PUnaryOpKind.zeroExt;
      case FuncKind.repeat:
        return PUnaryOpKind.repeat;
      case FuncKind.bitTobool:
        return PUnaryOpKind.bitToBool;
      case FuncKind.rotateLeft:
        return PUnaryOpKind.rotateLeft;
      case FuncKind.rotateRight:
        return PUnaryOpKind.rotateRight;
      case FuncKind.intToBv:
        return PUnaryOpKind.intToBv;
      default:
        return null;
    }
  }
}

class PUnaryOp extends Expr {
  PUnaryOp(this.kind, this.arg, this.param);

  final PUnaryOpKind kind;
  final Expr arg;
  final int param;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    switch (kind) {
      case PUnaryOpKind.signExt:
        return c._z3.mk_sign_ext(param, a);
      case PUnaryOpKind.zeroExt:
        return c._z3.mk_zero_ext(param, a);
      case PUnaryOpKind.repeat:
        return c._z3.mk_repeat(param, a);
      case PUnaryOpKind.bitToBool:
        return c._z3.mk_bit2bool(param, a);
      case PUnaryOpKind.rotateLeft:
        return c._z3.mk_rotate_left(param, a);
      case PUnaryOpKind.rotateRight:
        return c._z3.mk_rotate_right(param, a);
      case PUnaryOpKind.intToBv:
        return c._z3.mk_int2bv(param, a);
    }
  }
}

class BvExtract extends Expr {
  BvExtract(this.high, this.low, this.arg);

  final int high;
  final int low;
  final Expr arg;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return c._z3.mk_extract(high, low, a);
  }
}

class BvToInt extends Expr {
  BvToInt(this.arg, this.signed);

  final Expr arg;
  final bool signed;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return c._z3.mk_bv2int(a, signed);
  }
}

class ArraySelect extends Expr {
  ArraySelect(this.array, this.indices);

  final Expr array;
  final List<Expr> indices;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(array);
    final indicesPtr = calloc<Z3_ast>(indices.length);
    try {
      for (var i = 0; i < indices.length; i++) {
        indicesPtr[i] = c._createAST(indices[i]);
      }
      final result = c._z3.mk_select_n(a, indices.length, indicesPtr);
      return result;
    } finally {
      malloc.free(indicesPtr);
    }
  }

  @override
  String toString() {
    return '$array[$indices]';
  }
}

class ArrayStore extends Expr {
  ArrayStore(this.array, this.indices, this.value);

  final Expr array;
  final List<Expr> indices;
  final Expr value;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(array);
    final indicesPtr = calloc<Z3_ast>(indices.length);
    try {
      for (var i = 0; i < indices.length; i++) {
        indicesPtr[i] = c._createAST(indices[i]);
      }
      final result = c._z3.mk_store_n(
        a,
        indices.length,
        indicesPtr,
        c._createAST(value),
      );
      return result;
    } finally {
      malloc.free(indicesPtr);
    }
  }
}

class ArrayMap extends Expr {
  ArrayMap(this.mapFn, this.arrays);

  final FuncDecl mapFn;
  final List<AST> arrays;

  @override
  Z3_ast build(Context c) {
    final a = c._createFuncDecl(mapFn);
    final arraysPtr = calloc<Z3_ast>(arrays.length);
    try {
      for (var i = 0; i < arrays.length; i++) {
        arraysPtr[i] = c._createAST(arrays[i]);
      }
      final result = c._z3.mk_map(a, arrays.length, arraysPtr);
      return result;
    } finally {
      malloc.free(arraysPtr);
    }
  }
}

class AsArray extends Expr {
  AsArray(this.func);

  final FuncDecl func;

  @override
  Z3_ast build(Context c) => c._z3.mk_as_array(c._createFuncDecl(func));
}

class EmptySet extends Expr {
  EmptySet(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => c._z3.mk_empty_set(c._createSort(sort));
}

class FullSet extends Expr {
  FullSet(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => c._z3.mk_full_set(c._createSort(sort));
}

abstract class Numeral extends Expr {
  Numeral._(this._c, this._n, this.sort);

  final Context _c;
  final Z3_ast _n;
  final Sort sort;

  bool get isPositive;
  bool get isNegative;
  bool get isZero;
  int get sign;
  bool get isInf => false;
  bool get isNaN => false;
  bool get isNormal => false;
  bool get isSubnormal => false;

  bool equals(Numeral other) => _c._z3.algebraic_eq(_n, other._n);
  bool notEquals(Numeral other) => _c._z3.algebraic_neq(_n, other._n);

  @override
  Z3_ast build(Context c) => _c._translateTo(c, this, _n);

  @override
  String toString() => _c._z3.ast_to_string(_n).cast<Utf8>().toDartString();

  BigInt toBigInt() => toRat().toBigInt();
  int toInt() => toBigInt().toInt();
  double toDouble() => toRat().toDouble();
  Rat toRat();
}

class FloatNumeral extends Numeral {
  FloatNumeral._(
    Context c,
    Z3_ast n,
    FloatSort s,
    this.value,
    this.isNegative,
  ) : super._(c, n, s);

  factory FloatNumeral.from(num value, FloatSort sort) {
    final n = _mathContext._z3.mk_fpa_numeral_double(
      value.toDouble(),
      _mathContext._createSort(sort),
    );
    return _mathContext._getAST(n) as FloatNumeral;
  }

  @override
  FloatSort get sort => super.sort as FloatSort;
  final double value;

  @override
  bool get isNaN => _c._z3.fpa_is_numeral_nan(_n);

  @override
  bool get isInf => _c._z3.fpa_is_numeral_inf(_n);

  @override
  bool get isZero => _c._z3.fpa_is_numeral_zero(_n);

  @override
  bool get isNormal => _c._z3.fpa_is_numeral_normal(_n);

  @override
  bool get isSubnormal => _c._z3.fpa_is_numeral_subnormal(_n);

  @override
  bool get isPositive => !isNegative;

  @override
  final bool isNegative;

  @override
  int get sign {
    final resultPtr = calloc<Int>();
    try {
      final success = _c._z3.fpa_get_numeral_sign(_n, resultPtr);
      assert(success);
      return resultPtr.value;
    } finally {
      malloc.free(resultPtr);
    }
  }

  late final BigInt? significand = () {
    if (isNaN) return null;
    final resultPtr = calloc<Uint64>();
    try {
      final result = _c._z3.fpa_get_numeral_significand_uint64(
        _n,
        resultPtr,
      );
      if (!result) return null;
      final resultValue = BigInt.from(resultPtr.value);
      return resultValue < BigInt.zero ? -resultValue : resultValue;
    } finally {
      malloc.free(resultPtr);
    }
  }();

  @override
  String toString() => '$value';

  @override
  Rat toRat() => Rat.fromDouble(value);

  @override
  double toDouble() => value;

  BitVecNumeral getSignBv() {
    final result = _c._z3.fpa_get_numeral_sign_bv(_n);
    return _c._getAST(result) as BitVecNumeral;
  }

  BitVecNumeral getSignificandBv() {
    final result = _c._z3.fpa_get_numeral_significand_bv(_n);
    return _c._getAST(result) as BitVecNumeral;
  }
}

class BitVecNumeral extends Numeral {
  factory BitVecNumeral(BigInt value, BitVecSort sort) {
    if (value.isValidInt) {
      final n = _mathContext._z3.mk_int64(
        value.toInt(),
        _mathContext._createSort(sort),
      );
      return _mathContext._getAST(n) as BitVecNumeral;
    } else {
      final valuePtr = '$value'.toNativeUtf8();
      try {
        final n = _mathContext._z3.mk_numeral(
          valuePtr.cast(),
          _mathContext._createSort(sort),
        );
        return _mathContext._getAST(n) as BitVecNumeral;
      } finally {
        malloc.free(valuePtr);
      }
    }
  }
  BitVecNumeral._(Context c, Z3_ast n, BitVecSort s, this.value)
      : super._(c, n, s);

  factory BitVecNumeral.from(int value, {int size = 64}) {
    return BitVecNumeral(
      BigInt.from(value).toUnsigned(size),
      BitVecSort(size),
    );
  }

  @override
  BitVecSort get sort => super.sort as BitVecSort;
  final BigInt value;

  @override
  String toString() => '0x${value.toRadixString(16)}[0:${sort.size}]';

  @override
  BigInt toBigInt() => value;

  @override
  Rat toRat() => Rat.fromBigInt(value);

  @override
  bool get isNegative => false;

  @override
  bool get isPositive => true;

  @override
  int get sign => value.sign;

  @override
  bool get isZero => value == BigInt.zero;
}

abstract class AlgebraicNumeral extends Numeral {
  AlgebraicNumeral._(Context c, Z3_ast n, Sort s) : super._(c, n, s);

  @override
  bool get isPositive => _c._z3.algebraic_is_pos(_n);

  @override
  bool get isNegative => _c._z3.algebraic_is_neg(_n);

  @override
  bool get isZero => _c._z3.algebraic_is_zero(_n);

  @override
  bool get isInf => false;

  @override
  bool get isNaN => false;

  @override
  bool get isNormal => false;

  @override
  bool get isSubnormal => false;

  @override
  int get sign => _c._z3.algebraic_sign(_n);

  AlgebraicNumeral operator +(AlgebraicNumeral other) =>
      _c._getAlgebraicNumeral(_c._z3.algebraic_add(_n, other._n));

  AlgebraicNumeral operator -(AlgebraicNumeral other) =>
      _c._getAlgebraicNumeral(_c._z3.algebraic_sub(_n, other._n));

  AlgebraicNumeral operator *(AlgebraicNumeral other) =>
      _c._getAlgebraicNumeral(_c._z3.algebraic_mul(_n, other._n));

  AlgebraicNumeral operator /(AlgebraicNumeral other) =>
      _c._getAlgebraicNumeral(_c._z3.algebraic_div(_n, other._n));

  AlgebraicNumeral root(int k) =>
      _c._getAlgebraicNumeral(_c._z3.algebraic_root(_n, k));

  AlgebraicNumeral sqrt() => root(2);

  AlgebraicNumeral pow(int k) =>
      _c._getAlgebraicNumeral(_c._z3.algebraic_power(_n, k));

  bool operator >(AlgebraicNumeral other) => _c._z3.algebraic_gt(_n, other._n);
  bool operator >=(AlgebraicNumeral other) => _c._z3.algebraic_ge(_n, other._n);
  bool operator <(AlgebraicNumeral other) => _c._z3.algebraic_lt(_n, other._n);
  bool operator <=(AlgebraicNumeral other) => _c._z3.algebraic_le(_n, other._n);
}

class RatNumeral extends AlgebraicNumeral {
  factory RatNumeral(Rat value) {
    if (value.n.isValidInt && value.d.isValidInt) {
      final ast = _mathContext._z3.mk_real_int64(
        value.n.toInt(),
        value.d.toInt(),
      );
      return _mathContext._getAST(ast) as RatNumeral;
    }
    final valuePtr = '$value'.toNativeUtf8();
    try {
      final ast = _mathContext._z3.mk_numeral(
        valuePtr.cast(),
        _mathContext._realSort,
      );
      return _mathContext._getAST(ast) as RatNumeral;
    } finally {
      malloc.free(valuePtr);
    }
  }
  RatNumeral._(Context c, Z3_ast n, Sort s, this.value) : super._(c, n, s);

  final Rat value;

  @override
  Rat toRat() => value;

  @override
  String toString() => '$value';
}

class IntNumeral extends AlgebraicNumeral {
  factory IntNumeral(BigInt value) {
    if (value.isValidInt) {
      final ast = _mathContext._z3.mk_int64(
        value.toInt(),
        _mathContext._intSort,
      );
      return _mathContext._getAST(ast) as IntNumeral;
    }
    final valuePtr = '$value'.toNativeUtf8();
    try {
      final ast = _mathContext._z3.mk_numeral(
        valuePtr.cast(),
        _mathContext._intSort,
      );
      return _mathContext._getAST(ast) as IntNumeral;
    } finally {
      malloc.free(valuePtr);
    }
  }
  IntNumeral._(Context c, Z3_ast n, this.value) : super._(c, n, IntSort());

  static IntNumeral get zero => IntNumeral(BigInt.zero);
  static IntNumeral get one => IntNumeral(BigInt.one);

  factory IntNumeral.from(int value) => IntNumeral(BigInt.from(value));

  @override
  IntSort get sort => super.sort as IntSort;

  final BigInt value;

  @override
  Rat toRat() => Rat.fromBigInt(value);
}

class IrrationalNumeral extends AlgebraicNumeral {
  IrrationalNumeral._(Context c, Z3_ast n, Sort s) : super._(c, n, s);

  List<Rat> getCoefficients() {
    final result = _c._z3.algebraic_get_poly(_n);
    return _c
        ._unpackAstVector(result)
        .cast<AlgebraicNumeral>()
        .map((e) => e.toRat())
        .toList();
  }

  int evalPolySign(List<Numeral> vs) {
    final vsPtr = calloc<Z3_ast>(vs.length);
    try {
      for (var i = 0; i < vs.length; i++) {
        vsPtr[i] = vs[i]._n;
      }
      final result = _c._z3.algebraic_eval(_n, vs.length, vsPtr);
      return result;
    } finally {
      malloc.free(vsPtr);
    }
  }

  int getRoot() => _c._z3.algebraic_get_i(_n);

  @override
  String toString() {
    final coeffs = getCoefficients();
    String mono(Rat n, int k, bool first) {
      if (k == 0) {
        return '$n';
      }
      if (n == Rat.one) {
        if (k == 1) {
          return 'x';
        } else {
          return 'x ^ $k';
        }
      } else {
        final n2 = first ? n : n.abs();
        if (k == 1) {
          return '$n2 * x';
        } else {
          return '$n2 * x ^ $k';
        }
      }
    }

    final nonzero = List.generate(coeffs.length, (i) => i)
        .where((i) => !coeffs[i].isZero)
        .toList();
    if (nonzero.length == 1) {
      return 'irrational(${mono(
        coeffs[nonzero[0]],
        nonzero[0],
        true,
      )})';
    }
    final result = StringBuffer('irrational(');
    for (var i = 0; i < nonzero.length; i++) {
      final ni = nonzero[i];
      final coeff = coeffs[ni];
      if (i != 0) {
        if (coeff.isNegative) {
          result.write(' - ');
        } else {
          result.write(' + ');
        }
      }
      result.write(mono(coeff, ni, i == 0));
    }
    result.write(')');
    return '$result';
  }

  RatNumeral getLower([int precision = 15]) {
    final result = _c._z3.get_algebraic_number_lower(_n, precision);
    return _c._getAST(result) as RatNumeral;
  }

  RatNumeral getUpper([int precision = 15]) {
    final result = _c._z3.get_algebraic_number_upper(_n, precision);
    return _c._getAST(result) as RatNumeral;
  }

  @override
  Rat toRat() => (getLower().value + getUpper().value) / Rat.fromInt(2);
}

abstract class Quantifier extends Expr {}

class Lambda extends Quantifier {
  Lambda(this.args, this.body);

  factory Lambda.bind(
    Context context,
    List<ConstVar> bound,
    AST body,
  ) {
    final boundPtr = calloc<Z3_app>(bound.length);
    try {
      for (var i = 0; i < bound.length; i++) {
        boundPtr[i] = context._createAST(bound[i]).cast();
      }
      final result = context._z3.mk_lambda_const(
        bound.length,
        boundPtr,
        context._createAST(body),
      );
      return context._getAST(result) as Lambda;
    } finally {
      malloc.free(boundPtr);
    }
  }

  final Map<Sym, Sort> args;
  final Expr body;

  @override
  Z3_ast build(Context c) {
    final namesPtr = calloc<Z3_symbol>(args.length);
    final sortsPtr = calloc<Z3_sort>(args.length);
    try {
      var i = 0;
      for (final MapEntry(:key, :value) in args.entries) {
        namesPtr[i] = c._createSymbol(key);
        sortsPtr[i] = c._createSort(value);
        i++;
      }
      final result = c._z3.mk_lambda(
        args.length,
        sortsPtr,
        namesPtr,
        c._createAST(body),
      );
      return result;
    } finally {
      malloc.free(namesPtr);
      malloc.free(sortsPtr);
    }
  }
}

class Exists extends Quantifier {
  Exists(
    this.args,
    this.body, {
    this.weight = 0,
    this.patterns = const [],
    this.noPatterns = const [],
    this.id,
    this.skolem,
  });

  factory Exists.bind(
    Context context,
    List<ConstVar> bound,
    AST body, {
    int weight = 0,
    List<Pat> patterns = const [],
    List<AST> noPatterns = const [],
    Sym? id,
    Sym? skolem,
  }) {
    final boundPtr = calloc<Z3_app>(bound.length);
    final patternsPtr = calloc<Z3_pattern>(patterns.length);
    final noPatternsPtr = calloc<Z3_ast>(noPatterns.length);
    try {
      for (var i = 0; i < bound.length; i++) {
        boundPtr[i] = context._createAST(bound[i]).cast();
      }
      for (var i = 0; i < patterns.length; i++) {
        patternsPtr[i] = context._createPattern(patterns[i]);
      }
      for (var i = 0; i < noPatterns.length; i++) {
        noPatternsPtr[i] = context._createAST(noPatterns[i]);
      }
      final result = context._z3.mk_quantifier_const_ex(
        false,
        weight,
        context._createSymbol(id),
        context._createSymbol(skolem),
        bound.length,
        boundPtr,
        patterns.length,
        patternsPtr,
        noPatterns.length,
        noPatternsPtr,
        context._createAST(body),
      );
      return context._getAST(result) as Exists;
    } finally {
      malloc.free(boundPtr);
      malloc.free(patternsPtr);
      malloc.free(noPatternsPtr);
    }
  }

  final List<Pat> patterns;
  final Map<Sym, Sort> args;
  final Expr body;
  final int weight;
  final List<Expr> noPatterns;
  final Sym? id;
  final Sym? skolem;

  @override
  Z3_ast build(Context c) {
    final patternsPtr = calloc<Z3_pattern>(patterns.length);
    final noPatternsPtr = calloc<Z3_ast>(noPatterns.length);
    final namesPtr = calloc<Z3_symbol>(args.length);
    final sortsPtr = calloc<Z3_sort>(args.length);
    try {
      for (var i = 0; i < patterns.length; i++) {
        patternsPtr[i] = c._createPattern(patterns[i]);
      }
      for (var i = 0; i < noPatterns.length; i++) {
        noPatternsPtr[i] = c._createAST(noPatterns[i]);
      }
      var i = 0;
      for (final MapEntry(:key, :value) in args.entries) {
        namesPtr[i] = c._createSymbol(key);
        sortsPtr[i] = c._createSort(value);
        i++;
      }
      final result = c._z3.mk_quantifier_ex(
        false,
        weight,
        c._createSymbol(id),
        c._createSymbol(skolem),
        patterns.length,
        patternsPtr,
        noPatterns.length,
        noPatternsPtr,
        args.length,
        sortsPtr,
        namesPtr,
        c._createAST(body),
      );
      return result;
    } finally {
      malloc.free(patternsPtr);
      malloc.free(noPatternsPtr);
      malloc.free(namesPtr);
      malloc.free(sortsPtr);
    }
  }

  @override
  String toString() {
    return 'exists([${args.keys.join(', ')}], $body)';
  }
}

class Forall extends Quantifier {
  Forall(
    this.args,
    this.body, {
    this.weight = 0,
    this.patterns = const [],
    this.noPatterns = const [],
    this.id,
    this.skolem,
  });

  factory Forall.bind(
    Context context,
    List<ConstVar> bound,
    AST body, {
    int weight = 0,
    List<Pat> patterns = const [],
    List<AST> noPatterns = const [],
    Sym? id,
    Sym? skolem,
  }) {
    final boundPtr = calloc<Z3_app>(bound.length);
    final patternsPtr = calloc<Z3_pattern>(patterns.length);
    final noPatternsPtr = calloc<Z3_ast>(noPatterns.length);
    try {
      for (var i = 0; i < bound.length; i++) {
        boundPtr[i] = context._createAST(bound[i]).cast();
      }
      for (var i = 0; i < patterns.length; i++) {
        patternsPtr[i] = context._createPattern(patterns[i]);
      }
      for (var i = 0; i < noPatterns.length; i++) {
        noPatternsPtr[i] = context._createAST(noPatterns[i]);
      }
      final result = context._z3.mk_quantifier_const_ex(
        true,
        weight,
        context._createSymbol(id),
        context._createSymbol(skolem),
        bound.length,
        boundPtr,
        patterns.length,
        patternsPtr,
        noPatterns.length,
        noPatternsPtr,
        context._createAST(body),
      );
      return context._getAST(result) as Forall;
    } finally {
      malloc.free(boundPtr);
      malloc.free(patternsPtr);
      malloc.free(noPatternsPtr);
    }
  }

  final List<Pat> patterns;
  final Map<Sym, Sort> args;
  final Expr body;
  final int weight;
  final List<AST> noPatterns;
  final Sym? id;
  final Sym? skolem;

  @override
  Z3_ast build(Context c) {
    final patternsPtr = calloc<Z3_pattern>(patterns.length);
    final noPatternsPtr = calloc<Z3_ast>(noPatterns.length);
    final namesPtr = calloc<Z3_symbol>(args.length);
    final sortsPtr = calloc<Z3_sort>(args.length);
    try {
      for (var i = 0; i < patterns.length; i++) {
        patternsPtr[i] = c._createPattern(patterns[i]);
      }
      for (var i = 0; i < noPatterns.length; i++) {
        noPatternsPtr[i] = c._createAST(noPatterns[i]);
      }
      var i = 0;
      for (final MapEntry(:key, :value) in args.entries) {
        namesPtr[i] = c._createSymbol(key);
        sortsPtr[i] = c._createSort(value);
        i++;
      }
      final result = c._z3.mk_quantifier_ex(
        true,
        weight,
        c._createSymbol(id),
        c._createSymbol(skolem),
        patterns.length,
        patternsPtr,
        noPatterns.length,
        noPatternsPtr,
        args.length,
        sortsPtr,
        namesPtr,
        c._createAST(body),
      );
      return result;
    } finally {
      malloc.free(patternsPtr);
      malloc.free(noPatternsPtr);
      malloc.free(namesPtr);
      malloc.free(sortsPtr);
    }
  }

  @override
  String toString() {
    return 'forall([${args.keys.join(', ')}], $body)';
  }
}

class BoundVar extends Expr {
  BoundVar(this.index, this.sort);

  final int index;
  final Sort sort;

  @override
  Z3_ast build(Context c) => c._z3.mk_bound(index, c._createSort(sort));

  @override
  String toString() => 'bound($index)';
}

class ConstArray extends Expr {
  ConstArray(this.sort, this.value);

  final Sort sort;
  final AST value;

  @override
  Z3_ast build(Context c) =>
      c._z3.mk_const_array(c._createSort(sort), c._createAST(value));
}

class Str extends Expr {
  Str(this.value);

  final String value;

  @override
  Z3_ast build(Context c) {
    final runes = value.runes;
    switch (c.config.encoding) {
      case CharEncoding.ascii:
        final buffer = calloc<ffi.Char>(runes.length);
        try {
          for (var i = 0; i < runes.length; i++) {
            if (runes.elementAt(i) > 255) {
              throw ArgumentError.value(
                value,
                'value',
                'String contains non-ASCII characters',
              );
            }
            buffer[i] = runes.elementAt(i);
          }
          final result = c._z3.mk_lstring(value.length, buffer);
          return result;
        } finally {
          malloc.free(buffer);
        }
      case CharEncoding.bmp:
        final buffer = calloc<UnsignedInt>(runes.length);
        try {
          for (var i = 0; i < runes.length; i++) {
            if (runes.elementAt(i) > 65535) {
              throw ArgumentError.value(
                value,
                'value',
                'String contains non-BMP characters',
              );
            }
            buffer[i] = runes.elementAt(i);
          }
          final result = c._z3.mk_u32string(runes.length, buffer);
          return result;
        } finally {
          malloc.free(buffer);
        }
      case CharEncoding.unicode:
        final buffer = calloc<UnsignedInt>(runes.length);
        try {
          for (var i = 0; i < runes.length; i++) {
            buffer[i] = runes.elementAt(i);
          }
          final result = c._z3.mk_u32string(runes.length, buffer);
          return result;
        } finally {
          malloc.free(buffer);
        }
    }
  }
}

class EmptySeq extends Expr {
  EmptySeq(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => c._z3.mk_seq_empty(c._createSort(sort));
}

class UnitSeq extends Expr {
  UnitSeq(this.value);

  final AST value;

  @override
  Z3_ast build(Context c) => c._z3.mk_seq_unit(c._createAST(value));
}

class ReAllchar extends Expr {
  ReAllchar(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => c._z3.mk_re_allchar(c._createSort(sort));
}

class ReLoop extends Expr {
  ReLoop(this.expr, this.low, this.high);

  final AST expr;
  final int low;
  final int high;

  @override
  Z3_ast build(Context c) => c._z3.mk_re_loop(c._createAST(expr), low, high);
}

class RePower extends Expr {
  RePower(this.expr, this.n);

  final AST expr;
  final int n;

  @override
  Z3_ast build(Context c) => c._z3.mk_re_power(c._createAST(expr), n);
}

class ReEmpty extends Expr {
  ReEmpty(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => c._z3.mk_re_empty(c._createSort(sort));
}

class ReFull extends Expr {
  ReFull(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => c._z3.mk_re_full(c._createSort(sort));
}

class Char extends Expr {
  Char(this.value);

  final int value;

  @override
  Z3_ast build(Context c) {
    switch (c.config.encoding) {
      case CharEncoding.ascii:
        if (value > 255) {
          throw ArgumentError.value(
            value,
            'value',
            'Character is not ASCII',
          );
        }
      case CharEncoding.bmp:
        if (value > 65535) {
          throw ArgumentError.value(
            value,
            'value',
            'Character is not BMP',
          );
        }
        return c._z3.mk_char(value);
      case CharEncoding.unicode:
    }
    return c._z3.mk_char(value);
  }
}

class PbAtMost extends Expr {
  PbAtMost(this.args, this.k);

  final List<Expr> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = calloc<Z3_ast>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = c._createAST(args[i]);
      }
      final result = c._z3.mk_atmost(args.length, argsPtr, k);
      return result;
    } finally {
      malloc.free(argsPtr);
    }
  }
}

class PbAtLeast extends Expr {
  PbAtLeast(this.args, this.k);

  final List<Expr> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = calloc<Z3_ast>(args.length);
    try {
      for (var i = 0; i < args.length; i++) {
        argsPtr[i] = c._createAST(args[i]);
      }
      return c._z3.mk_atleast(args.length, argsPtr, k);
    } finally {
      malloc.free(argsPtr);
    }
  }
}

class PbEq extends Expr {
  PbEq(this.args, this.k);

  final Map<AST, int> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = calloc<Z3_ast>(args.length);
    final coeffsPtr = calloc<Int>(args.length);
    try {
      const i = 0;
      for (final MapEntry(:key, :value) in args.entries) {
        argsPtr[i] = c._createAST(key);
        coeffsPtr[i] = value;
      }
      final result = c._z3.mk_pbeq(
        args.length,
        argsPtr,
        coeffsPtr,
        k,
      );
      return result;
    } finally {
      malloc.free(argsPtr);
      malloc.free(coeffsPtr);
    }
  }
}

class Divides extends Expr {
  Divides(this.n, this.d);

  final int n;
  final AST d;

  @override
  Z3_ast build(Context c) {
    return c._z3.mk_divides(
      c._z3.mk_unsigned_int64(n, c._intSort),
      c._createAST(d),
    );
  }
}

abstract class Decl extends AST {}

abstract class Sort extends Decl {
  Z3_sort buildSort(Context c);

  @override
  Z3_ast build(Context c) => buildSort(c).cast();
}

class UninterpretedSort extends Sort {
  UninterpretedSort(this.name);

  final Sym name;

  @override
  Z3_sort buildSort(Context c) =>
      c._z3.mk_uninterpreted_sort(c._createSymbol(name));

  @override
  String toString() => 'uninterpretedSort($name)';
}

class BoolSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._boolSort;

  @override
  String toString() => 'boolSort';
}

class IntSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._intSort;

  @override
  String toString() => 'intSort';

  IntNumeral zero() => IntNumeral(BigInt.zero);

  IntNumeral one() => IntNumeral(BigInt.one);
}

class RealSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._realSort;

  @override
  String toString() => 'realSort';
}

class StringSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._stringSort;

  @override
  String toString() => 'stringSort';
}

class CharSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._charSort;

  @override
  String toString() => 'charSort';
}

class FpaRoundingModeSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._fpaRoundingModeSort;

  @override
  String toString() => 'fpaRoundingModeSort';
}

class BitVecSort extends Sort {
  BitVecSort(this.size);

  final int size;

  @override
  Z3_sort buildSort(Context c) => c._z3.mk_bv_sort(size);

  /// A mask of the most significant bit i.e. `1 << (size - 1)`.
  BitVecNumeral msb() => BitVecNumeral(BigInt.one << (size - 1), this);

  /// The smallest signed value i.e. `msb`.
  BitVecNumeral sMin() => msb();

  /// The largest signed value i.e. `~msb`.
  BitVecNumeral sMax() =>
      BitVecNumeral((BigInt.one << (size - 1)) - BigInt.one, this);

  /// The largest unsigned value i.e. `(1 << size) - 1`.
  BitVecNumeral uMax() =>
      BitVecNumeral((BigInt.one << size) - BigInt.one, this);

  BitVecNumeral zero() => BitVecNumeral(BigInt.zero, this);

  BitVecNumeral one() => BitVecNumeral(BigInt.one, this);
}

class FiniteDomainSort extends Sort {
  FiniteDomainSort(this.name, this.size);

  final Sym name;
  final int size;

  @override
  Z3_sort buildSort(Context c) =>
      c._z3.mk_finite_domain_sort(c._createSymbol(name), size);
}

class ArraySort extends Sort {
  ArraySort(this.domains, this.range) : assert(domains.isNotEmpty);

  final List<Sort> domains;
  final Sort range;

  @override
  Z3_sort buildSort(Context c) {
    if (domains.length == 1) {
      return c._z3.mk_array_sort(
        c._createSort(domains.single),
        c._createSort(range),
      );
    } else {
      final indicesPtr = calloc<Z3_sort>(domains.length);
      try {
        for (var i = 0; i < domains.length; i++) {
          indicesPtr[i] = c._createSort(domains[i]);
        }
        return c._z3.mk_array_sort_n(
          domains.length,
          indicesPtr,
          c._createSort(range),
        );
      } finally {
        malloc.free(indicesPtr);
      }
    }
  }
}

class SetSort extends Sort {
  SetSort(this.domain);

  final Sort domain;

  @override
  Z3_sort buildSort(Context c) => c._z3.mk_set_sort(c._createSort(domain));
}

class IndexRefSort extends Sort {
  IndexRefSort(this.index);

  final int index;

  @override
  Z3_sort buildSort(Context c) => throw AssertionError(
        'RefSort should only be used in constructor fields',
      );
}

class Constructor {
  Constructor(this.name, this.recognizer, this.fields);

  final Sym name;
  final Sym recognizer;
  final Map<Sym, Sort> fields;

  Z3_constructor buildConstructor(Context c) {
    final fieldNamesPtr = calloc<Z3_symbol>(fields.length);
    final sortsPtr = calloc<Z3_sort>(fields.length);
    final sortRefsPtr = calloc<UnsignedInt>(fields.length);
    try {
      var i = 0;
      for (final MapEntry(:key, :value) in fields.entries) {
        fieldNamesPtr[i] = c._createSymbol(key);
        if (value is IndexRefSort) {
          sortsPtr[i] = nullptr;
          sortRefsPtr[i] = value.index;
        } else {
          sortsPtr[i] = c._createSort(value);
          sortRefsPtr[i] = 0;
        }
        i++;
      }
      final result = c._z3.mk_constructor(
        c._createSymbol(name),
        c._createSymbol(recognizer),
        fields.length,
        fieldNamesPtr,
        sortsPtr,
        sortRefsPtr,
      );
      return result;
    } finally {
      malloc.free(fieldNamesPtr);
      malloc.free(sortsPtr);
      malloc.free(sortRefsPtr);
    }
  }
}

class DatatypeSort extends Sort {
  DatatypeSort(this.name, this._constructors);
  DatatypeSort._(this.name);

  late final List<Constructor> _constructors;

  final Sym name;
  List<Constructor> get constructors => _constructors;

  @override
  Z3_sort buildSort(Context c) {
    final constructorPtr = calloc<Z3_constructor>(constructors.length);
    try {
      for (var i = 0; i < constructors.length; i++) {
        constructorPtr[i] = constructors[i].buildConstructor(c);
      }
      final result = c._z3.mk_datatype(
        c._createSymbol(name),
        constructors.length,
        constructorPtr,
      );
      for (var i = 0; i < constructors.length; i++) {
        c._z3.del_constructor(constructorPtr[i]);
      }
      return result;
    } finally {
      malloc.free(constructorPtr);
    }
  }

  @override
  String toString() => 'datatypeSort($name)';
}

class ConstructorInfo {
  ConstructorInfo(this.constructor, this.recognizer, this.accessors);
  final FuncDecl constructor;
  final FuncDecl recognizer;
  final List<FuncDecl> accessors;
}

class DatatypeInfo {
  DatatypeInfo(this.sort, this.constructors);
  final DatatypeSort sort;
  final List<ConstructorInfo> constructors;
}

class EnumInfo {
  EnumInfo(this.sort, this.constants, this.testers);
  final DatatypeSort sort;
  final Map<Sym, ConstVar> constants;
  final List<FuncDecl> testers;
}

class TupleInfo {
  TupleInfo(this.sort, this.constructor, this.accessors);
  final DatatypeSort sort;
  final FuncDecl constructor;
  final List<FuncDecl> accessors;
}

class ListInfo {
  ListInfo(
    this.sort,
    this.nil,
    this.isNil,
    this.cons,
    this.isCons,
    this.head,
    this.tail,
  );
  final DatatypeSort sort;
  final ConstVar nil;
  final FuncDecl isNil;
  final FuncDecl cons;
  final FuncDecl isCons;
  final FuncDecl head;
  final FuncDecl tail;
}

class ForwardRefSort extends Sort {
  ForwardRefSort(this.name);

  final Sym name;

  @override
  Z3_sort buildSort(Context c) =>
      c._z3.mk_uninterpreted_sort(c._createSymbol(name));
}

class SeqSort extends Sort {
  SeqSort(this.domain);

  final Sort domain;

  @override
  Z3_sort buildSort(Context c) => c._z3.mk_seq_sort(c._createSort(domain));
}

class ReSort extends Sort {
  ReSort(this.seq);

  final Sort seq;

  @override
  Z3_sort buildSort(Context c) => c._z3.mk_re_sort(c._createSort(seq));
}

class FloatSort extends Sort {
  factory FloatSort(int ebits, int sbits) {
    if (ebits == 5 && sbits == 11) {
      return Float16Sort();
    } else if (ebits == 8 && sbits == 24) {
      return Float32Sort();
    } else if (ebits == 11 && sbits == 53) {
      return Float64Sort();
    } else if (ebits == 15 && sbits == 113) {
      return Float128Sort();
    } else {
      return FloatSort._(ebits, sbits);
    }
  }
  FloatSort._(this.ebits, this.sbits);

  final int ebits;
  final int sbits;
  late final int ebias = 1 << (ebits - 1) - 1;

  @override
  Z3_sort buildSort(Context c) => c._z3.mk_fpa_sort(ebits, sbits);

  @override
  String toString() => 'fpa($ebits, $sbits)';
}

class Float16Sort extends FloatSort {
  Float16Sort() : super._(5, 11);

  @override
  String toString() => 'f16';
}

class Float32Sort extends FloatSort {
  Float32Sort() : super._(8, 24);

  @override
  String toString() => 'f32';
}

class Float64Sort extends FloatSort {
  Float64Sort() : super._(11, 53);

  @override
  String toString() => 'f64';
}

class Float128Sort extends FloatSort {
  Float128Sort() : super._(15, 113);

  @override
  String toString() => 'f128';
}

enum FuncKind {
  trueFunc,
  falseFunc,
  eq,
  distinct,
  ite,
  and,
  or,
  xor,
  not,
  implies,
  oeq,
  anum,
  agnum,
  le,
  ge,
  lt,
  gt,
  add,
  sub,
  uminus,
  mul,
  div,
  idiv,
  rem,
  mod,
  toReal,
  toInt,
  isInt,
  power,
  store,
  select,
  constArray,
  arrayMap,
  arrayDefault,
  setUnion,
  setIntersect,
  setDifference,
  setComplement,
  setSubset,
  asArray,
  arrayExt,
  setHasSize,
  setCard,
  bnum,
  bit1,
  bit0,
  bneg,
  badd,
  bsub,
  bmul,
  bsdiv,
  budiv,
  bsrem,
  burem,
  bsmod,
  bsdiv0,
  budiv0,
  bsrem0,
  burem0,
  bsmod0,
  uleq,
  sleq,
  ugeq,
  sgeq,
  ult,
  slt,
  ugt,
  sgt,
  band,
  bor,
  bnot,
  bxor,
  bnand,
  bnor,
  bxnor,
  concat,
  signExt,
  zeroExt,
  extract,
  repeat,
  bredor,
  bredand,
  bcomp,
  bshl,
  blshr,
  bashr,
  rotateLeft,
  rotateRight,
  extRotateLeft,
  extRotateRight,
  bitTobool,
  intToBv,
  bvToInt,
  carry,
  xor3,
  bsmulNoOvfl,
  bumulNoOvfl,
  bsmulNoUdfl,
  bsdivI,
  budivI,
  bsremI,
  buremI,
  bsmodI,
  prUndef,
  prTrue,
  prAsserted,
  prGoal,
  prModusPonens,
  prReflexivity,
  prSymmetry,
  prTransitivity,
  prTransitivityStar,
  prMonotonicity,
  prQuantIntro,
  prBind,
  prDistributivity,
  prAndElim,
  prNotOrElim,
  prRewrite,
  prRewriteStar,
  prPullQuant,
  prPushQuant,
  prElimUnusedVars,
  prDer,
  prQuantInst,
  prHypothesis,
  prLemma,
  prUnitResolution,
  prIffTrue,
  prIffFalse,
  prCommutativity,
  prDefAxiom,
  prAssumptionAdd,
  prLemmaAdd,
  prRedundantDel,
  prClauseTrail,
  prDefIntro,
  prApplyDef,
  prIffOeq,
  prNnfPos,
  prNnfNeg,
  prSkolemize,
  prModusPonensOeq,
  prThLemma,
  prHyperResolve,
  raStore,
  raEmpty,
  raIsEmpty,
  raJoin,
  raUnion,
  raWiden,
  raProject,
  raFilter,
  raNegationFilter,
  raRename,
  raComplement,
  raSelect,
  raClone,
  fdConstant,
  fdLt,
  seqUnit,
  seqEmpty,
  seqConcat,
  seqPrefix,
  seqSuffix,
  seqContains,
  seqExtract,
  seqReplace,
  seqReplaceRe,
  seqReplaceReAll,
  seqReplaceAll,
  seqAt,
  seqNth,
  seqLength,
  seqIndex,
  seqLastIndex,
  seqToRe,
  seqInRe,
  strToInt,
  intToStr,
  ubvToStr,
  sbvToStr,
  strToCode,
  strFromCode,
  stringLt,
  stringLe,
  rePlus,
  reStar,
  reOption,
  reConcat,
  reUnion,
  reRange,
  reDiff,
  reIntersect,
  reLoop,
  rePower,
  reComplement,
  reEmptySet,
  reFullSet,
  reFullCharSet,
  reOfPred,
  reReverse,
  reDerivative,
  charConst,
  charLe,
  charToInt,
  charToBv,
  charFromBv,
  charIsDigit,
  label,
  labelLit,
  dtConstructor,
  dtRecogniser,
  dtIs,
  dtAccessor,
  dtUpdateField,
  pbAtMost,
  pbAtLeast,
  pbLe,
  pbGe,
  pbEq,
  specialRelationLo,
  specialRelationPo,
  specialRelationPlo,
  specialRelationTo,
  specialRelationTc,
  specialRelationTrc,
  fpaRmNearestTiesToEven,
  fpaRmNearestTiesToAway,
  fpaRmTowardPositive,
  fpaRmTowardNegative,
  fpaRmTowardZero,
  fpaNum,
  fpaPlusInf,
  fpaMinusInf,
  fpaNan,
  fpaPlusZero,
  fpaMinusZero,
  fpaAdd,
  fpaSub,
  fpaNeg,
  fpaMul,
  fpaDiv,
  fpaRem,
  fpaAbs,
  fpaMin,
  fpaMax,
  fpaFma,
  fpaSqrt,
  fpaRoundToIntegral,
  fpaEq,
  fpaLt,
  fpaGt,
  fpaLe,
  fpaGe,
  fpaIsNan,
  fpaIsInf,
  fpaIsZero,
  fpaIsNormal,
  fpaIsSubnormal,
  fpaIsNegative,
  fpaIsPositive,
  fpaFp,
  fpaToFp,
  fpaToFpUnsigned,
  fpaToUbv,
  fpaToSbv,
  fpaToReal,
  fpaToIeeeBv,
  fpaBvwrap,
  fpaBv2rm,
  internal,
  recursive,
  uninterpreted;

  static FuncKind _fromCode(int code) {
    switch (code) {
      case Z3_decl_kind.OP_TRUE:
        return FuncKind.trueFunc;
      case Z3_decl_kind.OP_FALSE:
        return FuncKind.falseFunc;
      case Z3_decl_kind.OP_EQ:
        return FuncKind.eq;
      case Z3_decl_kind.OP_DISTINCT:
        return FuncKind.distinct;
      case Z3_decl_kind.OP_ITE:
        return FuncKind.ite;
      case Z3_decl_kind.OP_AND:
        return FuncKind.and;
      case Z3_decl_kind.OP_OR:
        return FuncKind.or;
      case Z3_decl_kind.OP_XOR:
        return FuncKind.xor;
      case Z3_decl_kind.OP_NOT:
        return FuncKind.not;
      case Z3_decl_kind.OP_IMPLIES:
        return FuncKind.implies;
      case Z3_decl_kind.OP_OEQ:
        return FuncKind.oeq;
      case Z3_decl_kind.OP_ANUM:
        return FuncKind.anum;
      case Z3_decl_kind.OP_AGNUM:
        return FuncKind.agnum;
      case Z3_decl_kind.OP_LE:
        return FuncKind.le;
      case Z3_decl_kind.OP_GE:
        return FuncKind.ge;
      case Z3_decl_kind.OP_LT:
        return FuncKind.lt;
      case Z3_decl_kind.OP_GT:
        return FuncKind.gt;
      case Z3_decl_kind.OP_ADD:
        return FuncKind.add;
      case Z3_decl_kind.OP_SUB:
        return FuncKind.sub;
      case Z3_decl_kind.OP_UMINUS:
        return FuncKind.uminus;
      case Z3_decl_kind.OP_MUL:
        return FuncKind.mul;
      case Z3_decl_kind.OP_DIV:
        return FuncKind.div;
      case Z3_decl_kind.OP_IDIV:
        return FuncKind.idiv;
      case Z3_decl_kind.OP_REM:
        return FuncKind.rem;
      case Z3_decl_kind.OP_MOD:
        return FuncKind.mod;
      case Z3_decl_kind.OP_TO_REAL:
        return FuncKind.toReal;
      case Z3_decl_kind.OP_TO_INT:
        return FuncKind.toInt;
      case Z3_decl_kind.OP_IS_INT:
        return FuncKind.isInt;
      case Z3_decl_kind.OP_POWER:
        return FuncKind.power;
      case Z3_decl_kind.OP_STORE:
        return FuncKind.store;
      case Z3_decl_kind.OP_SELECT:
        return FuncKind.select;
      case Z3_decl_kind.OP_CONST_ARRAY:
        return FuncKind.constArray;
      case Z3_decl_kind.OP_ARRAY_MAP:
        return FuncKind.arrayMap;
      case Z3_decl_kind.OP_ARRAY_DEFAULT:
        return FuncKind.arrayDefault;
      case Z3_decl_kind.OP_SET_UNION:
        return FuncKind.setUnion;
      case Z3_decl_kind.OP_SET_INTERSECT:
        return FuncKind.setIntersect;
      case Z3_decl_kind.OP_SET_DIFFERENCE:
        return FuncKind.setDifference;
      case Z3_decl_kind.OP_SET_COMPLEMENT:
        return FuncKind.setComplement;
      case Z3_decl_kind.OP_SET_SUBSET:
        return FuncKind.setSubset;
      case Z3_decl_kind.OP_AS_ARRAY:
        return FuncKind.asArray;
      case Z3_decl_kind.OP_ARRAY_EXT:
        return FuncKind.arrayExt;
      case Z3_decl_kind.OP_SET_HAS_SIZE:
        return FuncKind.setHasSize;
      case Z3_decl_kind.OP_SET_CARD:
        return FuncKind.setCard;
      case Z3_decl_kind.OP_BNUM:
        return FuncKind.bnum;
      case Z3_decl_kind.OP_BIT1:
        return FuncKind.bit1;
      case Z3_decl_kind.OP_BIT0:
        return FuncKind.bit0;
      case Z3_decl_kind.OP_BNEG:
        return FuncKind.bneg;
      case Z3_decl_kind.OP_BADD:
        return FuncKind.badd;
      case Z3_decl_kind.OP_BSUB:
        return FuncKind.bsub;
      case Z3_decl_kind.OP_BMUL:
        return FuncKind.bmul;
      case Z3_decl_kind.OP_BSDIV:
        return FuncKind.bsdiv;
      case Z3_decl_kind.OP_BUDIV:
        return FuncKind.budiv;
      case Z3_decl_kind.OP_BSREM:
        return FuncKind.bsrem;
      case Z3_decl_kind.OP_BUREM:
        return FuncKind.burem;
      case Z3_decl_kind.OP_BSMOD:
        return FuncKind.bsmod;
      case Z3_decl_kind.OP_BSDIV0:
        return FuncKind.bsdiv0;
      case Z3_decl_kind.OP_BUDIV0:
        return FuncKind.budiv0;
      case Z3_decl_kind.OP_BSREM0:
        return FuncKind.bsrem0;
      case Z3_decl_kind.OP_BUREM0:
        return FuncKind.burem0;
      case Z3_decl_kind.OP_BSMOD0:
        return FuncKind.bsmod0;
      case Z3_decl_kind.OP_ULEQ:
        return FuncKind.uleq;
      case Z3_decl_kind.OP_SLEQ:
        return FuncKind.sleq;
      case Z3_decl_kind.OP_UGEQ:
        return FuncKind.ugeq;
      case Z3_decl_kind.OP_SGEQ:
        return FuncKind.sgeq;
      case Z3_decl_kind.OP_ULT:
        return FuncKind.ult;
      case Z3_decl_kind.OP_SLT:
        return FuncKind.slt;
      case Z3_decl_kind.OP_UGT:
        return FuncKind.ugt;
      case Z3_decl_kind.OP_SGT:
        return FuncKind.sgt;
      case Z3_decl_kind.OP_BAND:
        return FuncKind.band;
      case Z3_decl_kind.OP_BOR:
        return FuncKind.bor;
      case Z3_decl_kind.OP_BNOT:
        return FuncKind.bnot;
      case Z3_decl_kind.OP_BXOR:
        return FuncKind.bxor;
      case Z3_decl_kind.OP_BNAND:
        return FuncKind.bnand;
      case Z3_decl_kind.OP_BNOR:
        return FuncKind.bnor;
      case Z3_decl_kind.OP_BXNOR:
        return FuncKind.bxnor;
      case Z3_decl_kind.OP_CONCAT:
        return FuncKind.concat;
      case Z3_decl_kind.OP_SIGN_EXT:
        return FuncKind.signExt;
      case Z3_decl_kind.OP_ZERO_EXT:
        return FuncKind.zeroExt;
      case Z3_decl_kind.OP_EXTRACT:
        return FuncKind.extract;
      case Z3_decl_kind.OP_REPEAT:
        return FuncKind.repeat;
      case Z3_decl_kind.OP_BREDOR:
        return FuncKind.bredor;
      case Z3_decl_kind.OP_BREDAND:
        return FuncKind.bredand;
      case Z3_decl_kind.OP_BCOMP:
        return FuncKind.bcomp;
      case Z3_decl_kind.OP_BSHL:
        return FuncKind.bshl;
      case Z3_decl_kind.OP_BLSHR:
        return FuncKind.blshr;
      case Z3_decl_kind.OP_BASHR:
        return FuncKind.bashr;
      case Z3_decl_kind.OP_ROTATE_LEFT:
        return FuncKind.rotateLeft;
      case Z3_decl_kind.OP_ROTATE_RIGHT:
        return FuncKind.rotateRight;
      case Z3_decl_kind.OP_EXT_ROTATE_LEFT:
        return FuncKind.extRotateLeft;
      case Z3_decl_kind.OP_EXT_ROTATE_RIGHT:
        return FuncKind.extRotateRight;
      case Z3_decl_kind.OP_BIT2BOOL:
        return FuncKind.bitTobool;
      case Z3_decl_kind.OP_INT2BV:
        return FuncKind.intToBv;
      case Z3_decl_kind.OP_BV2INT:
        return FuncKind.bvToInt;
      case Z3_decl_kind.OP_CARRY:
        return FuncKind.carry;
      case Z3_decl_kind.OP_XOR3:
        return FuncKind.xor3;
      case Z3_decl_kind.OP_BSMUL_NO_OVFL:
        return FuncKind.bsmulNoOvfl;
      case Z3_decl_kind.OP_BUMUL_NO_OVFL:
        return FuncKind.bumulNoOvfl;
      case Z3_decl_kind.OP_BSMUL_NO_UDFL:
        return FuncKind.bsmulNoUdfl;
      case Z3_decl_kind.OP_BSDIV_I:
        return FuncKind.bsdivI;
      case Z3_decl_kind.OP_BUDIV_I:
        return FuncKind.budivI;
      case Z3_decl_kind.OP_BSREM_I:
        return FuncKind.bsremI;
      case Z3_decl_kind.OP_BUREM_I:
        return FuncKind.buremI;
      case Z3_decl_kind.OP_BSMOD_I:
        return FuncKind.bsmodI;
      case Z3_decl_kind.OP_PR_UNDEF:
        return FuncKind.prUndef;
      case Z3_decl_kind.OP_PR_TRUE:
        return FuncKind.prTrue;
      case Z3_decl_kind.OP_PR_ASSERTED:
        return FuncKind.prAsserted;
      case Z3_decl_kind.OP_PR_GOAL:
        return FuncKind.prGoal;
      case Z3_decl_kind.OP_PR_MODUS_PONENS:
        return FuncKind.prModusPonens;
      case Z3_decl_kind.OP_PR_REFLEXIVITY:
        return FuncKind.prReflexivity;
      case Z3_decl_kind.OP_PR_SYMMETRY:
        return FuncKind.prSymmetry;
      case Z3_decl_kind.OP_PR_TRANSITIVITY:
        return FuncKind.prTransitivity;
      case Z3_decl_kind.OP_PR_TRANSITIVITY_STAR:
        return FuncKind.prTransitivityStar;
      case Z3_decl_kind.OP_PR_MONOTONICITY:
        return FuncKind.prMonotonicity;
      case Z3_decl_kind.OP_PR_QUANT_INTRO:
        return FuncKind.prQuantIntro;
      case Z3_decl_kind.OP_PR_BIND:
        return FuncKind.prBind;
      case Z3_decl_kind.OP_PR_DISTRIBUTIVITY:
        return FuncKind.prDistributivity;
      case Z3_decl_kind.OP_PR_AND_ELIM:
        return FuncKind.prAndElim;
      case Z3_decl_kind.OP_PR_NOT_OR_ELIM:
        return FuncKind.prNotOrElim;
      case Z3_decl_kind.OP_PR_REWRITE:
        return FuncKind.prRewrite;
      case Z3_decl_kind.OP_PR_REWRITE_STAR:
        return FuncKind.prRewriteStar;
      case Z3_decl_kind.OP_PR_PULL_QUANT:
        return FuncKind.prPullQuant;
      case Z3_decl_kind.OP_PR_PUSH_QUANT:
        return FuncKind.prPushQuant;
      case Z3_decl_kind.OP_PR_ELIM_UNUSED_VARS:
        return FuncKind.prElimUnusedVars;
      case Z3_decl_kind.OP_PR_DER:
        return FuncKind.prDer;
      case Z3_decl_kind.OP_PR_QUANT_INST:
        return FuncKind.prQuantInst;
      case Z3_decl_kind.OP_PR_HYPOTHESIS:
        return FuncKind.prHypothesis;
      case Z3_decl_kind.OP_PR_LEMMA:
        return FuncKind.prLemma;
      case Z3_decl_kind.OP_PR_UNIT_RESOLUTION:
        return FuncKind.prUnitResolution;
      case Z3_decl_kind.OP_PR_IFF_TRUE:
        return FuncKind.prIffTrue;
      case Z3_decl_kind.OP_PR_IFF_FALSE:
        return FuncKind.prIffFalse;
      case Z3_decl_kind.OP_PR_COMMUTATIVITY:
        return FuncKind.prCommutativity;
      case Z3_decl_kind.OP_PR_DEF_AXIOM:
        return FuncKind.prDefAxiom;
      case Z3_decl_kind.OP_PR_ASSUMPTION_ADD:
        return FuncKind.prAssumptionAdd;
      case Z3_decl_kind.OP_PR_LEMMA_ADD:
        return FuncKind.prLemmaAdd;
      case Z3_decl_kind.OP_PR_REDUNDANT_DEL:
        return FuncKind.prRedundantDel;
      case Z3_decl_kind.OP_PR_CLAUSE_TRAIL:
        return FuncKind.prClauseTrail;
      case Z3_decl_kind.OP_PR_DEF_INTRO:
        return FuncKind.prDefIntro;
      case Z3_decl_kind.OP_PR_APPLY_DEF:
        return FuncKind.prApplyDef;
      case Z3_decl_kind.OP_PR_IFF_OEQ:
        return FuncKind.prIffOeq;
      case Z3_decl_kind.OP_PR_NNF_POS:
        return FuncKind.prNnfPos;
      case Z3_decl_kind.OP_PR_NNF_NEG:
        return FuncKind.prNnfNeg;
      case Z3_decl_kind.OP_PR_SKOLEMIZE:
        return FuncKind.prSkolemize;
      case Z3_decl_kind.OP_PR_MODUS_PONENS_OEQ:
        return FuncKind.prModusPonensOeq;
      case Z3_decl_kind.OP_PR_TH_LEMMA:
        return FuncKind.prThLemma;
      case Z3_decl_kind.OP_PR_HYPER_RESOLVE:
        return FuncKind.prHyperResolve;
      case Z3_decl_kind.OP_RA_STORE:
        return FuncKind.raStore;
      case Z3_decl_kind.OP_RA_EMPTY:
        return FuncKind.raEmpty;
      case Z3_decl_kind.OP_RA_IS_EMPTY:
        return FuncKind.raIsEmpty;
      case Z3_decl_kind.OP_RA_JOIN:
        return FuncKind.raJoin;
      case Z3_decl_kind.OP_RA_UNION:
        return FuncKind.raUnion;
      case Z3_decl_kind.OP_RA_WIDEN:
        return FuncKind.raWiden;
      case Z3_decl_kind.OP_RA_PROJECT:
        return FuncKind.raProject;
      case Z3_decl_kind.OP_RA_FILTER:
        return FuncKind.raFilter;
      case Z3_decl_kind.OP_RA_NEGATION_FILTER:
        return FuncKind.raNegationFilter;
      case Z3_decl_kind.OP_RA_RENAME:
        return FuncKind.raRename;
      case Z3_decl_kind.OP_RA_COMPLEMENT:
        return FuncKind.raComplement;
      case Z3_decl_kind.OP_RA_SELECT:
        return FuncKind.raSelect;
      case Z3_decl_kind.OP_RA_CLONE:
        return FuncKind.raClone;
      case Z3_decl_kind.OP_FD_CONSTANT:
        return FuncKind.fdConstant;
      case Z3_decl_kind.OP_FD_LT:
        return FuncKind.fdLt;
      case Z3_decl_kind.OP_SEQ_UNIT:
        return FuncKind.seqUnit;
      case Z3_decl_kind.OP_SEQ_EMPTY:
        return FuncKind.seqEmpty;
      case Z3_decl_kind.OP_SEQ_CONCAT:
        return FuncKind.seqConcat;
      case Z3_decl_kind.OP_SEQ_PREFIX:
        return FuncKind.seqPrefix;
      case Z3_decl_kind.OP_SEQ_SUFFIX:
        return FuncKind.seqSuffix;
      case Z3_decl_kind.OP_SEQ_CONTAINS:
        return FuncKind.seqContains;
      case Z3_decl_kind.OP_SEQ_EXTRACT:
        return FuncKind.seqExtract;
      case Z3_decl_kind.OP_SEQ_REPLACE:
        return FuncKind.seqReplace;
      case Z3_decl_kind.OP_SEQ_REPLACE_RE:
        return FuncKind.seqReplaceRe;
      case Z3_decl_kind.OP_SEQ_REPLACE_RE_ALL:
        return FuncKind.seqReplaceReAll;
      case Z3_decl_kind.OP_SEQ_REPLACE_ALL:
        return FuncKind.seqReplaceAll;
      case Z3_decl_kind.OP_SEQ_AT:
        return FuncKind.seqAt;
      case Z3_decl_kind.OP_SEQ_NTH:
        return FuncKind.seqNth;
      case Z3_decl_kind.OP_SEQ_LENGTH:
        return FuncKind.seqLength;
      case Z3_decl_kind.OP_SEQ_INDEX:
        return FuncKind.seqIndex;
      case Z3_decl_kind.OP_SEQ_LAST_INDEX:
        return FuncKind.seqLastIndex;
      case Z3_decl_kind.OP_SEQ_TO_RE:
        return FuncKind.seqToRe;
      case Z3_decl_kind.OP_SEQ_IN_RE:
        return FuncKind.seqInRe;
      case Z3_decl_kind.OP_STR_TO_INT:
        return FuncKind.strToInt;
      case Z3_decl_kind.OP_INT_TO_STR:
        return FuncKind.intToStr;
      case Z3_decl_kind.OP_UBV_TO_STR:
        return FuncKind.ubvToStr;
      case Z3_decl_kind.OP_SBV_TO_STR:
        return FuncKind.sbvToStr;
      case Z3_decl_kind.OP_STR_TO_CODE:
        return FuncKind.strToCode;
      case Z3_decl_kind.OP_STR_FROM_CODE:
        return FuncKind.strFromCode;
      case Z3_decl_kind.OP_STRING_LT:
        return FuncKind.stringLt;
      case Z3_decl_kind.OP_STRING_LE:
        return FuncKind.stringLe;
      case Z3_decl_kind.OP_RE_PLUS:
        return FuncKind.rePlus;
      case Z3_decl_kind.OP_RE_STAR:
        return FuncKind.reStar;
      case Z3_decl_kind.OP_RE_OPTION:
        return FuncKind.reOption;
      case Z3_decl_kind.OP_RE_CONCAT:
        return FuncKind.reConcat;
      case Z3_decl_kind.OP_RE_UNION:
        return FuncKind.reUnion;
      case Z3_decl_kind.OP_RE_RANGE:
        return FuncKind.reRange;
      case Z3_decl_kind.OP_RE_DIFF:
        return FuncKind.reDiff;
      case Z3_decl_kind.OP_RE_INTERSECT:
        return FuncKind.reIntersect;
      case Z3_decl_kind.OP_RE_LOOP:
        return FuncKind.reLoop;
      case Z3_decl_kind.OP_RE_POWER:
        return FuncKind.rePower;
      case Z3_decl_kind.OP_RE_COMPLEMENT:
        return FuncKind.reComplement;
      case Z3_decl_kind.OP_RE_EMPTY_SET:
        return FuncKind.reEmptySet;
      case Z3_decl_kind.OP_RE_FULL_SET:
        return FuncKind.reFullSet;
      case Z3_decl_kind.OP_RE_FULL_CHAR_SET:
        return FuncKind.reFullCharSet;
      case Z3_decl_kind.OP_RE_OF_PRED:
        return FuncKind.reOfPred;
      case Z3_decl_kind.OP_RE_REVERSE:
        return FuncKind.reReverse;
      case Z3_decl_kind.OP_RE_DERIVATIVE:
        return FuncKind.reDerivative;
      case Z3_decl_kind.OP_CHAR_CONST:
        return FuncKind.charConst;
      case Z3_decl_kind.OP_CHAR_LE:
        return FuncKind.charLe;
      case Z3_decl_kind.OP_CHAR_TO_INT:
        return FuncKind.charToInt;
      case Z3_decl_kind.OP_CHAR_TO_BV:
        return FuncKind.charToBv;
      case Z3_decl_kind.OP_CHAR_FROM_BV:
        return FuncKind.charFromBv;
      case Z3_decl_kind.OP_CHAR_IS_DIGIT:
        return FuncKind.charIsDigit;
      case Z3_decl_kind.OP_LABEL:
        return FuncKind.label;
      case Z3_decl_kind.OP_LABEL_LIT:
        return FuncKind.labelLit;
      case Z3_decl_kind.OP_DT_CONSTRUCTOR:
        return FuncKind.dtConstructor;
      case Z3_decl_kind.OP_DT_RECOGNISER:
        return FuncKind.dtRecogniser;
      case Z3_decl_kind.OP_DT_IS:
        return FuncKind.dtIs;
      case Z3_decl_kind.OP_DT_ACCESSOR:
        return FuncKind.dtAccessor;
      case Z3_decl_kind.OP_DT_UPDATE_FIELD:
        return FuncKind.dtUpdateField;
      case Z3_decl_kind.OP_PB_AT_MOST:
        return FuncKind.pbAtMost;
      case Z3_decl_kind.OP_PB_AT_LEAST:
        return FuncKind.pbAtLeast;
      case Z3_decl_kind.OP_PB_LE:
        return FuncKind.pbLe;
      case Z3_decl_kind.OP_PB_GE:
        return FuncKind.pbGe;
      case Z3_decl_kind.OP_PB_EQ:
        return FuncKind.pbEq;
      case Z3_decl_kind.OP_SPECIAL_RELATION_LO:
        return FuncKind.specialRelationLo;
      case Z3_decl_kind.OP_SPECIAL_RELATION_PO:
        return FuncKind.specialRelationPo;
      case Z3_decl_kind.OP_SPECIAL_RELATION_PLO:
        return FuncKind.specialRelationPlo;
      case Z3_decl_kind.OP_SPECIAL_RELATION_TO:
        return FuncKind.specialRelationTo;
      case Z3_decl_kind.OP_SPECIAL_RELATION_TC:
        return FuncKind.specialRelationTc;
      case Z3_decl_kind.OP_SPECIAL_RELATION_TRC:
        return FuncKind.specialRelationTrc;
      case Z3_decl_kind.OP_FPA_RM_NEAREST_TIES_TO_EVEN:
        return FuncKind.fpaRmNearestTiesToEven;
      case Z3_decl_kind.OP_FPA_RM_NEAREST_TIES_TO_AWAY:
        return FuncKind.fpaRmNearestTiesToAway;
      case Z3_decl_kind.OP_FPA_RM_TOWARD_POSITIVE:
        return FuncKind.fpaRmTowardPositive;
      case Z3_decl_kind.OP_FPA_RM_TOWARD_NEGATIVE:
        return FuncKind.fpaRmTowardNegative;
      case Z3_decl_kind.OP_FPA_RM_TOWARD_ZERO:
        return FuncKind.fpaRmTowardZero;
      case Z3_decl_kind.OP_FPA_NUM:
        return FuncKind.fpaNum;
      case Z3_decl_kind.OP_FPA_PLUS_INF:
        return FuncKind.fpaPlusInf;
      case Z3_decl_kind.OP_FPA_MINUS_INF:
        return FuncKind.fpaMinusInf;
      case Z3_decl_kind.OP_FPA_NAN:
        return FuncKind.fpaNan;
      case Z3_decl_kind.OP_FPA_PLUS_ZERO:
        return FuncKind.fpaPlusZero;
      case Z3_decl_kind.OP_FPA_MINUS_ZERO:
        return FuncKind.fpaMinusZero;
      case Z3_decl_kind.OP_FPA_ADD:
        return FuncKind.fpaAdd;
      case Z3_decl_kind.OP_FPA_SUB:
        return FuncKind.fpaSub;
      case Z3_decl_kind.OP_FPA_NEG:
        return FuncKind.fpaNeg;
      case Z3_decl_kind.OP_FPA_MUL:
        return FuncKind.fpaMul;
      case Z3_decl_kind.OP_FPA_DIV:
        return FuncKind.fpaDiv;
      case Z3_decl_kind.OP_FPA_REM:
        return FuncKind.fpaRem;
      case Z3_decl_kind.OP_FPA_ABS:
        return FuncKind.fpaAbs;
      case Z3_decl_kind.OP_FPA_MIN:
        return FuncKind.fpaMin;
      case Z3_decl_kind.OP_FPA_MAX:
        return FuncKind.fpaMax;
      case Z3_decl_kind.OP_FPA_FMA:
        return FuncKind.fpaFma;
      case Z3_decl_kind.OP_FPA_SQRT:
        return FuncKind.fpaSqrt;
      case Z3_decl_kind.OP_FPA_ROUND_TO_INTEGRAL:
        return FuncKind.fpaRoundToIntegral;
      case Z3_decl_kind.OP_FPA_EQ:
        return FuncKind.fpaEq;
      case Z3_decl_kind.OP_FPA_LT:
        return FuncKind.fpaLt;
      case Z3_decl_kind.OP_FPA_GT:
        return FuncKind.fpaGt;
      case Z3_decl_kind.OP_FPA_LE:
        return FuncKind.fpaLe;
      case Z3_decl_kind.OP_FPA_GE:
        return FuncKind.fpaGe;
      case Z3_decl_kind.OP_FPA_IS_NAN:
        return FuncKind.fpaIsNan;
      case Z3_decl_kind.OP_FPA_IS_INF:
        return FuncKind.fpaIsInf;
      case Z3_decl_kind.OP_FPA_IS_ZERO:
        return FuncKind.fpaIsZero;
      case Z3_decl_kind.OP_FPA_IS_NORMAL:
        return FuncKind.fpaIsNormal;
      case Z3_decl_kind.OP_FPA_IS_SUBNORMAL:
        return FuncKind.fpaIsSubnormal;
      case Z3_decl_kind.OP_FPA_IS_NEGATIVE:
        return FuncKind.fpaIsNegative;
      case Z3_decl_kind.OP_FPA_IS_POSITIVE:
        return FuncKind.fpaIsPositive;
      case Z3_decl_kind.OP_FPA_FP:
        return FuncKind.fpaFp;
      case Z3_decl_kind.OP_FPA_TO_FP:
        return FuncKind.fpaToFp;
      case Z3_decl_kind.OP_FPA_TO_FP_UNSIGNED:
        return FuncKind.fpaToFpUnsigned;
      case Z3_decl_kind.OP_FPA_TO_UBV:
        return FuncKind.fpaToUbv;
      case Z3_decl_kind.OP_FPA_TO_SBV:
        return FuncKind.fpaToSbv;
      case Z3_decl_kind.OP_FPA_TO_REAL:
        return FuncKind.fpaToReal;
      case Z3_decl_kind.OP_FPA_TO_IEEE_BV:
        return FuncKind.fpaToIeeeBv;
      case Z3_decl_kind.OP_FPA_BVWRAP:
        return FuncKind.fpaBvwrap;
      case Z3_decl_kind.OP_FPA_BV2RM:
        return FuncKind.fpaBv2rm;
      case Z3_decl_kind.OP_INTERNAL:
        return FuncKind.internal;
      case Z3_decl_kind.OP_RECURSIVE:
        return FuncKind.recursive;
      case Z3_decl_kind.OP_UNINTERPRETED:
        return FuncKind.uninterpreted;
      default:
        throw AssertionError('Unknown Z3_decl_kind: $code');
    }
  }
}

abstract class FuncDecl extends Decl {
  FuncDecl({
    required this.name,
    required this.kind,
    required this.parameters,
    required this.domain,
    required this.range,
  });

  Z3_func_decl buildFuncDecl(Context c);

  @override
  Z3_ast build(Context c) => c._z3.func_decl_to_ast(
        buildFuncDecl(c),
      );

  final Sym name;
  final FuncKind kind;
  final List<Parameter> parameters;
  final List<Sort> domain;
  final Sort range;
}

class InterpretedFunc extends FuncDecl {
  InterpretedFunc._(
    this._c,
    this._f,
    Sym name,
    FuncKind kind,
    List<Parameter> parameters,
    List<Sort> domain,
    Sort range,
  ) : super(
          name: name,
          kind: kind,
          parameters: parameters,
          domain: domain,
          range: range,
        );

  final Context _c;
  final Z3_func_decl _f;

  @override
  Z3_func_decl buildFuncDecl(Context c) =>
      _c._translateTo(c, this, _f.cast()).cast();

  @override
  String toString() {
    return [
      '$name',
      '$kind',
      if (parameters.isNotEmpty) '$parameters',
      ':',
      if (domain.isNotEmpty) '$domain',
      '$range',
    ].join(' ');
  }
}

class Func extends FuncDecl {
  Func(
    Sym name,
    List<Sort> domain,
    Sort range,
  ) : super(
          name: name,
          kind: FuncKind.uninterpreted,
          parameters: [],
          domain: domain,
          range: range,
        );
  Func._(
    Sym name,
    List<Parameter> parameters,
    List<Sort> domain,
    Sort range,
  ) : super(
          name: name,
          kind: FuncKind.uninterpreted,
          parameters: parameters,
          domain: domain,
          range: range,
        );

  @override
  Z3_func_decl buildFuncDecl(Context c) {
    final domainPtr = calloc<Z3_sort>(domain.length);
    try {
      for (var i = 0; i < domain.length; i++) {
        domainPtr[i] = c._createSort(domain[i]);
      }
      final result = c._z3.mk_func_decl(
        c._createSymbol(name),
        domain.length,
        domainPtr,
        c._createSort(range),
      );
      return result;
    } finally {
      malloc.free(domainPtr);
    }
  }

  @override
  FuncKind get kind => FuncKind.uninterpreted;
}

class RecursiveFunc extends FuncDecl {
  RecursiveFunc(
    Sym name,
    List<Sort> domain,
    Sort range,
  ) : super(
          name: name,
          kind: FuncKind.recursive,
          parameters: [],
          domain: domain,
          range: range,
        );
  RecursiveFunc._(
    Sym name,
    List<Parameter> parameters,
    List<Sort> domain,
    Sort range,
  ) : super(
          name: name,
          kind: FuncKind.recursive,
          parameters: parameters,
          domain: domain,
          range: range,
        );

  @override
  Z3_func_decl buildFuncDecl(Context c) {
    final domainPtr = calloc<Z3_sort>(domain.length);
    try {
      for (var i = 0; i < domain.length; i++) {
        domainPtr[i] = c._createSort(domain[i]);
      }
      final result = c._z3.mk_rec_func_decl(
        c._createSymbol(name),
        domain.length,
        domainPtr,
        c._createSort(range),
      );
      return result;
    } finally {
      malloc.free(domainPtr);
    }
  }

  @override
  FuncKind get kind => FuncKind.recursive;
}

class LinearOrder extends FuncDecl {
  LinearOrder(Sort sort, this.id)
      : super(
          parameters: [id],
          domain: [sort, sort],
          range: BoolSort(),
          name: const Sym('linear-order'),
          kind: FuncKind.specialRelationLo,
        );

  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => c._z3.mk_linear_order(
        c._createSort(domain[0]),
        id,
      );

  @override
  FuncKind get kind => FuncKind.specialRelationLo;
}

class PartialOrder extends FuncDecl {
  PartialOrder(Sort sort, this.id)
      : super(
          parameters: [id],
          domain: [sort, sort],
          range: BoolSort(),
          name: const Sym('partial-order'),
          kind: FuncKind.specialRelationPo,
        );

  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => c._z3.mk_partial_order(
        c._createSort(domain[0]),
        id,
      );

  @override
  FuncKind get kind => FuncKind.specialRelationPo;
}

class PiecewiseLinearOrder extends FuncDecl {
  PiecewiseLinearOrder(Sort sort, this.id)
      : super(
          parameters: [id],
          domain: [sort, sort],
          range: BoolSort(),
          name: const Sym('piecewise-linear-order'),
          kind: FuncKind.specialRelationPlo,
        );

  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => c._z3.mk_piecewise_linear_order(
        c._createSort(domain[0]),
        id,
      );

  @override
  FuncKind get kind => FuncKind.specialRelationPlo;
}

class TreeOrder extends FuncDecl {
  TreeOrder(Sort sort, this.id)
      : super(
          parameters: [id],
          domain: [sort, sort],
          range: BoolSort(),
          name: const Sym('tree-order'),
          kind: FuncKind.specialRelationTo,
        );

  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => c._z3.mk_tree_order(
        c._createSort(domain[0]),
        id,
      );

  @override
  FuncKind get kind => FuncKind.specialRelationTo;
}

class TransitiveClosure extends FuncDecl {
  TransitiveClosure(this.relation)
      : assert(relation.domain.length == 2),
        super(
          parameters: [relation],
          domain: [relation.domain[0], relation.domain[1]],
          range: BoolSort(),
          name: const Sym('transitive-closure'),
          kind: FuncKind.specialRelationTc,
        );

  final FuncDecl relation;

  @override
  Z3_func_decl buildFuncDecl(Context c) => c._z3.mk_transitive_closure(
        c._createFuncDecl(relation),
      );

  @override
  FuncKind get kind => FuncKind.specialRelationTc;
}

class Unknown extends Expr {
  Unknown._(this._c, this._ast);

  final Context _c;
  final Z3_ast _ast;

  @override
  Z3_ast build(Context c) => _c._translateTo(c, this, _ast);
}

class UnknownSort extends Sort {
  UnknownSort._(this._c, this._ast);

  final Context _c;
  final Z3_ast _ast;

  @override
  Z3_sort buildSort(Context c) => _c._translateTo(c, this, _ast).cast();
}
