// import 'package:logger/logger.dart';
// import 'package:test_pos_app/src/common/utils/database/app_database.dart';
// import 'package:test_pos_app/src/common/utils/key_value_storage/shared_preferences_service.dart';
// import 'package:test_pos_app/src/common/utils/paginate_list_helper.dart';
// import 'package:test_pos_app/src/features/initialization/logic/factories/authentication_bloc_factory.dart';
// import 'package:test_pos_app/src/features/initialization/logic/factories/cashier_bloc_factory.dart';
// import 'package:test_pos_app/src/features/initialization/logic/factories/order_bloc_factory.dart';
// import 'package:test_pos_app/src/features/initialization/logic/factories/order_tables_bloc_factory.dart';
// import 'package:test_pos_app/src/features/initialization/logic/factories/tables_bloc_factory.dart';
// import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';
//
// final class DependencyComposition extends AsyncFactory<DependencyContainer> {
//   DependencyComposition({
//     required final AppDatabase appDatabase,
//     required final SharedPreferencesService sharedPreferencesService,
//     required final Logger logger,
//   }) : _appDatabase = appDatabase,
//        _sharedPreferencesService = sharedPreferencesService,
//
//        _logger = logger;
//
//   final AppDatabase _appDatabase;
//   final Logger _logger;
//   final SharedPreferencesService _sharedPreferencesService;
//
//   @override
//   Future<DependencyContainer> create() async {
//     final paginateListHelper = PaginateListHelper();
//
//     final authenticationBloc =
//         AuthenticationBlocFactory(
//           logger: _logger,
//           sharedPreferencesService: _sharedPreferencesService,
//           appDatabase: _appDatabase,
//         ).create();
//
//     final orderTablesBloc =
//         OrderTablesBlocFactory(logger: _logger, appDatabase: _appDatabase).create();
//
//     final orderFeatureBloc = OrderBlocFactory(appDatabase: _appDatabase, logger: _logger).create();
//
//     final cashierFeatureBloc =
//         CashierBlocFactory(
//           appDatabase: _appDatabase,
//           logger: _logger,
//           paginatingListHelper: paginateListHelper,
//         ).create();
//
//     final tablesBloc = TablesBlocFactory(appDatabase: _appDatabase, logger: _logger).create();
//
//     return DependencyContainer(
//       appDatabase: _appDatabase,
//       authenticationBloc: authenticationBloc,
//       orderTablesBloc: orderTablesBloc,
//       orderFeatureBloc: orderFeatureBloc,
//       cashierFeatureBloc: cashierFeatureBloc,
//       tablesBloc: tablesBloc,
//       logger: _logger,
//       paginateListHelper: paginateListHelper,
//     );
//   }
// }
//
abstract class AsyncFactory<T> {
  Future<T> create();
}

abstract class Factory<T> {
  T create();
}
