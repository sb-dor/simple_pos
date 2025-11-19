import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/customer_invoices/customer_invoice_database_helper.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_repo.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_source.dart';

final class OrderBlocFactory extends Factory<OrderFeatureBloc> {
  OrderBlocFactory({required final AppDatabase appDatabase, required final Logger logger})
    : _appDatabase = appDatabase,
      _logger = logger;

  final AppDatabase _appDatabase;
  final Logger _logger;

  @override
  OrderFeatureBloc create() {
    final IOrderFeatureSource datasource = OrderFeatureSourceImpl(
      customerInvoiceDatabaseHelper: CustomerInvoiceDatabaseHelper(_appDatabase, _logger),
      orderTableDbTableHelper: OrderTableDbTableHelper(_appDatabase),
    );

    final IOrderFeatureRepo repo = OrderFeatureRepoImpl(datasource);

    return OrderFeatureBloc(repository: repo);
  }
}
