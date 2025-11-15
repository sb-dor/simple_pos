
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_pos_app/src/features/table_creation/bloc/table_creation_bloc.dart';
import 'package:test_pos_app/src/features/table_creation/data/table_creation_datasource.dart';
import 'package:test_pos_app/src/features/table_creation/data/table_creation_repository.dart';

final class TableCreationBlocFactory extends Factory<TableCreationBloc> {
  TableCreationBlocFactory({required final AppDatabase appDatabase})
    : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  TableCreationBloc create() {
    final ITableCreationDatasource datasource = TableCreationDatasourceImpl(
      orderTableDbTableHelper: OrderTableDbTableHelper(_appDatabase),
    );

    final ITableCreationRepository repository = TableCreationRepositoryImpl(datasource);

    return TableCreationBloc(repository: repository);
  }
}
