import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/customer_invoice_database_helper.dart';

abstract class ICashierFeatureDataSource {
  Future<List<CustomerInvoiceModel>> invoices();
}

class CashierFeatureDataSourceImpl implements ICashierFeatureDataSource {
  CashierFeatureDataSourceImpl({
    required final AppDatabase appDatabase,
    required final Logger logger,
  }) : _customerInvoiceDatabaseHelper = CustomerInvoiceDatabaseHelper(appDatabase, logger);

  final CustomerInvoiceDatabaseHelper _customerInvoiceDatabaseHelper;

  @override
  Future<List<CustomerInvoiceModel>> invoices() =>
      _customerInvoiceDatabaseHelper.customerInvoices();
}
