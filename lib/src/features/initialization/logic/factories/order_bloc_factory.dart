import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/customer_invoices/customer_invoice_database_helper.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_repo.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_source.dart';

final class OrderBlocFactory extends Factory<OrderFeatureBloc> {
  OrderBlocFactory({required final AppDatabase appDatabase}) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  OrderFeatureBloc create() {
    final IOrderFeatureSource datasource = OrderFeatureSourceImpl(
      customerInvoiceDatabaseHelper: CustomerInvoiceDatabaseHelper(_appDatabase),
      orderTableDbTableHelper: OrderTableDbTableHelper(_appDatabase),
    );

    final IOrderFeatureRepo repo = OrderFeatureRepoImpl(datasource);

    return OrderFeatureBloc(repository: repo);
  }
}
