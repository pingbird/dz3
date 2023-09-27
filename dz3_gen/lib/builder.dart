import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'error_handler.dart';

Builder errorHandlerBuilder(BuilderOptions options) => LibraryBuilder(
      ErrorHandlerLibraryGenerator(),
      generatedExtension: '.e.dart',
    );
