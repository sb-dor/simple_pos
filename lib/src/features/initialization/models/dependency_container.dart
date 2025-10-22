import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/error_reporter/error_reporter.dart';
import 'package:test_pos_app/src/common/utils/key_value_storage/shared_preferences_service.dart';
import 'package:test_pos_app/src/common/utils/paginate_list_helper.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/cashier_feature/bloc/cashier_feature_bloc.dart';
import 'package:test_pos_app/src/features/categories/bloc/categories_bloc.dart';
import 'package:test_pos_app/src/features/initialization/models/app_config.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';
import 'package:test_pos_app/src/features/order_tables/bloc/order_tables_bloc.dart';
import 'package:test_pos_app/src/features/synchronization/bloc/synchronization_bloc.dart';
import 'package:test_pos_app/src/features/tables/bloc/tables_bloc.dart';

class DependencyContainer {
  //
  DependencyContainer({required this.logger, required this.errorReporter});

  final Logger logger;

  final ErrorReporter errorReporter;

  late final AppDatabase appDatabase;

  late final SharedPreferencesService sharedPreferencesService;

  late final AuthenticationBloc authenticationBloc;

  late final OrderTablesBloc orderTablesBloc;

  late final OrderFeatureBloc orderFeatureBloc;

  late final CashierFeatureBloc cashierFeatureBloc;

  late final TablesBloc tablesBloc;

  late final CategoriesBloc categoriesBloc;

  late final SynchronizationBloc synchronizationBloc;

  late final PaginateListHelper paginateListHelper;

  late final AppConfig appConfig;
}

@visibleForTesting
final class TestDependencyContainer implements DependencyContainer {
  @override
  noSuchMethod(Invocation invocation) {
    // ... implement noSuchMethod
    throw UnimplementedError();
  }
}
