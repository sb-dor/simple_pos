import 'package:test_pos_app/src/common/utils/app_zone.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/src/error_reporter.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/src/sentry_error_reporter.dart';
import 'package:test_pos_app/src/features/initialization/logic/initialization.dart';
import 'package:test_pos_app/src/features/initialization/models/app_config.dart';

void main() async {
  const appConfig = AppConfig();

  final ErrorReporter errorReporter = SentryErrorReporter(
    sentryDsn: appConfig.sentryDsn,
    environment: appConfig.environment.value,
  );

  await errorReporter.initialize();

  appZone(() => $initializeApp(appConfig, errorReporter));
}
