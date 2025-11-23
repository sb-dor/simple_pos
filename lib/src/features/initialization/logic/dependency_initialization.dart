import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l/l.dart';

import 'package:test_pos_app/firebase_options.dart';
import 'package:test_pos_app/src/common/utils/bloc_observer/bloc_observer_manager.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/establishment_database_helper.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/error_reporter.dart';
import 'package:test_pos_app/src/common/utils/key_value_storage/shared_preferences_service.dart';
import 'package:test_pos_app/src/common/utils/paginate_list_helper.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/authentication_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/cashier_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/categories_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/order_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/order_tables_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/products_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/tables_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/platform/platform_initialization.dart';
import 'package:test_pos_app/src/features/initialization/models/app_config.dart';
import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';
import 'package:test_pos_app/src/features/synchronization/bloc/synchronization_bloc.dart';
import 'package:test_pos_app/src/features/synchronization/data/synchronization_datasource.dart';
import 'package:test_pos_app/src/features/synchronization/data/synchronization_repository.dart';

abstract class AsyncFactory<T> {
  Future<T> create();
}

abstract class Factory<T> {
  T create();
}

Future<DependencyContainer> $initializeDependencies({
  required final ErrorReporter errorReporter,
}) async {
  final dependenciesContainer = DependencyContainer(errorReporter: errorReporter);
  final totalSteps = _initializationSteps.length;
  var step = 0;
  for (final each in _initializationSteps.entries) {
    try {
      step++;
      final percent = (step / totalSteps).clamp(0, 100);
      l.i('Initialization | $step/$totalSteps (${percent.toStringAsFixed(2)}%) | "${each.key}"');
      // calling ....
      await each.value(dependenciesContainer);
    } on Object catch (error, stackTrace) {
      l.e('Initialization failed at step "${each.key}": $error', stackTrace);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
  return dependenciesContainer;
}

// ... this one
typedef _InitializationStep = FutureOr<void> Function(DependencyContainer dependencies);

final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  'Platform pre-initialization': (_) => $platformInitialization(),
  'Firebase init': (_) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // other firebase initializations
  },
  'Bloc Configuration init': (dependencies) {
    Bloc.transformer = sequential();
    Bloc.observer = BlocObserverManager(errorReporter: dependencies.errorReporter);
  },
  'Database init': (dependencies) {
    final appDatabase = AppDatabase.defaults(name: 'test_pos_app');
    dependencies.appDatabase = appDatabase;
  },
  'Shared Preferences init': (dependencies) async {
    final sharedPreferencesService = SharedPreferencesService();
    await sharedPreferencesService.init();
    dependencies.sharedPreferencesService = sharedPreferencesService;
  },
  'Paginate List Helper init': (dependencies) =>
      dependencies.paginateListHelper = PaginateListHelper(),
  //
  'App Config init': (dependencies) => dependencies.appConfig = const AppConfig(),
  //
  'Authentication Bloc init': (dependencies) =>
      dependencies.authenticationBloc = AuthenticationBlocFactory(
        sharedPreferencesService: dependencies.sharedPreferencesService,
        appDatabase: dependencies.appDatabase,
      ).create(),
  'Order Tables Bloc init': (dependencies) => dependencies.orderTablesBloc = OrderTablesBlocFactory(
    appDatabase: dependencies.appDatabase,
  ).create(),
  'Order bloc init': (dependencies) => dependencies.orderFeatureBloc = OrderBlocFactory(
    appDatabase: dependencies.appDatabase,
  ).create(),
  'Tables bloc init': (dependencies) =>
      dependencies.tablesBloc = TablesBlocFactory(appDatabase: dependencies.appDatabase).create(),
  'Categories bloc init': (dependencies) => dependencies.categoriesBloc = CategoriesBlocFactory(
    appDatabase: dependencies.appDatabase,
  ).create(),
  'Products bloc initl': (dependencies) {
    dependencies.productsBloc = ProductsBlocFactory(dependencies.appDatabase).create();
  },
  'Cashier bloc init': (dependencies) => dependencies.cashierFeatureBloc = CashierBlocFactory(
    appDatabase: dependencies.appDatabase,
    paginatingListHelper: dependencies.paginateListHelper,
  ).create(),
  'Synchronization bloc init': (dependencies) {
    final ISynchronizationDatasource synchronizationDatasource = SynchronizationDatasourceImpl(
      firebaseStore: FirebaseFirestore.instance,
      orderTableDbTableHelper: OrderTableDbTableHelper(dependencies.appDatabase),
      appDatabase: dependencies.appDatabase,
    );
    final ISynchronizationRepository synchronizationRepository = SynchronizationRepositoryImpl(
      establishmentDatabaseHelper: EstablishmentDatabaseHelper(dependencies.appDatabase),
      synchronizationDatasource: synchronizationDatasource,
    );
    final synchronizationBloc = SynchronizationBloc(
      iSynchronizationRepository: synchronizationRepository,
    );
    dependencies.synchronizationBloc = synchronizationBloc;
  },
};
