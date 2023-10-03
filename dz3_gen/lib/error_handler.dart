import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Returns all [TopLevelVariableElement] members in [reader]'s library that
/// have a type of [num].
Iterable<TopLevelVariableElement> topLevelNumVariables(LibraryReader reader) =>
    reader.allElements.whereType<TopLevelVariableElement>().where(
          (element) =>
              element.type.isDartCoreNum ||
              element.type.isDartCoreInt ||
              element.type.isDartCoreDouble,
        );

class ErrorHandlerLibraryGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final zlibClass = library.findType('Z3Lib')!;

    final buffer = StringBuffer();
    buffer.writeln('import \'package:z3/z3_ffi.dart\';');
    buffer.writeln('import \'dart:ffi\';');
    buffer.writeln('// ignore_for_file: non_constant_identifier_names');

    buffer.writeln('class Z3LibWrapper {');
    buffer.writeln('  Z3LibWrapper(this.z3, this.context, this.checkError);');
    buffer.writeln('  final Z3Lib z3;');
    buffer.writeln('  final Z3_context context;');
    buffer.writeln('  final void Function() checkError;');

    String displayType(DartType type) {
      final result = type.getDisplayString(withNullability: true);
      return result.replaceAllMapped(
          RegExp('Pointer<_Z3_(.+?)>'), (match) => 'Z3_${match.group(1)}');
    }

    for (final method in zlibClass.methods) {
      if (method.parameters.isEmpty) continue;
      if (displayType(method.parameters.first.type) != 'Z3_context') continue;
      buffer.writeln('  ${displayType(method.returnType)} ${method.name}(');
      var i = 1;
      for (final parameter in method.parameters.skip(1)) {
        buffer.writeln('    ${displayType(parameter.type)} p$i,');
        i++;
      }
      buffer.writeln('  ) {');
      buffer.writeln('    final result = z3.${method.name}(');
      buffer.writeln('      context,');
      for (var i = 1; i < method.parameters.length; i++) {
        buffer.writeln('      p$i,');
      }
      buffer.writeln('    );');
      buffer.writeln('    checkError();');
      buffer.writeln('    return result;');
      buffer.writeln('  }');
    }

    buffer.writeln('}');

    return '$buffer';
  }
}
