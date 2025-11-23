import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l/l.dart';

import 'package:test_pos_app/src/common/utils/error_reporter/error_reporter.dart';
import 'package:test_pos_app/src/common/utils/extensions/string_extensions.dart';

class BlocObserverManager extends BlocObserver {
  const BlocObserverManager({required final ErrorReporter errorReporter})
    : _errorReporter = errorReporter;

  final ErrorReporter _errorReporter;

  @override
  void onTransition(Bloc<Object?, Object?> bloc, Transition<Object?, Object?> transition) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${transition.event.runtimeType}')
      ..writeln(
        'Transition: ${transition.currentState.runtimeType} => '
        '${transition.nextState.runtimeType}',
      )
      ..write('New State: ${transition.nextState?.toString().limit(100)}');

    l.i(logMessage.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${event.runtimeType}')
      ..write('Details: ${event?.toString().limit(200)}');

    l.i(logMessage.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    final logMessage = StringBuffer()
      ..writeln('Error from bloc: ${bloc.runtimeType}')
      ..writeln(error.toString());

    // you can also send bloc errors to server here

    l.e(logMessage.toString(), stackTrace);

    if (kReleaseMode) {
      // send to the sever or firebase crashlytics (crashlytics does not work for web)
      if (!kIsWeb && !kIsWasm) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      }

      _errorReporter.captureException(error: error, stackTrace: stackTrace);
    }

    // Avoid calling super.onError to prevent propagation
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    final logMessage = StringBuffer()..writeln('Closed Bloc: ${bloc.runtimeType}');

    l.i(logMessage.toString());
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    final logMessage = StringBuffer()..writeln('Opened Bloc: ${bloc.runtimeType}');

    l.i(logMessage.toString());
    super.onCreate(bloc);
  }
}
