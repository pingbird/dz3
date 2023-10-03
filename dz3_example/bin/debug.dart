import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:file/local.dart';
import 'package:z3/z3.dart';

Future<void> initDebug({bool release = false}) async {
  final pkgUri = await Isolate.resolvePackageUri(Platform.script);
  const fs = LocalFileSystem();
  final lib = fs
      .file(pkgUri!)
      .parent
      .parent
      .parent
      .childDirectory('z3')
      .childDirectory(release ? 'cmake-build-release' : 'cmake-build-debug')
      .childFile(Platform.isWindows ? 'libz3.dll' : 'libz3.so');
  if (lib.existsSync()) {
    libz3Override = DynamicLibrary.open(lib.path);
  } else {
    libz3Override = DynamicLibrary.open('libz3');
  }
}
