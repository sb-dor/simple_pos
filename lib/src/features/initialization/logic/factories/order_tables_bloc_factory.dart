
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_pos_app/src/features/order_tables/bloc/order_tables_bloc.dart';
import 'package:test_pos_app/src/features/order_tables/data/order_tables_datasource.dart';
import 'package:test_pos_app/src/features/order_tables/data/order_tables_repository.dart';

final class OrderTablesBlocFactory extends Factory<OrderTablesBloc> {
  OrderTablesBlocFactory({required final AppDatabase appDatabase})
    : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  OrderTablesBloc create() {
    final IOrderTablesDatasource datasource = OrderTablesDatasourceImpl(
      orderTableDbTableHelper: OrderTableDbTableHelper(_appDatabase),
    );

    final IOrderTablesRepository repository = OrderTablesRepositoryImpl(datasource);

    return OrderTablesBloc(repository: repository);
  }
}
