import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract interface class ErrorReporter {
  bool get isInitialized;

  Future<void> initialize();

  Future<void> close();

  Future<void> captureException({required Object? error, required StackTrace stackTrace});
}

final class ErrorReporterWithLog {
  ErrorReporterWithLog({required final ErrorReporter reporter, required final Logger logger})
    : _reporter = reporter,
      _logger = logger;

  final ErrorReporter _reporter;
  final Logger _logger;

  void log({final Error? error, final StackTrace? stackTrace}) {
    if (!_reporter.isInitialized) return;

    _logger.log(Level.error, 'Error reporter:', error: error, stackTrace: stackTrace);

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
