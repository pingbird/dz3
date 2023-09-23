import 'dart:ffi';
import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:pub_semver/pub_semver.dart';

import 'nums.dart';
import 'z3_ffi.dart';

final z3 = Z3Lib(DynamicLibrary.open(
    r'C:\Users\ping\CLionProjects\z3\cmake-build-debug-visual-studio\libz3.dll'));

var _assertionsEnabled = true;

T _disableAssertions<T>(T Function() fn) {
  if (!_assertionsEnabled) {
    return fn();
  }
  _mathContext.eval('(set-option :enable-assertions false)');
  _assertionsEnabled = false;
  try {
    return fn();
  } finally {
    _mathContext.eval('(set-option :enable-assertions true)');
    _assertionsEnabled = true;
  }
}

final Version z3GlobalVersion = () {
  final major = malloc<UnsignedInt>();
  final minor = malloc<UnsignedInt>();
  final build = malloc<UnsignedInt>();
  final revision = malloc<UnsignedInt>();
  try {
    z3.get_version(major, minor, build, revision);
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
    z3.get_full_version().cast<Utf8>().toDartString();

void z3GlobalEnableTrace(String tag) {
  final tagPtr = tag.toNativeUtf8();
  try {
    z3.enable_trace(tagPtr.cast());
  } finally {
    malloc.free(tagPtr);
  }
}

void z3GlobalDisableTrace(String tag) {
  final tagPtr = tag.toNativeUtf8();
  try {
    z3.disable_trace(tagPtr.cast());
  } finally {
    malloc.free(tagPtr);
  }
}

int z3GlobalGetEstimatedAllocatedMemory() => z3.get_estimated_alloc_size();

/// The character encoding of the String and Unicode sorts.
///
/// See [Config.encoding].
enum CharEncoding {
  unicode,
  ascii,
  bmp,
}

enum Z3ParamKind {
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
  all("ALL"),

  /// Difference Logic over the reals. In essence, Boolean combinations of
  /// inequations of the form x - y < b where x and y are real variables and b
  /// is a rational constant.
  qfRdl("QF_RDL"),

  /// Unquantified linear real arithmetic. In essence, Boolean combinations of
  /// inequations between linear polynomials over real variables.
  qfLra("QF_LRA"),

  /// Linear real arithmetic with uninterpreted sort and function symbols.
  uflra("UFLRA"),

  /// Closed linear formulas in linear real arithmetic.
  lra("LRA"),

  rdl('RDL'),

  nra('NRA'),

  /// Quantifier-free real arithmetic.
  qfNra("QF_NRA"),

  /// Unquantified non-linear real arithmetic with uninterpreted sort and
  /// function symbols.
  qfUfnra("QF_UFNRA"),

  /// Unquantified linear real arithmetic with uninterpreted sort and function
  /// symbols.
  qfUflra("QF_UFLRA"),

  /// Unquantified linear integer arithmetic. In essence, Boolean combinations
  /// of inequations between linear polynomials over integer variables.
  qfLia("QF_LIA"),

  /// Difference Logic over the integers. In essence, Boolean combinations of
  /// inequations of the form x - y < b where x and y are integer variables and
  /// b is an integer constant.
  qfIdl("QF_IDL"),

  /// Closed quantifier-free linear formulas over the theory of integer arrays
  /// extended with free sort and function symbols.
  qfAuflia("QF_AUFLIA"),

  qfAlia('QF_ALIA'),

  qfAuflira('QF_AUFLIRA'),

  qfAufnia('QF_AUFNIA'),

  qfAufnira('QF_AUFNIRA'),

  qfAnia('QF_ANIA'),

  qfLira('QF_LIRA'),

  /// Unquantified linear integer arithmetic with uninterpreted sort and
  /// function symbols.
  qfUflia("QF_UFLIA"),

  /// Difference Logic over the integers (in essence) but with uninterpreted
  /// sort and function symbols.
  qfUfidl("QF_UFIDL"),

  qfUfrdl('QF_UFRDL'),

  /// Quantifier-free integer arithmetic.
  qfNia("QF_NIA"),

  qfNira('QF_NIRA'),

  qfUfnia('QF_UFNIA'),

  qfUfnira('QF_UFNIRA'),

  qfBvre('QF_BVRE'),

  alia('ALIA'),

  /// Closed formulas over the theory of linear integer arithmetic and arrays
  /// extended with free sort and function symbols but restricted to arrays with
  /// integer indices and values.
  auflia("AUFLIA"),

  /// Closed linear formulas with free sort and function symbols over one- and
  /// two-dimentional arrays of integer index and real value.
  auflira("AUFLIRA"),

  aufnia('AUFNIA'),

  /// Closed formulas with free function and predicate symbols over a theory of
  /// arrays of arrays of integer index and real value.
  aufnira("AUFNIRA"),

  uflia('UFLIA'),

  ufnra('UFNRA'),

  ufnira('UFNIRA'),

  nia('NIA'),

  /// Non-linear integer arithmetic with uninterpreted sort and function
  /// symbols.
  ufnia("UFNIA"),

  /// Closed linear formulas over linear integer arithmetic.
  lia("LIA"),

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
  qfBv("QF_BV"),

  /// Unquantified formulas over bitvectors with uninterpreted sort function and
  /// symbols.
  qfUfbv("QF_UFBV"),

  /// Closed quantifier-free formulas over the theory of bitvectors and
  /// bitvector arrays.
  qfAbv("QF_ABV"),

  /// Closed quantifier-free formulas over the theory of bitvectors and
  /// bitvector arrays extended with free sort and function symbols.
  qfAufbv("QF_AUFBV"),

  smtfd('SMTFD'),

  /// Closed quantifier-free formulas over the theory of arrays with
  /// extensionality.
  qfAx("QF_AX"),

  /// Unquantified formulas built over a signature of uninterpreted (i.e., free)
  /// sort and function symbols.
  qfUf("QF_UF"),

  uf('UF'),

  qfUfdt('QF_UFDT'),

  qfDt('QF_DT');

  const LogicKind(this.smtlibName);

  final String smtlibName;
}

abstract class Sym {}

class IntSym extends Sym {
  IntSym(this.value);
  final int value;
  @override
  String toString() => '$value';
  @override
  bool operator ==(Object other) => other is IntSym && other.value == value;
  @override
  int get hashCode => value.hashCode;
}

class StringSym extends Sym {
  StringSym(this.value);
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

  final _config = z3.mk_config();
  static final _finalizer = Finalizer<Z3_config>(z3.del_config);

  @override
  operator []=(String key, String value) {
    final keyPtr = key.toNativeUtf8();
    final valuePtr = key.toNativeUtf8();
    try {
      z3.set_param_value(_config, keyPtr.cast(), valuePtr.cast());
    } finally {
      malloc.free(keyPtr);
      malloc.free(valuePtr);
    }
  }
}

class ContextConfig extends ConfigBase {
  ContextConfig._(this._context);
  final Z3_context _context;

  @override
  void operator []=(String key, String value) {
    final keyPtr = key.toNativeUtf8();
    final valuePtr = key.toNativeUtf8();
    try {
      z3.update_param_value(_context, keyPtr.cast(), valuePtr.cast());
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
  ContextError(this.kind, this.message);

  final ContextErrorKind kind;
  final String message;

  @override
  String toString() => 'ContextError ${kind.name}: $message';
}

class Context {
  Context(this._originalConfig)
      : _context = z3.mk_context_rc(_originalConfig._config) {
    _finalizer.attach(this, _context);
    _instances[_context] = WeakReference(this);
    z3.set_error_handler(_context, Pointer.fromFunction(_errorHandler));
  }

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
    final reason = z3.get_error_msg(c, e).cast<Utf8>().toDartString();
    final context = _instances[c]?.target;
    final err = ContextError(kind, reason);
    if (context == null) {
      Future.error(err);
      return;
    }
    if (context._pendingError != null) {
      Future.error(context._pendingError!);
    }
    context._pendingError = err;
  }

  ContextError? _pendingError;

  final _finalizer = Finalizer<Z3_context>((c) {
    z3.del_context(c);
    _instances.remove(c);
  });
  static final _instances = <Z3_context, WeakReference<Context>>{};

  final Config _originalConfig;
  final Z3_context _context;
  final _symbols = <Z3_symbol, Sym>{};
  late final config = ContextConfig._(_context)
    .._overridden.addAll(_originalConfig._overridden);
  late final _astReg = Registry<AST, Z3_ast>(
      (p) => z3.inc_ref(_context, p), (p) => z3.dec_ref(_context, p));
  late final _fixedpointReg = Registry<Fixedpoint, Z3_fixedpoint>(
      (p) => z3.fixedpoint_inc_ref(_context, p),
      (p) => z3.fixedpoint_dec_ref(_context, p));
  late final _paramsReg = Registry<Params, Z3_params>(
      (p) => z3.params_inc_ref(_context, p),
      (p) => z3.params_dec_ref(_context, p));
  late final _paramDescriptionsReg =
      Registry<ParamDescriptions, Z3_param_descrs>(
          (p) => z3.param_descrs_inc_ref(_context, p),
          (p) => z3.param_descrs_dec_ref(_context, p));
  late final _modelReg = Registry<Model, Z3_model>(
      (p) => z3.model_inc_ref(_context, p),
      (p) => z3.model_dec_ref(_context, p));
  late final _funcInterpReg = Registry<FuncInterp, Z3_func_interp>(
      (p) => z3.func_interp_inc_ref(_context, p),
      (p) => z3.func_interp_dec_ref(_context, p));
  late final _funcEntryReg = Registry<FuncEntry, Z3_func_entry>(
      (p) => z3.func_entry_inc_ref(_context, p),
      (p) => z3.func_entry_dec_ref(_context, p));
  late final _parserContextReg = Registry<ParserContext, Z3_parser_context>(
      (p) => z3.parser_context_inc_ref(_context, p),
      (p) => z3.parser_context_dec_ref(_context, p));
  late final _goalReg = Registry<Goal, Z3_goal>(
      (p) => z3.goal_inc_ref(_context, p), (p) => z3.goal_dec_ref(_context, p));
  late final _tacticReg = Registry<Tactic, Z3_tactic>(
      (p) => z3.tactic_inc_ref(_context, p),
      (p) => z3.tactic_dec_ref(_context, p));
  late final _probeReg = Registry<Probe, Z3_probe>(
      (p) => z3.probe_inc_ref(_context, p),
      (p) => z3.probe_dec_ref(_context, p));
  late final _applyResultReg = Registry<ApplyResult, Z3_apply_result>(
      (p) => z3.apply_result_inc_ref(_context, p),
      (p) => z3.apply_result_dec_ref(_context, p));
  late final _solverReg = Registry<Solver, Z3_solver>(
      (p) => z3.solver_inc_ref(_context, p),
      (p) => z3.solver_dec_ref(_context, p));
  late final _statsReg = Registry<Stats, Z3_stats>(
      (p) => z3.stats_inc_ref(_context, p),
      (p) => z3.stats_dec_ref(_context, p));
  late final _astMapReg = Registry<ASTMap, Z3_ast_map>(
      (p) => z3.ast_map_inc_ref(_context, p),
      (p) => z3.ast_map_dec_ref(_context, p));
  late final _optimizeReg = Registry<Optimize, Z3_optimize>(
      (p) => z3.optimize_inc_ref(_context, p),
      (p) => z3.optimize_dec_ref(_context, p));

  Z3_ast _createAST(AST ast) => _astReg.putHandle(ast, () => ast.build(this));
  Z3_sort _createSort(Sort sort) => _createAST(sort).cast();
  Z3_func_decl _createFuncDecl(FuncDecl funcDecl) =>
      _createAST(funcDecl).cast();
  Z3_pattern _createPattern(Pat pattern) => _createAST(pattern).cast();

  Z3_ast _translateTo(Context other, AST handle, Z3_ast ast) {
    if (other == this) {
      return ast;
    }
    return other._astReg
        .putHandle(handle, () => z3.translate(other._context, ast, _context));
  }

  AST _getAST(Z3_ast ast) {
    print('_getAST($ast)');
    if (ast == nullptr) {
      _checkError();
      throw ArgumentError.notNull('ast');
    }
    var handle = _astReg.getHandle(ast);
    if (handle != null) {
      return handle;
    }
    final kind = z3.get_ast_kind(_context, ast);
    print('kind: $kind');
    switch (kind) {
      case Z3_ast_kind.NUMERAL_AST:
        final sort = _getSort(z3.get_sort(_context, ast));
        if (sort is IntSort || sort is BitVecSort) {
          handle = IntNumeral._(
            this,
            ast,
            sort as IntSort,
            BigInt.parse(z3
                .get_numeral_string(_context, ast)
                .cast<Utf8>()
                .toDartString()),
          );
        } else if (sort is RealSort) {
          if (z3.is_numeral_ast(_context, ast)) {
            handle = RatNumeral._(
              this,
              ast,
              sort,
              Rat.parse(z3
                  .get_numeral_string(_context, ast)
                  .cast<Utf8>()
                  .toDartString()),
            );
          } else {
            handle = IrratNumeral._(this, ast, sort);
          }
        } else if (sort is FloatSort) {
          handle = FloatNumeral._(
            this,
            ast,
            sort,
            z3.get_numeral_double(_context, ast),
          );
        } else {
          throw UnimplementedError('Unknown sort: $sort');
        }
      case Z3_ast_kind.APP_AST:
        final Z3_app app = ast.cast();
        final decl = _getFuncDecl(z3.get_app_decl(_context, app));
        final numArgs = z3.get_app_num_args(_context, app);
        final args = <Expr>[];
        for (var i = 0; i < numArgs; i++) {
          final arg = z3.get_app_arg(_context, app, i);
          args.add(_getAST(arg) as Expr);
        }
        handle = App(decl, args);
      case Z3_ast_kind.VAR_AST:
        handle = Unknown._(this, ast);
      case Z3_ast_kind.QUANTIFIER_AST:
        handle = Unknown._(this, ast);
      case Z3_ast_kind.SORT_AST:
        final Z3_sort sort = ast.cast();
        final sortKind = z3.get_sort_kind(_context, sort);
        switch (sortKind) {
          case Z3_sort_kind.UNINTERPRETED_SORT:
            final name = z3.get_sort_name(_context, sort);
            handle = UninterpretedSort(_getSymbol(name));
          case Z3_sort_kind.BOOL_SORT:
            handle = BoolSort();
          case Z3_sort_kind.INT_SORT:
            handle = IntSort();
          case Z3_sort_kind.REAL_SORT:
            handle = RealSort();
          case Z3_sort_kind.BV_SORT:
            final size = z3.get_bv_sort_size(_context, sort);
            handle = BitVecSort(size);
          case Z3_sort_kind.ARRAY_SORT:
            final n = z3.get_arity(_context, sort.cast());
            final domains = <Sort>[];
            for (var i = 0; i < n; i++) {
              domains.add(_getSort(z3.get_array_sort_domain_n(
                _context,
                sort,
                i,
              )));
            }
            final range = _getSort(z3.get_array_sort_range(_context, sort));
            handle = ArraySort(domains, range);
          case Z3_sort_kind.DATATYPE_SORT:
            handle = Unknown._(this, ast);
          case Z3_sort_kind.FINITE_DOMAIN_SORT:
            handle = Unknown._(this, ast);
          case Z3_sort_kind.FLOATING_POINT_SORT:
            handle = Unknown._(this, ast);
          case Z3_sort_kind.ROUNDING_MODE_SORT:
            handle = Unknown._(this, ast);
          case Z3_sort_kind.SEQ_SORT:
            handle = Unknown._(this, ast);
          case Z3_sort_kind.RE_SORT:
            handle = Unknown._(this, ast);
          case Z3_sort_kind.CHAR_SORT:
            handle = Unknown._(this, ast);
          case Z3_sort_kind.UNKNOWN_SORT:
          default:
            handle = Unknown._(this, ast);
        }
      case Z3_ast_kind.FUNC_DECL_AST:
        final Z3_func_decl funcDecl = ast.cast();
        final numParameters = z3.get_decl_num_parameters(_context, funcDecl);
        final parameters = <Parameter>[];
        for (var i = 0; i < numParameters; i++) {
          // get_decl_parameter_kind throws an assertion when encountering
          // PARAM_EXTERNAL, so we disable assertions temporarily /shrug
          final declKind = _disableAssertions(
            () => z3.get_decl_parameter_kind(_context, funcDecl, i),
          );
          print('declKind: $declKind');
          switch (declKind) {
            case Z3_parameter_kind.PARAMETER_INT:
              final value = z3.get_decl_int_parameter(_context, funcDecl, i);
              parameters.add(value);
              break;
            case Z3_parameter_kind.PARAMETER_DOUBLE:
              final value = z3.get_decl_double_parameter(_context, funcDecl, i);
              parameters.add(value);
              break;
            case Z3_parameter_kind.PARAMETER_RATIONAL:
              final value =
                  z3.get_decl_rational_parameter(_context, funcDecl, i);
              parameters.add(Rat.parse(value.cast<Utf8>().toDartString()));
              break;
            case Z3_parameter_kind.PARAMETER_SYMBOL:
              final symbol =
                  z3.get_decl_symbol_parameter(_context, funcDecl, i);
              parameters.add(_getSymbol(symbol));
              break;
            case Z3_parameter_kind.PARAMETER_SORT:
              final value = z3.get_decl_sort_parameter(_context, funcDecl, i);
              parameters.add(_getSort(value));
              break;
            case Z3_parameter_kind.PARAMETER_AST:
              final value = z3.get_decl_ast_parameter(_context, funcDecl, i);
              parameters.add(_getAST(value));
              break;
            case Z3_parameter_kind.PARAMETER_FUNC_DECL:
              print('eee');
              final value =
                  z3.get_decl_func_decl_parameter(_context, funcDecl, i);
              print('value: $value');
              if (value == nullptr &&
                  z3.get_error_code(_context) == Z3_error_code.INVALID_ARG) {
                // get_decl_parameter_kind returns PARAMETER_FUNC_DECL when
                // encountering PARAM_EXTERNAL, get_decl_func_decl_parameter
                // returns null when the parameter is not a func decl, so we
                // assume its external.
                parameters.add(const ExternalParameter._());
              } else {
                parameters.add(_getFuncDecl(value));
              }
              parameters.add(_getFuncDecl(value));
              break;
            default:
              throw AssertionError('Unknown parameter kind: $kind');
          }
        }
        final declKind = z3.get_decl_kind(_context, funcDecl);
        final name = _getSymbol(z3.get_decl_name(_context, funcDecl));
        final range = _getSort(z3.get_range(_context, funcDecl));
        final domainSize = z3.get_domain_size(_context, funcDecl);
        final domain = <Sort>[];
        for (var i = 0; i < domainSize; i++) {
          domain.add(_getSort(z3.get_domain(_context, funcDecl, i)));
        }
        switch (declKind) {
          case Z3_decl_kind.OP_UNINTERPRETED:
            handle = Func(name, domain, range);
          case Z3_decl_kind.OP_RECURSIVE:
            handle = Func(name, domain, range, recursive: true);
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
              parameters,
              domain,
              range,
            );
        }
        handle = Unknown._(this, ast);
      case Z3_ast_kind.UNKNOWN_AST:
      default:
        handle = Unknown._(this, ast);
    }
    _astReg.putPtr(ast, () => handle!);
    print('_getAST($ast) => $handle');
    return handle;
  }

  Sort _getSort(Z3_sort sort) => _getAST(sort.cast()) as Sort;
  Numeral _getNumeral(Z3_ast ast) => _getAST(ast) as Numeral;
  FuncDecl _getFuncDecl(Z3_func_decl funcDecl) =>
      _getAST(funcDecl.cast()) as FuncDecl;
  Pat _getPattern(Z3_pattern pattern) => _getAST(pattern.cast()) as Pat;
  Fixedpoint _getFixedpoint(Z3_fixedpoint ptr) =>
      _fixedpointReg.putPtr(ptr, () => Fixedpoint._(this, ptr));
  Params _getParams(Z3_params ptr) =>
      _paramsReg.putPtr(ptr, () => Params._(this, ptr));
  ParamDescriptions _getParamDescriptions(Z3_param_descrs ptr) =>
      _paramDescriptionsReg.putPtr(ptr, () => ParamDescriptions._(this, ptr));
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
  Stats _getStats(Z3_stats stats) => _statsReg.getHandle(stats)!;
  ASTMap _getASTMap(Z3_ast_map astMap) => _astMapReg.getHandle(astMap)!;
  Optimize _getOptimize(Z3_optimize optimize) =>
      _optimizeReg.getHandle(optimize)!;

  Z3_symbol _createSymbol(Sym? value) {
    if (value is StringSym) {
      final namePtr = value.value.toNativeUtf8();
      try {
        final symbol = z3.mk_string_symbol(_context, namePtr.cast());
        _symbols.putIfAbsent(symbol, () => value);
        return symbol;
      } finally {
        malloc.free(namePtr);
      }
    } else if (value is IntSym) {
      final symbol = z3.mk_int_symbol(_context, value.value);
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
    final kind = z3.get_symbol_kind(_context, symbol);
    if (kind == Z3_symbol_kind.INT_SYMBOL) {
      final value = z3.get_symbol_int(_context, symbol);
      final result = IntSym(value);
      _symbols[symbol] = result;
      return result;
    } else if (kind == Z3_symbol_kind.STRING_SYMBOL) {
      final value = z3.get_symbol_string(_context, symbol);
      final result = StringSym(value.cast<Utf8>().toDartString());
      _symbols[symbol] = result;
      return result;
    } else {
      throw AssertionError('Unknown symbol kind: $kind');
    }
  }

  late final _boolSort = z3.mk_bool_sort(_context);
  late final _intSort = z3.mk_int_sort(_context);
  late final _realSort = z3.mk_real_sort(_context);
  late final _stringSort = z3.mk_string_sort(_context);
  late final _charSort = z3.mk_char_sort(_context);
  late final _fpaRoundingModeSort = z3.mk_fpa_rounding_mode_sort(_context);

  (Z3_sort, Z3_func_decl, List<Z3_func_decl>) _tupleSort(
    Z3_symbol name,
    Map<Z3_symbol, Z3_sort> fields,
  ) {
    final decls = malloc<Z3_func_decl>(fields.length + 1);
    final sortsPtr = malloc<Z3_sort>(fields.length);
    final namesPtr = malloc<Z3_symbol>(fields.length);
    var i = 0;
    for (final MapEntry(:key, :value) in fields.entries) {
      namesPtr[i] = key;
      sortsPtr[i] = value;
      i++;
    }
    final result = z3.mk_tuple_sort(
      _context,
      name,
      fields.length,
      namesPtr,
      sortsPtr,
      decls.elementAt(i),
      decls,
    );
    final con = decls.elementAt(i).value;
    final proj = List.generate(fields.length, (i) => decls[i]);
    malloc.free(decls);
    malloc.free(sortsPtr);
    malloc.free(namesPtr);
    return (result, con, proj);
  }

  (Z3_sort, List<Z3_func_decl>, List<Z3_func_decl>) _enumSort(
    Z3_symbol name,
    List<Z3_symbol> elements,
  ) {
    final decls = malloc<Z3_func_decl>(elements.length * 2);
    final elementsPtr = malloc<Z3_symbol>(elements.length);
    for (var i = 0; i < elements.length; i++) {
      elementsPtr[i] = elements[i];
    }
    final result = z3.mk_enumeration_sort(
      _context,
      name,
      elements.length,
      elementsPtr,
      decls,
      decls.elementAt(elements.length),
    );
    final constructors = List.generate(
      elements.length,
      (i) => decls.elementAt(i).value,
    );
    final testers = List.generate(
      elements.length,
      (i) => decls.elementAt(i + elements.length).value,
    );
    malloc.free(decls);
    malloc.free(elementsPtr);
    return (result, constructors, testers);
  }

  (
    Z3_sort,
    Z3_func_decl,
    Z3_func_decl,
    Z3_func_decl,
    Z3_func_decl,
    Z3_func_decl,
    Z3_func_decl
  ) _listSort(
    Z3_symbol name,
    Z3_sort element,
  ) {
    final decls = malloc<Z3_func_decl>(6);
    try {
      final result = z3.mk_list_sort(
        _context,
        name,
        element,
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
      return (result, nil, isNil, cons, isCons, head, tail);
    } finally {
      malloc.free(decls);
    }
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
      _checkError();
      throw AssertionError('Unexpected lbool: $value');
    }
  }

  bool? _maybeBool(int value) {
    if (value == Z3_lbool.L_UNDEF) {
      _checkError();
      return null;
    } else {
      return _bool(value);
    }
  }

  List<AST> _unpackAstVector(Z3_ast_vector vector) {
    final result = <AST>[];
    final size = z3.ast_vector_size(_context, vector);
    for (var i = 0; i < size; i++) {
      result.add(_getAST(z3.ast_vector_get(_context, vector, i)));
    }
    z3.ast_vector_inc_ref(_context, vector);
    z3.ast_vector_dec_ref(_context, vector);
    return result;
  }

  Z3_ast_vector _packAstVector(List<AST> asts) {
    final result = z3.mk_ast_vector(_context);
    for (final ast in asts) {
      z3.ast_vector_push(_context, result, _createAST(ast));
    }
    return result;
  }

  AST declare(AST ast) {
    _createAST(ast);
    return ast;
  }

  void declareRecursive(
    Func decl,
    AST body, [
    List<AST> args = const [],
  ]) {
    assert(decl.recursive);
    final funcDecl = _createFuncDecl(decl);
    final bodyAst = _createAST(body);
    final argsPtr = malloc<Z3_ast>(args.length);
    for (var i = 0; i < args.length; i++) {
      argsPtr[i] = _createAST(args[i]);
    }
    z3.add_rec_def(
      _context,
      funcDecl,
      args.length,
      argsPtr,
      bodyAst,
    );
    malloc.free(argsPtr);
  }

  Z3_constructor_list _constructorList(List<Z3_constructor> constructors) {
    final constructorsPtr = malloc<Z3_constructor>(constructors.length);
    for (var i = 0; i < constructors.length; i++) {
      constructorsPtr[i] = constructors[i];
    }
    final result =
        z3.mk_constructor_list(_context, constructors.length, constructorsPtr);
    malloc.free(constructorsPtr);
    return result;
  }

  List<Sort> declareSorts(Map<Sym, List<Constructor>> datatypes) {
    final sortsPtr = malloc<Z3_sort>(datatypes.length);
    final namesPtr = malloc<Z3_symbol>(datatypes.length);
    final constructorsPtr = malloc<Z3_constructor_list>(datatypes.length);
    final allConstructors = <Z3_constructor>[];

    var i = 0;
    for (final MapEntry(:key, :value) in datatypes.entries) {
      namesPtr[i] = _createSymbol(key);
      final constructors = value.map((e) => e.buildConstructor(this)).toList();
      allConstructors.addAll(constructors);
      constructorsPtr[i] = _constructorList(constructors);
      i++;
    }

    z3.mk_datatypes(
      _context,
      datatypes.length,
      namesPtr,
      sortsPtr,
      constructorsPtr,
    );

    final result =
        List.generate(datatypes.length, (i) => _getSort(sortsPtr[i]));

    for (var i = 0; i < datatypes.length; i++) {
      z3.del_constructor_list(_context, constructorsPtr[i]);
    }

    for (final constructor in allConstructors) {
      z3.del_constructor(_context, constructor);
    }

    malloc.free(sortsPtr);
    malloc.free(namesPtr);
    malloc.free(constructorsPtr);

    return result;
  }

  Sym getSortName(Sort sort) {
    final symbol = z3.get_sort_name(_context, _createSort(sort));
    return _getSymbol(symbol);
  }

  int getSortId(Sort sort) {
    return z3.get_sort_id(_context, _createSort(sort));
  }

  bool sortsEqual(Sort a, Sort b) {
    return z3.is_eq_sort(_context, _createSort(a), _createSort(b));
  }

  bool funcDeclsEqual(FuncDecl a, FuncDecl b) {
    return z3.is_eq_func_decl(_context, _createFuncDecl(a), _createFuncDecl(b));
  }

  AST simplify(AST ast, [Params? params]) {
    if (params == null) {
      return _getAST(z3.simplify(_context, _createAST(ast)));
    } else {
      return _getAST(z3.simplify_ex(_context, _createAST(ast), params._params));
    }
  }

  ParamDescriptions get simplifyParamDescriptions =>
      _getParamDescriptions(z3.simplify_get_param_descrs(_context));

  AST updateTerm(AST ast, List<AST> args) {
    final argsPtr = malloc<Z3_ast>(args.length);
    for (var i = 0; i < args.length; i++) {
      argsPtr[i] = _createAST(args[i]);
    }
    final result =
        z3.update_term(_context, _createAST(ast), args.length, argsPtr);
    malloc.free(argsPtr);
    return _getAST(result);
  }

  AST substitute(AST ast, List<AST> from, List<AST> to) {
    assert(from.length == to.length);
    final fromPtr = malloc<Z3_ast>(from.length);
    final toPtr = malloc<Z3_ast>(to.length);
    for (var i = 0; i < from.length; i++) {
      fromPtr[i] = _createAST(from[i]);
      toPtr[i] = _createAST(to[i]);
    }
    final result = z3.substitute(
      _context,
      _createAST(ast),
      from.length,
      fromPtr,
      toPtr,
    );
    malloc.free(fromPtr);
    malloc.free(toPtr);
    return _getAST(result);
  }

  AST substituteVars(AST ast, List<AST> to) {
    final toPtr = malloc<Z3_ast>(to.length);
    for (var i = 0; i < to.length; i++) {
      toPtr[i] = _createAST(to[i]);
    }
    final result = z3.substitute_vars(
      _context,
      _createAST(ast),
      to.length,
      toPtr,
    );
    malloc.free(toPtr);
    return _getAST(result);
  }

  AST substituteFuncs(AST ast, List<FuncDecl> from, List<AST> to) {
    assert(from.length == to.length);
    final fromPtr = malloc<Z3_func_decl>(from.length);
    final toPtr = malloc<Z3_ast>(to.length);
    for (var i = 0; i < from.length; i++) {
      fromPtr[i] = _createFuncDecl(from[i]);
      toPtr[i] = _createAST(to[i]);
    }
    final result = z3.substitute_funs(
      _context,
      _createAST(ast),
      from.length,
      fromPtr,
      toPtr,
    );
    malloc.free(fromPtr);
    malloc.free(toPtr);
    return _getAST(result);
  }

  void setASTPrintMode(ASTPrintMode mode) {
    switch (mode) {
      case ASTPrintMode.smtlibFull:
        z3.set_ast_print_mode(_context, Z3_ast_print_mode.PRINT_SMTLIB_FULL);
      case ASTPrintMode.lowLevel:
        z3.set_ast_print_mode(_context, Z3_ast_print_mode.PRINT_LOW_LEVEL);
      case ASTPrintMode.smtlib2Compliant:
        z3.set_ast_print_mode(
            _context, Z3_ast_print_mode.PRINT_SMTLIB2_COMPLIANT);
    }
  }

  String astToString(AST ast) {
    return z3
        .ast_to_string(_context, _createAST(ast))
        .cast<Utf8>()
        .toDartString();
  }

  String benchmarkToSmtlib({
    required String name,
    required String logic,
    required String status,
    required String attributes,
    required List<AST> assumptions,
    required AST formula,
  }) {
    final assumptionsPtr = malloc<Z3_ast>(assumptions.length);
    for (var i = 0; i < assumptions.length; i++) {
      assumptionsPtr[i] = _createAST(assumptions[i]);
    }
    final namePtr = name.toNativeUtf8();
    final logicPtr = logic.toNativeUtf8();
    final statusPtr = status.toNativeUtf8();
    final attributesPtr = attributes.toNativeUtf8();
    final result = z3.benchmark_to_smtlib_string(
      _context,
      namePtr.cast(),
      logicPtr.cast(),
      statusPtr.cast(),
      attributesPtr.cast(),
      assumptions.length,
      assumptionsPtr,
      _createAST(formula),
    );
    malloc.free(assumptionsPtr);
    malloc.free(namePtr);
    malloc.free(logicPtr);
    malloc.free(statusPtr);
    malloc.free(attributesPtr);
    return result.cast<Utf8>().toDartString();
  }

  List<AST> parse(
    String str, {
    Map<Sym, Sort> sorts = const {},
    Map<Sym, FuncDecl> decls = const {},
  }) {
    final sortsPtr = malloc<Z3_symbol>(sorts.length);
    final sortsSortsPtr = malloc<Z3_sort>(sorts.length);
    final declsPtr = malloc<Z3_symbol>(decls.length);
    final declsFuncDeclsPtr = malloc<Z3_func_decl>(decls.length);
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
    final strPtr = str.toNativeUtf8();
    final vec = z3.parse_smtlib2_string(
      _context,
      strPtr.cast(),
      sorts.length,
      sortsPtr,
      sortsSortsPtr,
      decls.length,
      declsPtr,
      declsFuncDeclsPtr,
    );
    malloc.free(sortsPtr);
    malloc.free(sortsSortsPtr);
    malloc.free(declsPtr);
    malloc.free(declsFuncDeclsPtr);
    malloc.free(strPtr);
    return _unpackAstVector(vec);
  }

  String eval(String str) {
    final strPtr = str.toNativeUtf8();
    final result = z3.eval_smtlib2_string(_context, strPtr.cast());
    malloc.free(strPtr);
    return result.cast<Utf8>().toDartString();
  }

  Probe probe(double value) {
    final result = z3.probe_const(_context, value);
    return _getProbe(result);
  }

  A translateTo<A extends AST>(Context other, A ast) {
    return other._getAST(_translateTo(other, ast, _createAST(ast))) as A;
  }

  late final Map<String, BuiltinTactic> builtinTactics = () {
    final result = <String, BuiltinTactic>{};
    final count = z3.get_num_tactics(_context);
    for (var i = 0; i < count; i++) {
      final name = z3.get_tactic_name(_context, i);
      final nameStr = name.cast<Utf8>().toDartString();
      final tactic = z3.mk_tactic(_context, name);
      result[nameStr] = _tacticReg.putPtr(
        tactic,
        () => BuiltinTactic._(this, tactic, nameStr),
      ) as BuiltinTactic;
    }
    return result;
  }();

  late final Map<String, BuiltinProbe> builtinProbes = () {
    final result = <String, BuiltinProbe>{};
    final count = z3.get_num_probes(_context);
    for (var i = 0; i < count; i++) {
      final name = z3.get_probe_name(_context, i);
      final nameStr = name.cast<Utf8>().toDartString();
      final probe = z3.mk_probe(_context, name);
      result[nameStr] = _probeReg.putPtr(
        probe,
        () => BuiltinProbe._(this, probe, nameStr),
      ) as BuiltinProbe;
    }
    return result;
  }();

  Solver solver({LogicKind? logic}) {
    if (logic == null) {
      return _getSolver(z3.mk_solver(_context));
    } else {
      return _getSolver(z3.mk_solver_for_logic(
        _context,
        _createSymbol(StringSym(logic.smtlibName)),
      ));
    }
  }

  Solver simpleSolver() {
    return _getSolver(z3.mk_simple_solver(_context));
  }

  late final paramDesc =
      ParamDescriptions._(this, z3.get_global_param_descrs(_context));
}

class Params {
  Params._(this._c, this._params);
  final Context _c;
  final Z3_params _params;

  operator []=(String key, dynamic value) {
    final k = _c._createSymbol(StringSym(key));
    if (value is String) {
      final v = _c._createSymbol(StringSym(value));
      z3.params_set_symbol(_c._context, _params, k, v);
    } else if (value is int) {
      z3.params_set_uint(_c._context, _params, k, value);
    } else if (value is double) {
      z3.params_set_double(_c._context, _params, k, value);
    } else if (value is bool) {
      z3.params_set_bool(_c._context, _params, k, value);
    } else if (value is Sym) {
      z3.params_set_symbol(_c._context, _params, k, _c._createSymbol(value));
    } else {
      throw ArgumentError.value(
        value,
        'value',
        'must be String, int, double, bool, or Sym, got ${value.runtimeType}',
      );
    }
  }

  void validate(ParamDescriptions descriptions) {
    z3.params_validate(_c._context, _params, descriptions._desc);
  }

  @override
  String toString() {
    return z3
        .params_to_string(_c._context, _params)
        .cast<Utf8>()
        .toDartString();
  }
}

late final Context _mathContext = Context(Config());

class Fixedpoint {
  Fixedpoint._(this._c, this._fp) {
    _instances[_fp] = WeakReference(this);
    _finalizer.attach(this, _fp);
    z3.fixedpoint_init(_c._context, _fp, _fp.cast());
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
    z3.fixedpoint_add_rule(_c._context, _fp, _c._createAST(rule), name);
  }

  void addFact(FuncDecl relation, List<int> args) {
    final argsPtr = malloc<UnsignedInt>(args.length);
    for (var i = 0; i < args.length; i++) {
      argsPtr[i] = args[i];
    }
    z3.fixedpoint_add_fact(
      _c._context,
      _fp,
      _c._createFuncDecl(relation),
      args.length,
      argsPtr,
    );
    malloc.free(argsPtr);
  }

  void assertConstraint(AST axiom) {
    z3.fixedpoint_assert(_c._context, _fp, _c._createAST(axiom));
  }

  void addConstraint(AST axiom, int level) {
    z3.fixedpoint_add_constraint(_c._context, _fp, _c._createAST(axiom), level);
  }

  bool query(AST query) {
    final result = z3.fixedpoint_query(_c._context, _fp, _c._createAST(query));
    return _c._bool(result);
  }

  bool queryRelations(List<FuncDecl> relations) {
    final relationsPtr = malloc<Z3_func_decl>(relations.length);
    for (var i = 0; i < relations.length; i++) {
      relationsPtr[i] = _c._createFuncDecl(relations[i]);
    }
    final result = z3.fixedpoint_query_relations(
      _c._context,
      _fp,
      relations.length,
      relationsPtr,
    );
    malloc.free(relationsPtr);
    return _c._bool(result);
  }

  AST getAnswer() {
    return _c._getAST(z3.fixedpoint_get_answer(_c._context, _fp));
  }

  String getReasonUnknown() {
    return z3
        .fixedpoint_get_reason_unknown(_c._context, _fp)
        .cast<Utf8>()
        .toDartString();
  }

  void updateRule(AST rule, Z3_symbol name) {
    z3.fixedpoint_update_rule(_c._context, _fp, _c._createAST(rule), name);
  }

  void getNumLevels(FuncDecl pred) {
    z3.fixedpoint_get_num_levels(_c._context, _fp, _c._createFuncDecl(pred));
  }

  void getCoverDelta(int level, FuncDecl pred) {
    z3.fixedpoint_get_cover_delta(
      _c._context,
      _fp,
      level,
      _c._createFuncDecl(pred),
    );
  }

  void addCover(int level, FuncDecl pred, AST property) {
    z3.fixedpoint_add_cover(
      _c._context,
      _fp,
      level,
      _c._createFuncDecl(pred),
      _c._createAST(property),
    );
  }

  Stats getStatistics() {
    return _c._getStats(z3.fixedpoint_get_statistics(_c._context, _fp));
  }

  void registerRelation(FuncDecl relation) {
    z3.fixedpoint_register_relation(
      _c._context,
      _fp,
      _c._createFuncDecl(relation),
    );
  }

  void setPredicateRepresentation(FuncDecl relation, List<Sym> kinds) {
    final kindsPtr = malloc<Z3_symbol>(kinds.length);
    for (var i = 0; i < kinds.length; i++) {
      kindsPtr[i] = _c._createSymbol(kinds[i]);
    }
    z3.fixedpoint_set_predicate_representation(
      _c._context,
      _fp,
      _c._createFuncDecl(relation),
      kinds.length,
      kindsPtr,
    );
    malloc.free(kindsPtr);
  }

  List<AST> getRules() {
    final result = z3.fixedpoint_get_rules(_c._context, _fp);
    return _c._unpackAstVector(result);
  }

  List<AST> getAssertions() {
    final result = z3.fixedpoint_get_assertions(_c._context, _fp);
    return _c._unpackAstVector(result);
  }

  void setParams(Params params) {
    z3.fixedpoint_set_params(_c._context, _fp, params._params);
  }

  String getHelp() {
    return z3.fixedpoint_get_help(_c._context, _fp).cast<Utf8>().toDartString();
  }

  ParamDescriptions getParamDescriptions() {
    return _c._getParamDescriptions(
        z3.fixedpoint_get_param_descrs(_c._context, _fp));
  }

  List<AST> addFromString(String s) {
    final sPtr = s.toNativeUtf8();
    final result = z3.fixedpoint_from_string(_c._context, _fp, sPtr.cast());
    malloc.free(sPtr);
    return _c._unpackAstVector(result);
  }

  List<AST> addFromFile(File file) {
    final pathPtr = file.path.toNativeUtf8();
    final result = z3.fixedpoint_from_file(_c._context, _fp, pathPtr.cast());
    malloc.free(pathPtr);
    return _c._unpackAstVector(result);
  }

  static void _onReduceAssignCallback(
    Pointer<Void> state,
    Z3_func_decl decl,
    int numArgs,
    Pointer<Z3_ast> args,
    int numOuts,
    Pointer<Z3_ast> outs,
  ) {
    final fp = _instances[state]!.target!;
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
      z3.fixedpoint_set_reduce_assign_callback(
        _c._context,
        _fp,
        nullptr,
      );
      _onReduceAssign = null;
    } else if (f != null && _onReduceAssign == null) {
      z3.fixedpoint_set_reduce_assign_callback(
        _c._context,
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
    final fp = _instances[state]!.target!;
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
      z3.fixedpoint_set_reduce_app_callback(
        _c._context,
        _fp,
        nullptr,
      );
      _onReduceApply = null;
    } else if (f != null && _onReduceApply == null) {
      z3.fixedpoint_set_reduce_app_callback(
        _c._context,
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
    final fp = _instances[state]!.target!;
    fp._onLemma!(
      fp._c._getAST(lemma),
      level,
    );
  }

  static void _onPredecessorCallback(
    Pointer<Void> state,
  ) {
    final fp = _instances[state]!.target!;
    fp._onPredecessor!();
  }

  static void _onUnfoldCallback(
    Pointer<Void> state,
  ) {
    final fp = _instances[state]!.target!;
    fp._onUnfold!();
  }

  bool get _areLemmaCallbacksNull =>
      _onLemma == null && _onPredecessor == null && _onUnfold == null;

  void _updateCallbacks(bool wasNull) {
    final isNull = _areLemmaCallbacksNull;
    if (wasNull && !isNull) {
      z3.fixedpoint_add_callback(
        _c._context,
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
      z3.fixedpoint_add_callback(
        _c._context,
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
    final extraPtr = malloc<Z3_ast>(extra?.length ?? 0);
    for (var i = 0; i < (extra?.length ?? 0); i++) {
      extraPtr[i] = _c._createAST(extra![i]);
    }
    final result = z3
        .fixedpoint_to_string(
          _c._context,
          _fp,
          extra?.length ?? 0,
          extraPtr,
        )
        .cast<Utf8>()
        .toDartString();
    malloc.free(extraPtr);
    return result;
  }
}

class Model {
  Model._(this._c, this._model);

  final Context _c;
  final Z3_model _model;

  AST? eval(AST t, {bool completion = true}) {
    final resultPtr = malloc<Z3_ast>();
    final success = z3.model_eval(
      _c._context,
      _model,
      _c._createAST(t),
      completion,
      resultPtr,
    );
    if (success) {
      final result = _c._getAST(resultPtr.value);
      malloc.free(resultPtr);
      return result;
    }
    malloc.free(resultPtr);
    return null;
  }

  AST? getConstInterp(FuncDecl decl) {
    final result = z3.model_get_const_interp(
      _c._context,
      _model,
      _c._createFuncDecl(decl),
    );
    if (result == nullptr) {
      return null;
    }
    return _c._getAST(result);
  }

  FuncInterp? getFuncInterp(FuncDecl decl) {
    final result = z3.model_get_func_interp(
      _c._context,
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
    final size = z3.model_get_num_consts(_c._context, _model);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getFuncDecl(z3.model_get_const_decl(_c._context, _model, i)),
      );
    }
    return result;
  }

  List<FuncDecl> getFuncs() {
    final result = <FuncDecl>[];
    final size = z3.model_get_num_funcs(_c._context, _model);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getFuncDecl(z3.model_get_func_decl(_c._context, _model, i)),
      );
    }
    return result;
  }

  List<Sort> getSorts() {
    final result = <Sort>[];
    final size = z3.model_get_num_sorts(_c._context, _model);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getSort(z3.model_get_sort(_c._context, _model, i)),
      );
    }
    return result;
  }

  List<Expr> getSortUniverse(Sort s) {
    final vector = z3.model_get_sort_universe(
      _c._context,
      _model,
      _c._createSort(s),
    );
    return _c._unpackAstVector(vector).cast();
  }

  Model toContext(Context c) {
    final ptr = z3.model_translate(_c._context, _model, c._context);
    return c._getModel(ptr);
  }

  FuncInterp addFuncInterp(FuncDecl decl, AST defaultValue) {
    final result = z3.add_func_interp(
      _c._context,
      _model,
      _c._createFuncDecl(decl),
      _c._createAST(defaultValue),
    );
    return _c._getFuncInterp(result);
  }

  void addConstInterp(FuncDecl decl, AST value) {
    z3.add_const_interp(
      _c._context,
      _model,
      _c._createFuncDecl(decl),
      _c._createAST(value),
    );
  }

  @override
  String toString() {
    return z3.model_to_string(_c._context, _model).cast<Utf8>().toDartString();
  }
}

class FuncInterp {
  FuncInterp._(this._c, this._f);

  final Context _c;
  final Z3_func_interp _f;

  List<FuncEntry> getEntries() {
    final result = <FuncEntry>[];
    final size = z3.func_interp_get_num_entries(_c._context, _f);
    for (var i = 0; i < size; i++) {
      final e = z3.func_interp_get_entry(_c._context, _f, i);
      result.add(_c._getFuncEntry(e));
    }
    return result;
  }

  AST getElse() {
    return _c._getAST(z3.func_interp_get_else(_c._context, _f));
  }

  void setElse(AST value) {
    z3.func_interp_set_else(_c._context, _f, _c._createAST(value));
  }

  void addEntry(List<AST> args, AST value) {
    final vec = z3.mk_ast_vector(_c._context);
    z3.ast_vector_inc_ref(_c._context, vec);
    for (var i = 0; i < args.length; i++) {
      z3.ast_vector_push(_c._context, vec, _c._createAST(args[i]));
    }
    z3.func_interp_add_entry(
      _c._context,
      _f,
      vec,
      _c._createAST(value),
    );
    z3.ast_vector_dec_ref(_c._context, vec);
  }

  int getArity() {
    return z3.func_interp_get_arity(_c._context, _f);
  }
}

class FuncEntry {
  FuncEntry._(this._c, this._e);

  final Context _c;
  final Z3_func_entry _e;

  AST getValue() {
    return _c._getAST(z3.func_entry_get_value(_c._context, _e));
  }

  List<AST> getArgs() {
    final result = <AST>[];
    final size = z3.func_entry_get_num_args(_c._context, _e);
    for (var i = 0; i < size; i++) {
      result.add(_c._getAST(z3.func_entry_get_arg(_c._context, _e, i)));
    }
    return result;
  }
}

class ParserContext {
  ParserContext._(this._c, this._pc);

  final Context _c;
  final Z3_parser_context _pc;

  void addSort(Sort sort) {
    z3.parser_context_add_sort(
      _c._context,
      _pc,
      _c._createSort(sort),
    );
  }

  void addDecl(FuncDecl decl) {
    z3.parser_context_add_decl(
      _c._context,
      _pc,
      _c._createFuncDecl(decl),
    );
  }

  List<AST> parse(String str) {
    final strPtr = str.toNativeUtf8();
    final result = z3.parser_context_from_string(
      _c._context,
      _pc,
      strPtr.cast(),
    );
    malloc.free(strPtr);
    return _c._unpackAstVector(result);
  }
}

class Goal {
  Goal._(this._c, this._goal);

  final Context _c;
  final Z3_goal _goal;

  GoalPrecision getPrecision() {
    final result = z3.goal_precision(_c._context, _goal);
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
    z3.goal_assert(_c._context, _goal, _c._createAST(a));
  }

  bool isInconsistent() {
    return z3.goal_inconsistent(_c._context, _goal);
  }

  int getDepth() {
    return z3.goal_depth(_c._context, _goal);
  }

  void reset() {
    z3.goal_reset(_c._context, _goal);
  }

  int getSize() {
    return z3.goal_size(_c._context, _goal);
  }

  int getNumExprs() {
    return z3.goal_num_exprs(_c._context, _goal);
  }

  bool isDecidedSat() {
    return z3.goal_is_decided_sat(_c._context, _goal);
  }

  bool isDecidedUnsat() {
    return z3.goal_is_decided_unsat(_c._context, _goal);
  }

  Goal toContext(Context c) {
    final ptr = z3.goal_translate(_c._context, _goal, c._context);
    return c._getGoal(ptr);
  }

  Model convert(Model? m) {
    final ptr = z3.goal_convert_model(_c._context, _goal, m?._model ?? nullptr);
    return _c._getModel(ptr);
  }

  @override
  String toString() {
    return z3.goal_to_string(_c._context, _goal).cast<Utf8>().toDartString();
  }

  String toDimacs({bool includeNames = true}) {
    return z3
        .goal_to_dimacs_string(_c._context, _goal, includeNames)
        .cast<Utf8>()
        .toDartString();
  }
}

class Tactic {
  Tactic._(this._c, this._tactic);

  factory Tactic.parallelOr(List<Tactic> tactics) {
    final tacticsPtr = malloc<Z3_tactic>(tactics.length);
    for (var i = 0; i < tactics.length; i++) {
      tacticsPtr[i] = tactics[i]._tactic;
    }
    final _c = tactics[0]._c;
    final result = z3.tactic_par_or(
      _c._context,
      tactics.length,
      tacticsPtr,
    );
    malloc.free(tacticsPtr);
    return _c._getTactic(result);
  }

  final Context _c;
  final Z3_tactic _tactic;

  Tactic andThen(Tactic other) {
    final result = z3.tactic_and_then(_c._context, _tactic, other._tactic);
    return _c._getTactic(result);
  }

  Tactic orElse(Tactic other) {
    final result = z3.tactic_or_else(_c._context, _tactic, other._tactic);
    return _c._getTactic(result);
  }

  Tactic parAndThen(Tactic other) {
    final result = z3.tactic_par_and_then(_c._context, _tactic, other._tactic);
    return _c._getTactic(result);
  }

  Tactic tryFor(Duration duration) {
    final result = z3.tactic_try_for(
      _c._context,
      _tactic,
      duration.inMilliseconds,
    );
    return _c._getTactic(result);
  }

  Tactic when(Probe p) {
    final result = z3.tactic_when(_c._context, p._probe, _tactic);
    return _c._getTactic(result);
  }

  Tactic cond(Tactic otherwise, Probe p) {
    final result = z3.tactic_cond(
      _c._context,
      p._probe,
      _tactic,
      otherwise._tactic,
    );
    return _c._getTactic(result);
  }

  Tactic repeat(int max) {
    final result = z3.tactic_repeat(_c._context, _tactic, max);
    return _c._getTactic(result);
  }

  Tactic skip() {
    final result = z3.tactic_skip(_c._context);
    return _c._getTactic(result);
  }

  Tactic fail() {
    final result = z3.tactic_fail(_c._context);
    return _c._getTactic(result);
  }

  Tactic failIf(Probe p) {
    final result = z3.tactic_fail_if(_c._context, p._probe);
    return _c._getTactic(result);
  }

  Tactic failIfNotDecided() {
    final result = z3.tactic_fail_if_not_decided(_c._context);
    return _c._getTactic(result);
  }

  Tactic usingParams(Params params) {
    final result = z3.tactic_using_params(_c._context, _tactic, params._params);
    return _c._getTactic(result);
  }

  String getParamHelp() {
    return z3.tactic_get_help(_c._context, _tactic).cast<Utf8>().toDartString();
  }

  ParamDescriptions getParamDescriptions() {
    return _c._getParamDescriptions(
        z3.tactic_get_param_descrs(_c._context, _tactic));
  }

  ApplyResult apply(Goal g, {Params? params}) {
    if (params != null) {
      return _c._getApplyResult(
        z3.tactic_apply_ex(
          _c._context,
          _tactic,
          g._goal,
          params._params,
        ),
      );
    } else {
      return _c._getApplyResult(z3.tactic_apply(_c._context, _tactic, g._goal));
    }
  }

  Solver toSolver() {
    return _c._getSolver(z3.mk_solver_from_tactic(_c._context, _tactic));
  }
}

class BuiltinTactic extends Tactic {
  BuiltinTactic._(Context c, Z3_tactic tactic, this.name) : super._(c, tactic);

  final String name;
  String getHelp() {
    final namePtr = name.toNativeUtf8();
    final result = z3.tactic_get_descr(_c._context, namePtr.cast());
    malloc.free(namePtr);
    return result.cast<Utf8>().toDartString();
  }
}

class Probe {
  Probe._(this._c, this._probe);

  final Context _c;
  final Z3_probe _probe;

  Probe operator <(Probe other) {
    final result = z3.probe_lt(_c._context, _probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator >(Probe other) {
    final result = z3.probe_gt(_c._context, _probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator <=(Probe other) {
    final result = z3.probe_le(_c._context, _probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator >=(Probe other) {
    final result = z3.probe_ge(_c._context, _probe, other._probe);
    return _c._getProbe(result);
  }

  Probe equals(Probe other) {
    final result = z3.probe_eq(_c._context, _probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator &(Probe other) {
    final result = z3.probe_and(_c._context, _probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator |(Probe other) {
    final result = z3.probe_or(_c._context, _probe, other._probe);
    return _c._getProbe(result);
  }

  Probe operator ~() {
    final result = z3.probe_not(_c._context, _probe);
    return _c._getProbe(result);
  }

  double apply(Goal g) {
    return z3.probe_apply(_c._context, _probe, g._goal);
  }
}

class BuiltinProbe extends Probe {
  BuiltinProbe._(Context c, Z3_probe probe, this.name) : super._(c, probe);

  final String name;
  String getHelp() {
    final namePtr = name.toNativeUtf8();
    final result = z3.probe_get_descr(_c._context, namePtr.cast());
    malloc.free(namePtr);
    return result.cast<Utf8>().toDartString();
  }
}

class ApplyResult {
  ApplyResult._(this._c, this._result);

  final Context _c;
  final Z3_apply_result _result;

  List<Goal> getSubgoals() {
    final result = <Goal>[];
    final size = z3.apply_result_get_num_subgoals(_c._context, _result);
    for (var i = 0; i < size; i++) {
      result.add(
        _c._getGoal(z3.apply_result_get_subgoal(_c._context, _result, i)),
      );
    }
    return result;
  }

  @override
  String toString() {
    return z3
        .apply_result_to_string(_c._context, _result)
        .cast<Utf8>()
        .toDartString();
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

  Solver toContext(Context c) {
    final ptr = z3.solver_translate(_c._context, _solver, c._context);
    return c._getSolver(ptr);
  }

  void importConverterFrom(Solver other) {
    z3.solver_import_model_converter(_c._context, other._solver, _solver);
  }

  String getHelp() {
    return z3.solver_get_help(_c._context, _solver).cast<Utf8>().toDartString();
  }

  ParamDescriptions getParamDescriptions() {
    return _c._getParamDescriptions(
        z3.solver_get_param_descrs(_c._context, _solver));
  }

  void setParams(Params params) {
    z3.solver_set_params(_c._context, _solver, params._params);
  }

  void push() {
    z3.solver_push(_c._context, _solver);
  }

  void pop([int n = 1]) {
    z3.solver_pop(_c._context, _solver, n);
  }

  void reset() {
    z3.solver_reset(_c._context, _solver);
  }

  int getNumScopes() {
    return z3.solver_get_num_scopes(_c._context, _solver);
  }

  void assertExpr(AST a, {Const? constant}) {
    if (constant != null) {
      z3.solver_assert_and_track(
        _c._context,
        _solver,
        _c._createAST(a),
        _c._createAST(constant),
      );
    } else {
      z3.solver_assert(_c._context, _solver, _c._createAST(a));
    }
  }

  void assertFromFile(File file) {
    final pathPtr = file.path.toNativeUtf8();
    z3.solver_from_file(_c._context, _solver, pathPtr.cast());
    malloc.free(pathPtr);
  }

  void assertFromString(String str) {
    final strPtr = str.toNativeUtf8();
    z3.solver_from_string(_c._context, _solver, strPtr.cast());
    malloc.free(strPtr);
  }

  List<AST> getAssertions() {
    final vec = z3.solver_get_assertions(_c._context, _solver);
    return _c._unpackAstVector(vec).cast();
  }

  List<AST> getUnits() {
    final vec = z3.solver_get_units(_c._context, _solver);
    return _c._unpackAstVector(vec).cast();
  }

  List<AST> getTrail() {
    final vec = z3.solver_get_trail(_c._context, _solver);
    return _c._unpackAstVector(vec).cast();
  }

  List<AST> getNonUnits() {
    final vec = z3.solver_get_non_units(_c._context, _solver);
    return _c._unpackAstVector(vec).cast();
  }

  AST congruenceRoot(AST a) {
    return _c._getAST(z3.solver_congruence_root(
      _c._context,
      _solver,
      _c._createAST(a),
    ));
  }

  AST congruenceNext(AST a) {
    return _c._getAST(z3.solver_congruence_next(
      _c._context,
      _solver,
      _c._createAST(a),
    ));
  }

  bool? check() {
    return _c._maybeBool(z3.solver_check(_c._context, _solver));
  }

  bool? checkAssumptions(List<AST> assumptions) {
    final assumptionsPtr = malloc<Z3_ast>(assumptions.length);
    for (var i = 0; i < assumptions.length; i++) {
      assumptionsPtr[i] = _c._createAST(assumptions[i]);
    }
    final result = _c._maybeBool(z3.solver_check_assumptions(
      _c._context,
      _solver,
      assumptions.length,
      assumptionsPtr,
    ));
    malloc.free(assumptionsPtr);
    return result;
  }

  List<int>? getImpliedEqualities(List<Expr> terms) {
    final termsPtr = malloc<Z3_ast>(terms.length);
    final classIdsPtr = malloc<UnsignedInt>(terms.length);
    for (var i = 0; i < terms.length; i++) {
      termsPtr[i] = _c._createAST(terms[i]);
    }
    final result = _c._bool(z3.get_implied_equalities(
      _c._context,
      _solver,
      terms.length,
      termsPtr,
      classIdsPtr,
    ));
    final classIds = <int>[];
    for (var i = 0; i < terms.length; i++) {
      classIds.add(classIdsPtr[i]);
    }
    malloc.free(termsPtr);
    malloc.free(classIdsPtr);
    if (result == false) {
      return null;
    }
    return classIds;
  }

  List<Expr>? getConsequences(List<Expr> assumptions, List<Expr> variables) {
    final assumptionsVec = _c._packAstVector(assumptions);
    z3.ast_vector_inc_ref(_c._context, assumptionsVec);
    final variablesVec = _c._packAstVector(variables);
    z3.ast_vector_inc_ref(_c._context, variablesVec);
    final consequencesVec = z3.mk_ast_vector(_c._context);
    z3.ast_vector_inc_ref(_c._context, consequencesVec);
    final result = _c._bool(z3.solver_get_consequences(
      _c._context,
      _solver,
      assumptionsVec,
      variablesVec,
      consequencesVec,
    ));
    final consequences = _c._unpackAstVector(consequencesVec).cast<Expr>();
    z3.ast_vector_dec_ref(_c._context, assumptionsVec);
    z3.ast_vector_dec_ref(_c._context, variablesVec);
    z3.ast_vector_dec_ref(_c._context, consequencesVec);
    if (result == false) {
      return null;
    }
    return consequences;
  }

  List<AST> cube(List<Expr> variables, int backtrackLevel) {
    final variablesVec = _c._packAstVector(variables);
    z3.ast_vector_inc_ref(_c._context, variablesVec);
    final result = _c._unpackAstVector(z3.solver_cube(
      _c._context,
      _solver,
      variablesVec,
      backtrackLevel,
    ));
    z3.ast_vector_dec_ref(_c._context, variablesVec);
    return result.cast();
  }

  Model getModel() {
    final result = z3.solver_get_model(_c._context, _solver);
    return _c._getModel(result);
  }

  AST getProof() {
    return _c._getAST(z3.solver_get_proof(_c._context, _solver));
  }

  List<AST> getUnsatCore() {
    final result = z3.solver_get_unsat_core(_c._context, _solver);
    return _c._unpackAstVector(result);
  }

  String getReasonUnknown() {
    return z3
        .solver_get_reason_unknown(_c._context, _solver)
        .cast<Utf8>()
        .toDartString();
  }

  Stats getStats() {
    return _c._getStats(z3.solver_get_statistics(_c._context, _solver));
  }

  @override
  String toString() {
    return z3
        .solver_to_string(_c._context, _solver)
        .cast<Utf8>()
        .toDartString();
  }

  String toDimacs({bool includeNames = true}) {
    return z3
        .solver_to_dimacs_string(_c._context, _solver, includeNames)
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
    final size = z3.stats_size(_c._context, _stats);
    for (var i = 0; i < size; i++) {
      final key =
          z3.stats_get_key(_c._context, _stats, i).cast<Utf8>().toDartString();
      if (z3.stats_is_uint(_c._context, _stats, i)) {
        result[key] = z3.stats_get_uint_value(
          _c._context,
          _stats,
          i,
        );
      } else if (z3.stats_is_double(_c._context, _stats, i)) {
        result[key] = z3.stats_get_double_value(
          _c._context,
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
    return z3.stats_to_string(_c._context, _stats).cast<Utf8>().toDartString();
  }
}

class ASTMap {}

class Optimize {}

class ParamDescriptions {
  ParamDescriptions._(this.context, this._desc) : _context = context._context;
  final Context context;
  final Z3_context _context;
  final Z3_param_descrs _desc;

  Z3ParamKind getKind(Sym key) {
    final kind = z3.param_descrs_get_kind(
      _context,
      _desc,
      context._createSymbol(key),
    );
    if (kind == Z3_param_kind.PK_BOOL) {
      return Z3ParamKind.bool;
    } else if (kind == Z3_param_kind.PK_DOUBLE) {
      return Z3ParamKind.double;
    } else if (kind == Z3_param_kind.PK_INVALID) {
      return Z3ParamKind.invalid;
    } else if (kind == Z3_param_kind.PK_OTHER) {
      return Z3ParamKind.other;
    } else if (kind == Z3_param_kind.PK_STRING) {
      return Z3ParamKind.string;
    } else if (kind == Z3_param_kind.PK_SYMBOL) {
      return Z3ParamKind.symbol;
    } else if (kind == Z3_param_kind.PK_UINT) {
      return Z3ParamKind.uint;
    } else {
      throw AssertionError('Unknown param kind: $kind');
    }
  }

  String getDocumentation(Z3_symbol key) => z3
      .param_descrs_get_documentation(_context, _desc, key)
      .cast<Utf8>()
      .toDartString();

  late final List<Sym> allKeys = () {
    final count = z3.param_descrs_size(_context, _desc);
    final result = <Sym>[];
    for (var i = 0; i < count; i++) {
      final symbol = z3.param_descrs_get_name(_context, _desc, i);
      result.add(context._getSymbol(symbol));
    }
    return result;
  }();

  @override
  String toString() =>
      z3.param_descrs_to_string(_context, _desc).cast<Utf8>().toDartString();
}

class ExternalParameter {
  const ExternalParameter._();
}

typedef Parameter
    = /* int | double | Rat | Z3Symbol | Sort | AST | FuncDecl | ExternalParameter */ Object;

abstract class AST {
  Z3_ast build(Context c);
}

abstract class Expr extends AST {}

class App extends Expr {
  App(this.decl, this.args);

  final FuncDecl decl;
  final List<Expr> args;

  @override
  Z3_ast build(Context c) {
    final argsPtr = malloc<Z3_ast>(args.length);
    for (var i = 0; i < args.length; i++) {
      argsPtr[i] = c._createAST(args[i]);
    }
    final result = z3.mk_app(
      c._context,
      c._createFuncDecl(decl),
      args.length,
      argsPtr,
    );
    malloc.free(argsPtr);
    return result.cast();
  }
}

class Pat extends Expr {
  Pat(this.terms);

  final List<AST> terms;

  @override
  Z3_ast build(Context c) {
    final termsPtr = malloc<Z3_ast>(terms.length);
    for (var i = 0; i < terms.length; i++) {
      termsPtr[i] = c._createAST(terms[i]);
    }
    final result = z3.mk_pattern(c._context, terms.length, termsPtr);
    malloc.free(termsPtr);
    return result.cast();
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
  fpaRtz,
}

class NullaryOp extends Expr {
  NullaryOp(this.kind);

  final NullaryOpKind kind;

  @override
  Z3_ast build(Context c) {
    switch (kind) {
      case NullaryOpKind.trueExpr:
        return z3.mk_true(c._context);
      case NullaryOpKind.falseExpr:
        return z3.mk_false(c._context);
      case NullaryOpKind.fpaRne:
        return z3.mk_fpa_rne(c._context);
      case NullaryOpKind.fpaRna:
        return z3.mk_fpa_rna(c._context);
      case NullaryOpKind.fpaRtp:
        return z3.mk_fpa_rtp(c._context);
      case NullaryOpKind.fpaRtn:
        return z3.mk_fpa_rtn(c._context);
      case NullaryOpKind.fpaRtz:
        return z3.mk_fpa_rtz(c._context);
    }
  }
}

enum UnaryOpKind {
  // Logic
  not,

  // Arithmetic
  unaryMinus,
  int2real,
  real2int,
  isInt,

  // Bit Vectors
  bvNot,
  bvRedAnd,
  bvRedOr,
  bvNeg,
  bvNegNoOverflow,

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
  fpaGetNumeralSignBv,
  fpaGetNumeralSignificandBv,
  fpaToIeeeBv,
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
        return z3.mk_not(c._context, a);
      case UnaryOpKind.unaryMinus:
        return z3.mk_unary_minus(c._context, a);
      case UnaryOpKind.int2real:
        return z3.mk_int2real(c._context, a);
      case UnaryOpKind.real2int:
        return z3.mk_real2int(c._context, a);
      case UnaryOpKind.isInt:
        return z3.mk_is_int(c._context, a);
      case UnaryOpKind.bvNot:
        return z3.mk_bvnot(c._context, a);
      case UnaryOpKind.bvRedAnd:
        return z3.mk_bvredand(c._context, a);
      case UnaryOpKind.bvRedOr:
        return z3.mk_bvredor(c._context, a);
      case UnaryOpKind.bvNeg:
        return z3.mk_bvneg(c._context, a);
      case UnaryOpKind.bvNegNoOverflow:
        return z3.mk_bvneg_no_overflow(c._context, a);
      case UnaryOpKind.arrayDefault:
        return z3.mk_array_default(c._context, a);
      case UnaryOpKind.setComplement:
        return z3.mk_set_complement(c._context, a);
      case UnaryOpKind.seqUnit:
        return z3.mk_seq_unit(c._context, a);
      case UnaryOpKind.seqLength:
        return z3.mk_seq_length(c._context, a);
      case UnaryOpKind.strToInt:
        return z3.mk_str_to_int(c._context, a);
      case UnaryOpKind.intToStr:
        return z3.mk_int_to_str(c._context, a);
      case UnaryOpKind.strToCode:
        return z3.mk_string_to_code(c._context, a);
      case UnaryOpKind.codeToStr:
        return z3.mk_string_from_code(c._context, a);
      case UnaryOpKind.ubvToStr:
        return z3.mk_ubv_to_str(c._context, a);
      case UnaryOpKind.sbvToStr:
        return z3.mk_sbv_to_str(c._context, a);
      case UnaryOpKind.seqToRe:
        return z3.mk_seq_to_re(c._context, a);
      case UnaryOpKind.rePlus:
        return z3.mk_re_plus(c._context, a);
      case UnaryOpKind.reStar:
        return z3.mk_re_star(c._context, a);
      case UnaryOpKind.reOption:
        return z3.mk_re_option(c._context, a);
      case UnaryOpKind.reComplement:
        return z3.mk_re_complement(c._context, a);
      case UnaryOpKind.charToInt:
        return z3.mk_char_to_int(c._context, a);
      case UnaryOpKind.charToBv:
        return z3.mk_char_to_int(c._context, a);
      case UnaryOpKind.bvToChar:
        return z3.mk_char_from_bv(c._context, a);
      case UnaryOpKind.charIsDigit:
        return z3.mk_char_is_digit(c._context, a);
      case UnaryOpKind.fpaAbs:
        return z3.mk_fpa_abs(c._context, a);
      case UnaryOpKind.fpaNeg:
        return z3.mk_fpa_neg(c._context, a);
      case UnaryOpKind.fpaIsNormal:
        return z3.mk_fpa_is_normal(c._context, a);
      case UnaryOpKind.fpaIsSubnormal:
        return z3.mk_fpa_is_subnormal(c._context, a);
      case UnaryOpKind.fpaIsZero:
        return z3.mk_fpa_is_zero(c._context, a);
      case UnaryOpKind.fpaIsInfinite:
        return z3.mk_fpa_is_infinite(c._context, a);
      case UnaryOpKind.fpaIsNaN:
        return z3.mk_fpa_is_nan(c._context, a);
      case UnaryOpKind.fpaIsNegative:
        return z3.mk_fpa_is_negative(c._context, a);
      case UnaryOpKind.fpaIsPositive:
        return z3.mk_fpa_is_positive(c._context, a);
      case UnaryOpKind.fpaToReal:
        return z3.mk_fpa_to_real(c._context, a);
      case UnaryOpKind.fpaGetNumeralSignBv:
        return z3.fpa_get_numeral_sign_bv(c._context, a);
      case UnaryOpKind.fpaGetNumeralSignificandBv:
        return z3.fpa_get_numeral_significand_bv(c._context, a);
      case UnaryOpKind.fpaToIeeeBv:
        return z3.mk_fpa_to_ieee_bv(c._context, a);
    }
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
  reIntersect,
}

class NaryOp extends Expr {
  NaryOp(this.kind, this.args);

  final NaryOpKind kind;
  final List<Expr> args;

  @override
  Z3_ast build(Context c) {
    final argsPtr = malloc<Z3_ast>(args.length);
    for (var i = 0; i < args.length; i++) {
      argsPtr[i] = c._createAST(args[i]);
    }
    final Z3_ast result;
    switch (kind) {
      case NaryOpKind.distinct:
        result = z3.mk_distinct(c._context, args.length, argsPtr);
      case NaryOpKind.and:
        result = z3.mk_and(c._context, args.length, argsPtr);
      case NaryOpKind.or:
        result = z3.mk_or(c._context, args.length, argsPtr);
      case NaryOpKind.add:
        result = z3.mk_add(c._context, args.length, argsPtr);
      case NaryOpKind.mul:
        result = z3.mk_mul(c._context, args.length, argsPtr);
      case NaryOpKind.sub:
        result = z3.mk_sub(c._context, args.length, argsPtr);
      case NaryOpKind.setUnion:
        result = z3.mk_set_union(c._context, args.length, argsPtr);
      case NaryOpKind.setIntersect:
        result = z3.mk_set_intersect(c._context, args.length, argsPtr);
      case NaryOpKind.seqConcat:
        result = z3.mk_seq_concat(c._context, args.length, argsPtr);
      case NaryOpKind.reUnion:
        result = z3.mk_re_union(c._context, args.length, argsPtr);
      case NaryOpKind.reConcat:
        result = z3.mk_re_concat(c._context, args.length, argsPtr);
      case NaryOpKind.reIntersect:
        result = z3.mk_re_intersect(c._context, args.length, argsPtr);
    }
    malloc.free(argsPtr);
    return result;
  }
}

enum BinaryOpKind {
  // Logic
  eq,
  iff,
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
  divides,

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
  bvAddNoUnderflow,
  bvSubNoOverflow,
  bvSdivNoOverflow,
  bvMulNoUnderflow,

  // Arrays
  select,
  setHasSize,

  // Sets
  setAdd,
  setDel,
  setDifference,
  setMember,
  setSubset,
  arrayExt,

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
  fpaEq,
}

class BinaryOp extends Expr {
  BinaryOp(this.kind, this.arg0, this.arg1);

  final BinaryOpKind kind;
  final AST arg0;
  final AST arg1;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    switch (kind) {
      case BinaryOpKind.eq:
        return z3.mk_eq(c._context, a, b);
      case BinaryOpKind.iff:
        return z3.mk_iff(c._context, a, b);
      case BinaryOpKind.implies:
        return z3.mk_implies(c._context, a, b);
      case BinaryOpKind.xor:
        return z3.mk_xor(c._context, a, b);
      case BinaryOpKind.div:
        return z3.mk_div(c._context, a, b);
      case BinaryOpKind.mod:
        return z3.mk_mod(c._context, a, b);
      case BinaryOpKind.rem:
        return z3.mk_rem(c._context, a, b);
      case BinaryOpKind.pow:
        return z3.mk_power(c._context, a, b);
      case BinaryOpKind.lt:
        return z3.mk_lt(c._context, a, b);
      case BinaryOpKind.le:
        return z3.mk_le(c._context, a, b);
      case BinaryOpKind.gt:
        return z3.mk_gt(c._context, a, b);
      case BinaryOpKind.ge:
        return z3.mk_ge(c._context, a, b);
      case BinaryOpKind.divides:
        return z3.mk_divides(c._context, a, b);
      case BinaryOpKind.bvAnd:
        return z3.mk_bvand(c._context, a, b);
      case BinaryOpKind.bvOr:
        return z3.mk_bvor(c._context, a, b);
      case BinaryOpKind.bvXor:
        return z3.mk_bvxor(c._context, a, b);
      case BinaryOpKind.bvNand:
        return z3.mk_bvnand(c._context, a, b);
      case BinaryOpKind.bvNor:
        return z3.mk_bvnor(c._context, a, b);
      case BinaryOpKind.bvXnor:
        return z3.mk_bvxnor(c._context, a, b);
      case BinaryOpKind.bvAdd:
        return z3.mk_bvadd(c._context, a, b);
      case BinaryOpKind.bvSub:
        return z3.mk_bvsub(c._context, a, b);
      case BinaryOpKind.bvMul:
        return z3.mk_bvmul(c._context, a, b);
      case BinaryOpKind.bvUdiv:
        return z3.mk_bvudiv(c._context, a, b);
      case BinaryOpKind.bvSdiv:
        return z3.mk_bvsdiv(c._context, a, b);
      case BinaryOpKind.bvUrem:
        return z3.mk_bvurem(c._context, a, b);
      case BinaryOpKind.bvSrem:
        return z3.mk_bvsrem(c._context, a, b);
      case BinaryOpKind.bvSmod:
        return z3.mk_bvsmod(c._context, a, b);
      case BinaryOpKind.bvUlt:
        return z3.mk_bvult(c._context, a, b);
      case BinaryOpKind.bvSlt:
        return z3.mk_bvslt(c._context, a, b);
      case BinaryOpKind.bvUle:
        return z3.mk_bvule(c._context, a, b);
      case BinaryOpKind.bvSle:
        return z3.mk_bvsle(c._context, a, b);
      case BinaryOpKind.bvUge:
        return z3.mk_bvuge(c._context, a, b);
      case BinaryOpKind.bvSge:
        return z3.mk_bvsge(c._context, a, b);
      case BinaryOpKind.bvUgt:
        return z3.mk_bvugt(c._context, a, b);
      case BinaryOpKind.bvSgt:
        return z3.mk_bvsgt(c._context, a, b);
      case BinaryOpKind.bvConcat:
        return z3.mk_concat(c._context, a, b);
      case BinaryOpKind.bvShl:
        return z3.mk_bvshl(c._context, a, b);
      case BinaryOpKind.bvLshr:
        return z3.mk_bvlshr(c._context, a, b);
      case BinaryOpKind.bvAshr:
        return z3.mk_bvashr(c._context, a, b);
      case BinaryOpKind.bvRotl:
        return z3.mk_ext_rotate_left(c._context, a, b);
      case BinaryOpKind.bvRotr:
        return z3.mk_ext_rotate_right(c._context, a, b);
      case BinaryOpKind.bvAddNoUnderflow:
        return z3.mk_bvadd_no_underflow(c._context, a, b);
      case BinaryOpKind.bvSubNoOverflow:
        return z3.mk_bvsub_no_overflow(c._context, a, b);
      case BinaryOpKind.bvSdivNoOverflow:
        return z3.mk_bvsdiv_no_overflow(c._context, a, b);
      case BinaryOpKind.bvMulNoUnderflow:
        return z3.mk_bvmul_no_underflow(c._context, a, b);
      case BinaryOpKind.select:
        return z3.mk_select(c._context, a, b);
      case BinaryOpKind.setHasSize:
        return z3.mk_set_has_size(c._context, a, b);
      case BinaryOpKind.setAdd:
        return z3.mk_set_add(c._context, a, b);
      case BinaryOpKind.setDel:
        return z3.mk_set_del(c._context, a, b);
      case BinaryOpKind.setDifference:
        return z3.mk_set_difference(c._context, a, b);
      case BinaryOpKind.setMember:
        return z3.mk_set_member(c._context, a, b);
      case BinaryOpKind.setSubset:
        return z3.mk_set_subset(c._context, a, b);
      case BinaryOpKind.arrayExt:
        return z3.mk_array_ext(c._context, a, b);
      case BinaryOpKind.seqPrefix:
        return z3.mk_seq_prefix(c._context, a, b);
      case BinaryOpKind.seqSuffix:
        return z3.mk_seq_suffix(c._context, a, b);
      case BinaryOpKind.seqContains:
        return z3.mk_seq_contains(c._context, a, b);
      case BinaryOpKind.strLt:
        return z3.mk_str_lt(c._context, a, b);
      case BinaryOpKind.strLe:
        return z3.mk_str_le(c._context, a, b);
      case BinaryOpKind.seqAt:
        return z3.mk_seq_at(c._context, a, b);
      case BinaryOpKind.seqNth:
        return z3.mk_seq_nth(c._context, a, b);
      case BinaryOpKind.seqLastIndex:
        return z3.mk_seq_last_index(c._context, a, b);
      case BinaryOpKind.seqInRe:
        return z3.mk_seq_in_re(c._context, a, b);
      case BinaryOpKind.reRange:
        return z3.mk_re_range(c._context, a, b);
      case BinaryOpKind.reDiff:
        return z3.mk_re_diff(c._context, a, b);
      case BinaryOpKind.charLe:
        return z3.mk_char_le(c._context, a, b);
      case BinaryOpKind.fpaSqrt:
        return z3.mk_fpa_sqrt(c._context, a, b);
      case BinaryOpKind.fpaRem:
        return z3.mk_fpa_rem(c._context, a, b);
      case BinaryOpKind.fpaMin:
        return z3.mk_fpa_min(c._context, a, b);
      case BinaryOpKind.fpaMax:
        return z3.mk_fpa_max(c._context, a, b);
      case BinaryOpKind.fpaLeq:
        return z3.mk_fpa_leq(c._context, a, b);
      case BinaryOpKind.fpaLt:
        return z3.mk_fpa_lt(c._context, a, b);
      case BinaryOpKind.fpaGeq:
        return z3.mk_fpa_geq(c._context, a, b);
      case BinaryOpKind.fpaGt:
        return z3.mk_fpa_gt(c._context, a, b);
      case BinaryOpKind.fpaEq:
        return z3.mk_fpa_eq(c._context, a, b);
    }
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
  fpaDiv,
}

class TernaryOp extends Expr {
  TernaryOp(this.kind, this.arg0, this.arg1, this.arg2);

  final TernaryOpKind kind;
  final AST arg0;
  final AST arg1;
  final AST arg2;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    final d = c._createAST(arg2);
    switch (kind) {
      case TernaryOpKind.ite:
        return z3.mk_ite(c._context, a, b, d);
      case TernaryOpKind.store:
        return z3.mk_store(c._context, a, b, d);
      case TernaryOpKind.seqExtract:
        return z3.mk_seq_extract(c._context, a, b, d);
      case TernaryOpKind.seqReplace:
        return z3.mk_seq_replace(c._context, a, b, d);
      case TernaryOpKind.seqIndex:
        return z3.mk_seq_index(c._context, a, b, d);
      case TernaryOpKind.fpaFp:
        return z3.mk_fpa_fp(c._context, a, b, d);
      case TernaryOpKind.fpaAdd:
        return z3.mk_fpa_add(c._context, a, b, d);
      case TernaryOpKind.fpaSub:
        return z3.mk_fpa_sub(c._context, a, b, d);
      case TernaryOpKind.fpaMul:
        return z3.mk_fpa_mul(c._context, a, b, d);
      case TernaryOpKind.fpaDiv:
        return z3.mk_fpa_div(c._context, a, b, d);
    }
  }
}

enum QuaternaryOpKind {
  // Sequences
  fpaFma,
}

class QuaternaryOp extends Expr {
  QuaternaryOp(this.kind, this.arg0, this.arg1, this.arg2, this.arg3);

  final QuaternaryOpKind kind;
  final AST arg0;
  final AST arg1;
  final AST arg2;
  final AST arg3;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    final d = c._createAST(arg2);
    final e = c._createAST(arg3);
    switch (kind) {
      case QuaternaryOpKind.fpaFma:
        return z3.mk_fpa_fma(c._context, a, b, d, e);
    }
  }
}

class BvExtract extends Expr {
  BvExtract(this.arg, this.high, this.low);

  final AST arg;
  final int high;
  final int low;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return z3.mk_extract(c._context, high, low, a);
  }
}

class BvSignExtend extends Expr {
  BvSignExtend(this.arg, this.size);

  final AST arg;
  final int size;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return z3.mk_sign_ext(c._context, size, a);
  }
}

class BvZeroExtend extends Expr {
  BvZeroExtend(this.arg, this.size);

  final AST arg;
  final int size;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return z3.mk_zero_ext(c._context, size, a);
  }
}

class BvRepeat extends Expr {
  BvRepeat(this.arg, this.count);

  final AST arg;
  final int count;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return z3.mk_repeat(c._context, count, a);
  }
}

class BvRotateLeft extends Expr {
  BvRotateLeft(this.arg, this.count);

  final AST arg;
  final int count;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return z3.mk_rotate_left(c._context, count, a);
  }
}

class BvRotateRight extends Expr {
  BvRotateRight(this.arg, this.count);

  final AST arg;
  final int count;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return z3.mk_rotate_right(c._context, count, a);
  }
}

class Bv2Int extends Expr {
  Bv2Int(this.arg, this.isSigned);

  final AST arg;
  final bool isSigned;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg);
    return z3.mk_bv2int(c._context, a, isSigned);
  }
}

class BvAddNoOverflow extends Expr {
  BvAddNoOverflow(this.arg0, this.arg1, this.isSigned);

  final AST arg0;
  final AST arg1;
  final bool isSigned;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    return z3.mk_bvadd_no_overflow(c._context, a, b, isSigned);
  }
}

class BvSubNoUnderflow extends Expr {
  BvSubNoUnderflow(this.arg0, this.arg1, this.isSigned);

  final AST arg0;
  final AST arg1;
  final bool isSigned;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    return z3.mk_bvsub_no_underflow(c._context, a, b, isSigned);
  }
}

class BvMulNoOverflow extends Expr {
  BvMulNoOverflow(this.arg0, this.arg1, this.isSigned);

  final AST arg0;
  final AST arg1;
  final bool isSigned;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(arg0);
    final b = c._createAST(arg1);
    return z3.mk_bvmul_no_overflow(c._context, a, b, isSigned);
  }
}

class ArraySelect extends Expr {
  ArraySelect(this.array, this.indices);

  final AST array;
  final List<AST> indices;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(array);
    final indicesPtr = malloc<Z3_ast>(indices.length);
    for (var i = 0; i < indices.length; i++) {
      indicesPtr[i] = c._createAST(indices[i]);
    }
    final result = z3.mk_select_n(c._context, a, indices.length, indicesPtr);
    malloc.free(indicesPtr);
    return result;
  }
}

class ArrayStore extends Expr {
  ArrayStore(this.array, this.indices, this.value);

  final AST array;
  final List<AST> indices;
  final AST value;

  @override
  Z3_ast build(Context c) {
    final a = c._createAST(array);
    final indicesPtr = malloc<Z3_ast>(indices.length);
    for (var i = 0; i < indices.length; i++) {
      indicesPtr[i] = c._createAST(indices[i]);
    }
    final result = z3.mk_store_n(
      c._context,
      a,
      indices.length,
      indicesPtr,
      c._createAST(value),
    );
    malloc.free(indicesPtr);
    return result;
  }
}

class ArrayMap extends Expr {
  ArrayMap(this.mapFn, this.arrays);

  final FuncDecl mapFn;
  final List<AST> arrays;

  @override
  Z3_ast build(Context c) {
    final a = c._createFuncDecl(mapFn);
    final arraysPtr = malloc<Z3_ast>(arrays.length);
    for (var i = 0; i < arrays.length; i++) {
      arraysPtr[i] = c._createAST(arrays[i]);
    }
    final result = z3.mk_map(c._context, a, arrays.length, arraysPtr);
    malloc.free(arraysPtr);
    return result;
  }
}

class AsArray extends Expr {
  AsArray(this.func);

  final FuncDecl func;

  @override
  Z3_ast build(Context c) =>
      z3.mk_as_array(c._context, c._createFuncDecl(func));
}

class EmptySet extends Expr {
  EmptySet(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => z3.mk_empty_set(c._context, c._createSort(sort));
}

class FullSet extends Expr {
  FullSet(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => z3.mk_full_set(c._context, c._createSort(sort));
}

abstract class Numeral extends Expr {
  Numeral._(this._c, this._n, this.sort);

  final Context _c;
  final Z3_ast _n;
  final Sort sort;

  bool equals(Numeral other) => z3.algebraic_eq(_c._context, _n, other._n);
  bool notEquals(Numeral other) => z3.algebraic_neq(_c._context, _n, other._n);

  @override
  Z3_ast build(Context c) => _c._translateTo(c, this, _n);

  @override
  String toString() =>
      z3.ast_to_string(_c._context, _n).cast<Utf8>().toDartString();
}

abstract class AlgebraicNumeral extends Numeral {
  AlgebraicNumeral._(Context c, Z3_ast n, Sort s) : super._(c, n, s);

  bool get isPositive => z3.algebraic_is_pos(_c._context, _n);
  bool get isNegative => z3.algebraic_is_neg(_c._context, _n);
  int get sign => z3.algebraic_sign(_c._context, _n);

  Numeral operator +(Numeral other) =>
      _c._getNumeral(z3.algebraic_add(_c._context, _n, other._n));

  Numeral operator -(Numeral other) =>
      _c._getNumeral(z3.algebraic_sub(_c._context, _n, other._n));

  Numeral operator *(Numeral other) =>
      _c._getNumeral(z3.algebraic_mul(_c._context, _n, other._n));

  Numeral operator /(Numeral other) =>
      _c._getNumeral(z3.algebraic_div(_c._context, _n, other._n));

  Numeral root(int k) => _c._getNumeral(z3.algebraic_root(_c._context, _n, k));

  Numeral pow(int k) => _c._getNumeral(z3.algebraic_power(_c._context, _n, k));

  bool operator >(Numeral other) => z3.algebraic_gt(_c._context, _n, other._n);
  bool operator >=(Numeral other) => z3.algebraic_ge(_c._context, _n, other._n);
  bool operator <(Numeral other) => z3.algebraic_lt(_c._context, _n, other._n);
  bool operator <=(Numeral other) => z3.algebraic_le(_c._context, _n, other._n);
}

class IntNumeral extends AlgebraicNumeral {
  IntNumeral._(Context c, Z3_ast n, IntSort s, this.value) : super._(c, n, s);

  factory IntNumeral(BigInt value, Sort sort) {
    if (value.isValidInt) {
      final ast = z3.mk_int64(
        _mathContext._context,
        value.toInt(),
        _mathContext._createSort(sort),
      );
      return _mathContext._getAST(ast) as IntNumeral;
    }
    final valuePtr = '$value'.toNativeUtf8();
    final ast = z3.mk_numeral(
      _mathContext._context,
      valuePtr.cast(),
      _mathContext._createSort(sort),
    );
    malloc.free(valuePtr);
    return _mathContext._getAST(ast) as IntNumeral;
  }

  @override
  IntSort get sort => super.sort as IntSort;

  final BigInt value;
}

class RatNumeral extends AlgebraicNumeral {
  RatNumeral._(Context c, Z3_ast n, Sort s, this.value) : super._(c, n, s);

  factory RatNumeral(Rat value, Sort sort) {
    if (value.n.isValidInt && value.d.isValidInt) {
      final ast = z3.mk_int64(
        _mathContext._context,
        value.n.toInt(),
        _mathContext._createSort(sort),
      );
      return _mathContext._getAST(ast) as RatNumeral;
    }
    final valuePtr = '$value'.toNativeUtf8();
    final ast = z3.mk_numeral(
      _mathContext._context,
      valuePtr.cast(),
      _mathContext._createSort(sort),
    );
    malloc.free(valuePtr);
    return _mathContext._getAST(ast) as RatNumeral;
  }

  final Rat value;
}

class IrratNumeral extends AlgebraicNumeral {
  IrratNumeral._(Context c, Z3_ast n, Sort s) : super._(c, n, s);

  List<Numeral> getCoefficients() {
    final result = z3.algebraic_get_poly(_c._context, _n);
    return _c._unpackAstVector(result).cast<Numeral>();
  }

  int evalPolySign(List<Numeral> vs) {
    final vsPtr = malloc<Z3_ast>(vs.length);
    for (var i = 0; i < vs.length; i++) {
      vsPtr[i] = vs[i]._n;
    }
    final result = z3.algebraic_eval(_c._context, _n, vs.length, vsPtr);
    malloc.free(vsPtr);
    return result;
  }

  int getRoot() => z3.algebraic_get_i(_c._context, _n);
}

class FloatNumeral extends AlgebraicNumeral {
  FloatNumeral._(
    Context c,
    Z3_ast n,
    FloatSort s,
    this.value,
  ) : super._(c, n, s);

  factory FloatNumeral(double value, FloatSort sort) {
    final n = z3.mk_fpa_numeral_double(
      _mathContext._context,
      value,
      _mathContext._createSort(sort),
    );
    return _mathContext._getAST(n) as FloatNumeral;
  }

  @override
  FloatSort get sort => super.sort as FloatSort;
  final double value;

  bool get isNaN => z3.fpa_is_numeral_nan(_c._context, _n);
  bool get isInf => z3.fpa_is_numeral_inf(_c._context, _n);
  bool get isZero => z3.fpa_is_numeral_zero(_c._context, _n);
  bool get isNormal => z3.fpa_is_numeral_normal(_c._context, _n);
  bool get isSubnormal => z3.fpa_is_numeral_subnormal(_c._context, _n);

  @override
  bool get isPositive => z3.fpa_is_numeral_positive(_c._context, _n);

  @override
  bool get isNegative => z3.fpa_is_numeral_negative(_c._context, _n);

  @override
  int get sign {
    final resultPtr = malloc<Int>();
    final success = z3.fpa_get_numeral_sign(_c._context, _n, resultPtr);
    assert(success);
    return resultPtr.value;
  }

  late final BigInt? significand = () {
    if (isNaN) return null;
    final resultPtr = malloc<Uint64>();
    final result = z3.fpa_get_numeral_significand_uint64(
      _c._context,
      _n,
      resultPtr,
    );
    if (!result) return null;
    final resultValue = BigInt.from(resultPtr.value);
    malloc.free(resultPtr);
    return resultValue < BigInt.zero ? -resultValue : resultValue;
  }();

  @override
  String toString() => '$value';
}

abstract class Quantifier extends Expr {}

class Lambda extends Quantifier {
  Lambda(this.args, this.body);

  factory Lambda.constBind(
    List<Expr> bound,
    AST body,
  ) {
    final boundPtr = malloc<Z3_app>(bound.length);
    for (var i = 0; i < bound.length; i++) {
      boundPtr[i] = _mathContext._createAST(bound[i]).cast();
    }
    final result = z3.mk_lambda_const(
      _mathContext._context,
      bound.length,
      boundPtr,
      _mathContext._createAST(body),
    );
    malloc.free(boundPtr);
    return _mathContext._getAST(result) as Lambda;
  }

  final Map<Sym, Sort> args;
  final Expr body;

  @override
  Z3_ast build(Context c) {
    final namesPtr = malloc<Z3_symbol>(args.length);
    final sortsPtr = malloc<Z3_sort>(args.length);
    var i = 0;
    for (final MapEntry(:key, :value) in args.entries) {
      namesPtr[i] = c._createSymbol(key);
      sortsPtr[i] = c._createSort(value);
      i++;
    }
    final result = z3.mk_lambda(
      c._context,
      args.length,
      sortsPtr,
      namesPtr,
      c._createAST(body),
    );
    malloc.free(namesPtr);
    malloc.free(sortsPtr);
    return result;
  }
}

class Exists extends Quantifier {
  Exists(
    this.patterns,
    this.args,
    this.body, {
    this.weight = 0,
    this.noPatterns = const [],
    this.id,
    this.skolem,
  });

  factory Exists.constBind(
    List<Expr> bound,
    List<Pat> patterns,
    AST body, {
    int weight = 0,
    Sym? id,
    Sym? skolem,
    List<AST> noPatterns = const [],
  }) {
    final boundPtr = malloc<Z3_app>(bound.length);
    for (var i = 0; i < bound.length; i++) {
      boundPtr[i] = _mathContext._createAST(bound[i]).cast();
    }
    final patternsPtr = malloc<Z3_pattern>(patterns.length);
    for (var i = 0; i < patterns.length; i++) {
      patternsPtr[i] = _mathContext._createPattern(patterns[i]);
    }
    final noPatternsPtr = malloc<Z3_ast>(noPatterns.length);
    for (var i = 0; i < noPatterns.length; i++) {
      noPatternsPtr[i] = _mathContext._createAST(noPatterns[i]);
    }
    final result = z3.mk_quantifier_const_ex(
      _mathContext._context,
      false,
      weight,
      _mathContext._createSymbol(id),
      _mathContext._createSymbol(skolem),
      bound.length,
      boundPtr,
      patterns.length,
      patternsPtr,
      noPatterns.length,
      noPatternsPtr,
      _mathContext._createAST(body),
    );
    malloc.free(boundPtr);
    malloc.free(patternsPtr);
    malloc.free(noPatternsPtr);
    return _mathContext._getAST(result) as Exists;
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
    final patternsPtr = malloc<Z3_pattern>(patterns.length);
    for (var i = 0; i < patterns.length; i++) {
      patternsPtr[i] = c._createPattern(patterns[i]);
    }
    final noPatternsPtr = malloc<Z3_ast>(noPatterns.length);
    for (var i = 0; i < noPatterns.length; i++) {
      noPatternsPtr[i] = c._createAST(noPatterns[i]);
    }
    final namesPtr = malloc<Z3_symbol>(args.length);
    final sortsPtr = malloc<Z3_sort>(args.length);
    var i = 0;
    for (final MapEntry(:key, :value) in args.entries) {
      namesPtr[i] = c._createSymbol(key);
      sortsPtr[i] = c._createSort(value);
      i++;
    }
    final result = z3.mk_quantifier_ex(
      c._context,
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
    malloc.free(patternsPtr);
    malloc.free(noPatternsPtr);
    malloc.free(namesPtr);
    malloc.free(sortsPtr);
    return result;
  }
}

class Forall extends Quantifier {
  Forall(
    this.patterns,
    this.args,
    this.body, {
    this.weight = 0,
    this.noPatterns = const [],
    this.id,
    this.skolem,
  });

  factory Forall.constBind(
    List<Expr> bound,
    List<Pat> patterns,
    AST body, {
    int weight = 0,
    Sym? id,
    Sym? skolem,
    List<AST> noPatterns = const [],
  }) {
    final boundPtr = malloc<Z3_app>(bound.length);
    for (var i = 0; i < bound.length; i++) {
      boundPtr[i] = _mathContext._createAST(bound[i]).cast();
    }
    final patternsPtr = malloc<Z3_pattern>(patterns.length);
    for (var i = 0; i < patterns.length; i++) {
      patternsPtr[i] = _mathContext._createPattern(patterns[i]);
    }
    final noPatternsPtr = malloc<Z3_ast>(noPatterns.length);
    for (var i = 0; i < noPatterns.length; i++) {
      noPatternsPtr[i] = _mathContext._createAST(noPatterns[i]);
    }
    final result = z3.mk_quantifier_const_ex(
      _mathContext._context,
      true,
      weight,
      _mathContext._createSymbol(id),
      _mathContext._createSymbol(skolem),
      bound.length,
      boundPtr,
      patterns.length,
      patternsPtr,
      noPatterns.length,
      noPatternsPtr,
      _mathContext._createAST(body),
    );
    malloc.free(boundPtr);
    malloc.free(patternsPtr);
    malloc.free(noPatternsPtr);
    return _mathContext._getAST(result) as Forall;
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
    final patternsPtr = malloc<Z3_pattern>(patterns.length);
    for (var i = 0; i < patterns.length; i++) {
      patternsPtr[i] = c._createPattern(patterns[i]);
    }
    final noPatternsPtr = malloc<Z3_ast>(noPatterns.length);
    for (var i = 0; i < noPatterns.length; i++) {
      noPatternsPtr[i] = c._createAST(noPatterns[i]);
    }
    final namesPtr = malloc<Z3_symbol>(args.length);
    final sortsPtr = malloc<Z3_sort>(args.length);
    var i = 0;
    for (final MapEntry(:key, :value) in args.entries) {
      namesPtr[i] = c._createSymbol(key);
      sortsPtr[i] = c._createSort(value);
      i++;
    }
    final result = z3.mk_quantifier_ex(
      c._context,
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
    malloc.free(patternsPtr);
    malloc.free(noPatternsPtr);
    malloc.free(namesPtr);
    malloc.free(sortsPtr);
    return result;
  }
}

class BoundVar extends Expr {
  BoundVar(this.index, this.sort);

  final int index;
  final Sort sort;

  @override
  Z3_ast build(Context c) =>
      z3.mk_bound(c._context, index, c._createSort(sort));
}

class Const extends Expr {
  Const(this.name, this.sort);

  final Sym name;
  final Sort sort;

  @override
  Z3_ast build(Context c) =>
      z3.mk_const(c._context, c._createSymbol(name), c._createSort(sort));
}

class ConstArray extends Expr {
  ConstArray(this.sort, this.value);

  final Sort sort;
  final AST value;

  @override
  Z3_ast build(Context c) =>
      z3.mk_const_array(c._context, c._createSort(sort), c._createAST(value));
}

class Str extends Expr {
  Str(this.value);

  final String value;

  @override
  Z3_ast build(Context c) {
    final runes = value.runes;
    switch (c.config.encoding) {
      case CharEncoding.ascii:
        final buffer = malloc<ffi.Char>(runes.length);
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
        final result = z3.mk_lstring(c._context, value.length, buffer);
        malloc.free(buffer);
        return result;
      case CharEncoding.bmp:
        final buffer = malloc<UnsignedInt>(runes.length);
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
        final result = z3.mk_u32string(c._context, runes.length, buffer);
        malloc.free(buffer);
        return result;
      case CharEncoding.unicode:
        final buffer = malloc<UnsignedInt>(runes.length);
        for (var i = 0; i < runes.length; i++) {
          buffer[i] = runes.elementAt(i);
        }
        final result = z3.mk_u32string(c._context, runes.length, buffer);
        malloc.free(buffer);
        return result;
    }
  }
}

class EmptySeq extends Expr {
  EmptySeq(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => z3.mk_seq_empty(c._context, c._createSort(sort));
}

class UnitSeq extends Expr {
  UnitSeq(this.value);

  final AST value;

  @override
  Z3_ast build(Context c) => z3.mk_seq_unit(c._context, c._createAST(value));
}

class ReAllchar extends Expr {
  ReAllchar(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => z3.mk_re_allchar(c._context, c._createSort(sort));
}

class ReLoop extends Expr {
  ReLoop(this.expr, this.low, this.high);

  final AST expr;
  final int low;
  final int high;

  @override
  Z3_ast build(Context c) =>
      z3.mk_re_loop(c._context, c._createAST(expr), low, high);
}

class RePower extends Expr {
  RePower(this.expr, this.n);

  final AST expr;
  final int n;

  @override
  Z3_ast build(Context c) => z3.mk_re_power(c._context, c._createAST(expr), n);
}

class ReEmpty extends Expr {
  ReEmpty(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => z3.mk_re_empty(c._context, c._createSort(sort));
}

class ReFull extends Expr {
  ReFull(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => z3.mk_re_full(c._context, c._createSort(sort));
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
        return z3.mk_char(c._context, value);
      case CharEncoding.unicode:
    }
    return z3.mk_char(c._context, value);
  }
}

class AtMost extends Expr {
  AtMost(this.args, this.k);

  final List<AST> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = malloc<Z3_ast>(args.length);
    for (var i = 0; i < args.length; i++) {
      argsPtr[i] = c._createAST(args[i]);
    }
    final result = z3.mk_atmost(c._context, args.length, argsPtr, k);
    malloc.free(argsPtr);
    return result;
  }
}

class AtLeast extends Expr {
  AtLeast(this.args, this.k);

  final List<AST> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = malloc<Z3_ast>(args.length);
    for (var i = 0; i < args.length; i++) {
      argsPtr[i] = c._createAST(args[i]);
    }
    final result = z3.mk_atleast(c._context, args.length, argsPtr, k);
    malloc.free(argsPtr);
    return result;
  }
}

class PBLE extends Expr {
  PBLE(this.args, this.k);

  final Map<AST, int> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = malloc<Z3_ast>(args.length);
    final coeffsPtr = malloc<Int>(args.length);
    var i = 0;
    for (final MapEntry(:key, :value) in args.entries) {
      argsPtr[i] = c._createAST(key);
      coeffsPtr[i] = value;
    }
    final result = z3.mk_pble(
      c._context,
      args.length,
      argsPtr,
      coeffsPtr,
      k,
    );
    malloc.free(argsPtr);
    malloc.free(coeffsPtr);
    return result;
  }
}

class PBGE extends Expr {
  PBGE(this.args, this.k);

  final Map<AST, int> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = malloc<Z3_ast>(args.length);
    final coeffsPtr = malloc<Int>(args.length);
    var i = 0;
    for (final MapEntry(:key, :value) in args.entries) {
      argsPtr[i] = c._createAST(key);
      coeffsPtr[i] = value;
    }
    final result = z3.mk_pbge(
      c._context,
      args.length,
      argsPtr,
      coeffsPtr,
      k,
    );
    malloc.free(argsPtr);
    malloc.free(coeffsPtr);
    return result;
  }
}

class PBEQ extends Expr {
  PBEQ(this.args, this.k);

  final Map<AST, int> args;
  final int k;

  @override
  Z3_ast build(Context c) {
    final argsPtr = malloc<Z3_ast>(args.length);
    final coeffsPtr = malloc<Int>(args.length);
    var i = 0;
    for (final MapEntry(:key, :value) in args.entries) {
      argsPtr[i] = c._createAST(key);
      coeffsPtr[i] = value;
    }
    final result = z3.mk_pbeq(
      c._context,
      args.length,
      argsPtr,
      coeffsPtr,
      k,
    );
    malloc.free(argsPtr);
    malloc.free(coeffsPtr);
    return result;
  }
}

class FpaNan extends Expr {
  FpaNan(this.sort);

  final Sort sort;

  @override
  Z3_ast build(Context c) => z3.mk_fpa_nan(c._context, c._createSort(sort));
}

class FpaInf extends Expr {
  FpaInf(this.sort, {this.neg = false});

  final Sort sort;
  final bool neg;

  @override
  Z3_ast build(Context c) =>
      z3.mk_fpa_inf(c._context, c._createSort(sort), neg);
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
      z3.mk_uninterpreted_sort(c._context, c._createSymbol(name));
}

class BoolSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._boolSort;
}

class IntSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._intSort;
}

class RealSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._realSort;
}

class StringSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._stringSort;
}

class CharSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._charSort;
}

class FpaRoundingModeSort extends Sort {
  @override
  Z3_sort buildSort(Context c) => c._fpaRoundingModeSort;
}

class BitVecSort extends IntSort {
  BitVecSort(this.size);

  final int size;

  @override
  Z3_sort buildSort(Context c) => z3.mk_bv_sort(c._context, size);
}

class FiniteDomainSort extends Sort {
  FiniteDomainSort(this.name, this.size);

  final Sym name;
  final int size;

  @override
  Z3_sort buildSort(Context c) =>
      z3.mk_finite_domain_sort(c._context, c._createSymbol(name), size);
}

class ArraySort extends Sort {
  ArraySort(this.domains, this.range) : assert(domains.isNotEmpty);

  final List<Sort> domains;
  final Sort range;

  @override
  Z3_sort buildSort(Context c) {
    if (domains.length == 1) {
      return z3.mk_array_sort(
        c._context,
        c._createSort(domains.single),
        c._createSort(range),
      );
    } else {
      final indicesPtr = malloc<Z3_sort>(domains.length);
      try {
        for (var i = 0; i < domains.length; i++) {
          indicesPtr[i] = c._createSort(domains[i]);
        }
        return z3.mk_array_sort_n(
          c._context,
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
  Z3_sort buildSort(Context c) =>
      z3.mk_set_sort(c._context, c._createSort(domain));
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
    final fieldNamesPtr = malloc<Z3_symbol>(fields.length);
    final sortsPtr = malloc<Z3_sort>(fields.length);
    final sortRefsPtr = malloc<UnsignedInt>(fields.length);
    var i = 0;
    for (final MapEntry(:key, :value) in fields.entries) {
      fieldNamesPtr[i] = c._createSymbol(key);
      if (value is IndexRefSort) {
        sortsPtr[i] = nullptr;
        sortRefsPtr[i] = value.index;
      } else {
        sortsPtr[i] = value.buildSort(c);
        sortRefsPtr[i] = 0;
      }
      i++;
    }
    final result = z3.mk_constructor(
      c._context,
      c._createSymbol(name),
      c._createSymbol(recognizer),
      fields.length,
      fieldNamesPtr,
      sortsPtr,
      sortRefsPtr,
    );
    malloc.free(fieldNamesPtr);
    malloc.free(sortsPtr);
    malloc.free(sortRefsPtr);
    return result;
  }
}

class DatatypeSort extends Sort {
  DatatypeSort(this.name, this.constructors);

  final Sym name;
  final List<Constructor> constructors;

  @override
  Z3_sort buildSort(Context c) {
    final constructorPtr = malloc<Z3_constructor>(constructors.length);
    for (var i = 0; i < constructors.length; i++) {
      constructorPtr[i] = constructors[i].buildConstructor(c);
    }
    final result = z3.mk_datatype(
      c._context,
      c._createSymbol(name),
      constructors.length,
      constructorPtr,
    );
    for (var i = 0; i < constructors.length; i++) {
      z3.del_constructor(c._context, constructorPtr[i]);
    }
    malloc.free(constructorPtr);
    return result;
  }
}

class ForwardRefSort extends Sort {
  ForwardRefSort(this.name);

  final Sym name;

  @override
  Z3_sort buildSort(Context c) =>
      z3.mk_uninterpreted_sort(c._context, c._createSymbol(name));
}

class SeqSort extends Sort {
  SeqSort(this.domain);

  final Sort domain;

  @override
  Z3_sort buildSort(Context c) =>
      z3.mk_seq_sort(c._context, c._createSort(domain));
}

class ReSort extends Sort {
  ReSort(this.seq);

  final SeqSort seq;

  @override
  Z3_sort buildSort(Context c) => z3.mk_re_sort(c._context, c._createSort(seq));
}

class FloatSort extends Sort {
  FloatSort._(this.ebits, this.sbits);
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

  final int ebits;
  final int sbits;
  late final int ebias = 1 << (ebits - 1) - 1;

  @override
  Z3_sort buildSort(Context c) => z3.mk_fpa_sort(c._context, ebits, sbits);
}

class Float16Sort extends FloatSort {
  Float16Sort() : super._(5, 11);
}

class Float32Sort extends FloatSort {
  Float32Sort() : super._(8, 24);
}

class Float64Sort extends FloatSort {
  Float64Sort() : super._(11, 53);
}

class Float128Sort extends FloatSort {
  Float128Sort() : super._(15, 113);
}

abstract class FuncDecl extends Decl {
  Z3_func_decl buildFuncDecl(Context c);

  @override
  Z3_ast build(Context c) => z3.func_decl_to_ast(
        c._context,
        buildFuncDecl(c),
      );
}

class InterpretedFunc extends FuncDecl {
  InterpretedFunc._(
    this._c,
    this._f,
    this.name,
    this.parameters,
    this.domain,
    this.range,
  );

  final Context _c;
  final Z3_func_decl _f;

  final Sym name;
  final List<Parameter> parameters;
  final List<Sort> domain;
  final Sort range;

  @override
  Z3_func_decl buildFuncDecl(Context c) =>
      _c._translateTo(c, this, _f.cast()).cast();
}

class Func extends FuncDecl {
  Func(this.name, this.domain, this.range, {this.recursive = false});

  final Sym name;
  final List<Sort> domain;
  final Sort range;
  final bool recursive;

  @override
  Z3_func_decl buildFuncDecl(Context c) {
    final domainPtr = malloc<Z3_sort>(domain.length);
    for (var i = 0; i < domain.length; i++) {
      domainPtr[i] = domain[i].buildSort(c);
    }
    final result = (recursive ? z3.mk_rec_func_decl : z3.mk_func_decl)(
      c._context,
      c._createSymbol(name),
      domain.length,
      domainPtr,
      range.buildSort(c),
    );
    malloc.free(domainPtr);
    return result;
  }
}

class LinearOrder extends FuncDecl {
  LinearOrder(this.domain, this.id);

  final Sort domain;
  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => z3.mk_linear_order(
        c._context,
        c._createSort(domain),
        id,
      );
}

class PartialOrder extends FuncDecl {
  PartialOrder(this.domain, this.id);

  final Sort domain;
  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => z3.mk_partial_order(
        c._context,
        c._createSort(domain),
        id,
      );
}

class PiecewiseLinearOrder extends FuncDecl {
  PiecewiseLinearOrder(this.domain, this.id);

  final Sort domain;
  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => z3.mk_piecewise_linear_order(
        c._context,
        c._createSort(domain),
        id,
      );
}

class TreeOrder extends FuncDecl {
  TreeOrder(this.domain, this.id);

  final Sort domain;
  final int id;

  @override
  Z3_func_decl buildFuncDecl(Context c) => z3.mk_tree_order(
        c._context,
        c._createSort(domain),
        id,
      );
}

class TransitiveClosure extends FuncDecl {
  TransitiveClosure(this.relation);

  final FuncDecl relation;

  @override
  Z3_func_decl buildFuncDecl(Context c) => z3.mk_transitive_closure(
        c._context,
        relation.buildFuncDecl(c),
      );
}

class Unknown extends AST {
  Unknown._(this._c, this._ast);

  final Context _c;
  final Z3_ast _ast;

  @override
  Z3_ast build(Context c) => _c._translateTo(c, this, _ast);
}
