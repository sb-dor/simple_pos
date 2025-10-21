import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';
import 'package:test_pos_app/src/features/initialization/models/app_config.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/error_reporter.dart';
import 'package:test_pos_app/src/features/initialization/widgets/io_material_context.dart';
import 'package:test_pos_app/src/features/initialization/widgets/web_material_context.dart';

import 'factories/app_logger_factory.dart';

const String _imageLibraryResourceService = "image resource service";
const String _connectionClosedBeforeFullHWR = "Connection closed before full header was received";
const String _cannotCloneDisposedImage = "Cannot clone a disposed image";

Future<void> $initializeApp() async {
  final appConfig = AppConfig();

  final logger = AppLoggerFactory(
    logFilter: kReleaseMode ? NoOpLogFilter() : DevelopmentFilter(),
  ).create();

  final ErrorReporter errorReporter = SentryErrorReporter(
    sentryDsn: appConfig.sentryDsn,
    environment: appConfig.environment.value,
  );

  await runZonedGuarded(
    () async {
      late final WidgetsBinding binding;
      final stopwatch = Stopwatch()..start();

      try {
        binding = WidgetsFlutterBinding.ensureInitialized();

        binding.deferFirstFrame();

        await errorReporter.initialize();

        await _catchExceptions(logger: logger, errorReporter: errorReporter);

        final dependencies = await $initializeDependencies(
          logger: logger,
          errorReporter: errorReporter,
        );

        late final Widget materialContext;

        if (kIsWeb || kIsWasm) {
          materialContext = WebMaterialContext(dependencyContainer: dependencies);
        } else {
          materialContext = IoMaterialContext(dependencyContainer: dependencies);
        }

        runApp(materialContext);
      } on Object {
        rethrow;
      } finally {
        stopwatch.stop();
        binding.allowFirstFrame();
      }
    },
    (error, stackTrace) {
      //
      logger.e("Error from zone", error: error, stackTrace: stackTrace);

      if (!kReleaseMode) {
        _errorMessage("Error occurred");
      }

      if (kReleaseMode) {
        // send to the sever or firebase crashlytics
        if (!kIsWeb && !kIsWasm) {
          FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
        }

        errorReporter.captureException(error: error, stackTrace: stackTrace);
      }
    },
  );
}

Future<void> _catchExceptions({
  required final Logger logger,
  required final ErrorReporter errorReporter,
}) async {
  try {
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.log(Level.error, "error: $error | stacktrace: $stack");

      if (kReleaseMode) {
        // send to the sever or firebase crashlytics (crashlytics does not work for web)
        if (!kIsWeb && !kIsWasm) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }

        errorReporter.captureException(error: error, stackTrace: stack);
      }
      return true;
    };

    FlutterError.onError = (errorDetails) {
      final exceptionStr = errorDetails.exception.toString();
      final library = errorDetails.library ?? '';

      logger.log(
        Level.error,
        "library: $library | \nFlutter error: $exceptionStr \nException: $errorDetails",
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

      // send error to Firebase crashlytics
      if (kReleaseMode) {
        // send to the sever or firebase crashlytics (crashlytics does not work for web)
        if (!kIsWeb && !kIsWasm) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        }

        errorReporter.captureException(
          error: errorDetails.exception,
          stackTrace: errorDetails.stack ?? StackTrace.current,
        );
      }
    };
  } on Object catch (error, stackTrace) {
    logger.e('Error while catching exceptions:', error: error, stackTrace: stackTrace);
  }
}

void _errorMessage(String message) {
  //
}
