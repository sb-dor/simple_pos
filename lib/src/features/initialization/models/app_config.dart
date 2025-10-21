import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/features/initialization/models/environment.dart';

class AppConfig {
  const AppConfig();

  Environment get environment {
    final mode = const String.fromEnvironment("MODE");
    switch (mode) {
      case "PRODUCTION":
        return Environment.prod;
      default:
        return Environment.dev;
    }
  }

  String get sentryDsn => const String.fromEnvironment("SENTRY_DSN");

  bool get enableSentry => sentryDsn.isNotEmpty;
}

@visibleForTesting
final class TestAppConfig extends AppConfig {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
