import 'package:flutter/foundation.dart';
import 'package:l/l.dart';


abstract interface class ErrorReporter {
  bool get isInitialized;

  Future<void> initialize();

  Future<void> close();

  Future<void> captureException({required Object? error, required StackTrace stackTrace});
}

final class ErrorReporterWithLog {
  ErrorReporterWithLog({required final ErrorReporter reporter})
    : _reporter = reporter;

  final ErrorReporter _reporter;

  void log({final Error? error, final StackTrace? stackTrace}) {
    if (!_reporter.isInitialized) return;

    l.e( 'Error reporter:', stackTrace);

    _reporter.captureException(
      error: error ?? const ReportMessageException('Error reporter log exception'),
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }
}

@immutable
final class ReportMessageException implements Exception {
  const ReportMessageException(this.message);

  final String message;

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportMessageException && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
