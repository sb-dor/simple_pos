import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/error_reporter.dart';

class SentryErrorReporter implements ErrorReporter {
  SentryErrorReporter({required this.sentryDsn, required this.environment});

  final String sentryDsn;

  final String environment;

  @override
  Future<void> captureException({required Object? error, required StackTrace stackTrace}) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> close() async {
    await Sentry.close();
  }

  @override
  Future<void> initialize() async {
    await SentryFlutter.init((options) {
      options.dsn = sentryDsn;
      options.sendDefaultPii = true;
      options.debug = kDebugMode;
      options.environment = environment;
      options.anrEnabled = true;
      options.tracesSampleRate = 0.10;
    });
  }

  @override
  bool get isInitialized => Sentry.isEnabled;
}
