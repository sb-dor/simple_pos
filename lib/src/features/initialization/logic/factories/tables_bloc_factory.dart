import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_pos_app/src/features/tables/bloc/tables_bloc.dart';
import 'package:test_pos_app/src/features/tables/data/tables_datasource.dart';
import 'package:test_pos_app/src/features/tables/data/tables_repository.dart';

final class TablesBlocFactory extends Factory<TablesBloc> {
  TablesBlocFactory({required final AppDatabase appDatabase, required final Logger logger})
    : _appDatabase = appDatabase,
      _logger = logger;

  final AppDatabase _appDatabase;
  final Logger _logger;

  @override
  TablesBloc create() {
    final ITablesDatasource datasource = TablesDatasourceImpl(
      orderTableDbTableHelper: OrderTableDbTableHelper(_appDatabase, _logger),
    );

    final ITablesRepository repository = TablesRepositoryImpl(datasource);

    return TablesBloc(repository: repository);
  }
}
