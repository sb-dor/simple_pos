import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/firebase_options.dart';
import 'package:test_pos_app/src/common/utils/bloc_observer/bloc_observer_manager.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/key_value_storage/shared_preferences_service.dart';
import 'package:test_pos_app/src/common/utils/paginate_list_helper.dart';
import 'package:test_pos_app/src/common/utils/reusable_functions.dart';
import 'package:test_pos_app/src/features/initialization/logic/desktop_initialization.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/cashier_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/order_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/order_tables_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/models/app_config.dart';
import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';
import 'package:test_pos_app/src/features/synchronization/bloc/synchronization_bloc.dart';
import 'package:test_pos_app/src/features/synchronization/data/synchronization_repository.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/error_reporter.dart';
import 'factories/authentication_bloc_factory.dart';
import 'factories/tables_bloc_factory.dart';

Future<DependencyContainer> $initializeDependencies({
  required final Logger logger,
  required final ErrorReporter errorReporter,
}) async {
  final dependenciesContainer = DependencyContainer(logger: logger, errorReporter: errorReporter);
  final totalSteps = _initializationSteps.length;
  int step = 0;
  for (final each in _initializationSteps.entries) {
    try {
      step++;
      final percent = (step / totalSteps).clamp(0, 100);
      logger.log(
        Level.info,
        'Initialization | $step/$totalSteps (${percent.toStringAsFixed(2)}%) | "${each.key}"',
      );
      // calling ....
      await each.value(dependenciesContainer);
    } catch (error, stackTrace) {
      logger.log(
        Level.info,
        'Initialization failed at step "${each.key}": $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
  return dependenciesContainer;
}

// ... this one
typedef _InitializationStep = FutureOr<void> Function(DependencyContainer dependencies);

final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  "Firebase init": (_) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // other firebase initializations
  },
  "Desktop init": (_) async {
    if (!foundation.kIsWeb && !foundation.kIsWasm && ReusableFunctions.instance.isDesktop) {
      await DesktopInitialization().run();
    }
  },
  "Bloc Configuration init": (dependencies) {
    Bloc.transformer = sequential();
    Bloc.observer = BlocObserverManager(
      logger: dependencies.logger,
      errorReporter: dependencies.errorReporter,
    );
  },
  "Database init": (dependencies) {
    final appDatabase = AppDatabase.defaults(name: 'test_pos_app');
    dependencies.appDatabase = appDatabase;
  },
  "Shared Preferences init": (dependencies) async {
    final sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.init();
    dependencies.sharedPreferencesService = sharedPreferencesService;
  },
  "Paginate List Helper init": (dependencies) =>
      dependencies.paginateListHelper = PaginateListHelper(),
  //
  "App Config init": (dependencies) => dependencies.appConfig = AppConfig(),
  //
  "Authentication Bloc init": (dependencies) =>
      dependencies.authenticationBloc = AuthenticationBlocFactory(
        logger: dependencies.logger,
        sharedPreferencesService: dependencies.sharedPreferencesService,
        appDatabase: dependencies.appDatabase,
      ).create(),
  "Order Tables Bloc init": (dependencies) => dependencies.orderTablesBloc = OrderTablesBlocFactory(
    appDatabase: dependencies.appDatabase,
    logger: dependencies.logger,
  ).create(),
  "Order bloc init": (dependencies) => dependencies.orderFeatureBloc = OrderBlocFactory(
    appDatabase: dependencies.appDatabase,
    logger: dependencies.logger,
  ).create(),
  "Tables bloc init": (dependencies) => dependencies.tablesBloc = TablesBlocFactory(
    appDatabase: dependencies.appDatabase,
    logger: dependencies.logger,
  ).create(),
  "Cashier bloc init": (dependencies) => dependencies.cashierFeatureBloc = CashierBlocFactory(
    appDatabase: dependencies.appDatabase,
    logger: dependencies.logger,
    paginatingListHelper: dependencies.paginateListHelper,
  ).create(),
  "Synchronization bloc init": (dependencies) {
    final ISynchronizationRepository synchronizationRepository = SynchronizationRepositoryImpl(
      firebaseStore: FirebaseFirestore.instance,
      appDatabase: dependencies.appDatabase,
      sharedPreferencesService: dependencies.sharedPreferencesService,
      logger: dependencies.logger,
    );
    final SynchronizationBloc synchronizationBloc = SynchronizationBloc(
      iSynchronizationRepository: synchronizationRepository,
    );
    dependencies.synchronizationBloc = synchronizationBloc;
  },
};
