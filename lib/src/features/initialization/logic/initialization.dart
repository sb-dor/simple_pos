import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:test_pos_app/src/common/utils/app_zone.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/error_reporter.dart';
import 'package:test_pos_app/src/common/utils/error_util/error_util.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';
import 'package:test_pos_app/src/features/initialization/models/app_config.dart';
import 'package:test_pos_app/src/features/initialization/widgets/material_context.dart';

const String _imageLibraryResourceService = 'image resource service';
const String _connectionClosedBeforeFullHWR = 'Connection closed before full header was received';
const String _cannotCloneDisposedImage = 'Cannot clone a disposed image';

Future<void> $initializeApp() async {
  //
  late final WidgetsBinding binding;

  const appConfig = AppConfig();

  final ErrorReporter errorReporter = SentryErrorReporter(
    sentryDsn: appConfig.sentryDsn,
    environment: appConfig.environment.value,
  );

  final stopwatch = Stopwatch()..start();
  appZone(() async {
    try {
      binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

      await errorReporter.initialize();

      await _catchExceptions();

      final dependencies = await $initializeDependencies();

      runApp(MaterialContext(dependencyContainer: dependencies));
    } on Object {
      rethrow;
    } finally {
      stopwatch.stop();
      binding.allowFirstFrame();
    }
  });
}

Future<void> _catchExceptions() async {
  try {
    PlatformDispatcher.instance.onError = (error, stack) {
      ErrorUtil.logError(error, stack);
      return true;
    };

    FlutterError.onError = (errorDetails) {
      final exceptionStr = errorDetails.exception.toString();
      final library = errorDetails.library ?? '';

      l.e(
        'library: $library | \nFlutter error: $exceptionStr \nException: $errorDetails',
        errorDetails.stack,
      );

      // error is from cachedImageNetwork (if there is no internet connection or very slow internet connection)
      if (library == _imageLibraryResourceService &&
          exceptionStr.contains(_connectionClosedBeforeFullHWR)) {
        return;
      }

      // Ignore "clone disposed image" errors
      if (library == _imageLibraryResourceService &&
          exceptionStr.contains(_cannotCloneDisposedImage)) {
        return;
      }

      ErrorUtil.logError(errorDetails.exception, errorDetails.stack ?? StackTrace.current);
    };
  } on Object catch (error, stackTrace) {
    l.e('Error while catching exceptions: $error', stackTrace);
  }
}
