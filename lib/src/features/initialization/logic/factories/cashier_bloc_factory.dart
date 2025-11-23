
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/customer_invoices/customer_invoice_database_helper.dart';
import 'package:test_pos_app/src/common/utils/paginate_list_helper.dart';
import 'package:test_pos_app/src/features/cashier_feature/bloc/cashier_feature_bloc.dart';
import 'package:test_pos_app/src/features/cashier_feature/data/cashier_feature_data_source.dart';
import 'package:test_pos_app/src/features/cashier_feature/data/cashier_feature_repo.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';

final class CashierBlocFactory extends Factory<CashierFeatureBloc> {
  CashierBlocFactory({
    required final AppDatabase appDatabase,
    required final PaginateListHelper paginatingListHelper,
  }) : _appDatabase = appDatabase,
       _paginateListHelper = paginatingListHelper;

  final AppDatabase _appDatabase;
  final PaginateListHelper _paginateListHelper;

  @override
  CashierFeatureBloc create() {
    final ICashierFeatureDataSource datasource = CashierFeatureDataSourceImpl(
      customerInvoiceDatabaseHelper: CustomerInvoiceDatabaseHelper(_appDatabase),
    );

    final ICashierFeatureRepo repo = CashierFeatureRepoImpl(datasource);

    return CashierFeatureBloc(repository: repo, paginateListHelper: _paginateListHelper);
  }
}
