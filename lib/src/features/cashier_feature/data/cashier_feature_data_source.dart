import 'package:test_pos_app/src/common/utils/database/database_helpers/customer_invoices/customer_invoice_database_helper.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';

abstract class ICashierFeatureDataSource {
  Future<List<CustomerInvoiceModel>> invoices();
}

class CashierFeatureDataSourceImpl implements ICashierFeatureDataSource {
  CashierFeatureDataSourceImpl({
    required final CustomerInvoiceDatabaseHelper customerInvoiceDatabaseHelper,
  }) : _customerInvoiceDatabaseHelper = customerInvoiceDatabaseHelper;

  final CustomerInvoiceDatabaseHelper _customerInvoiceDatabaseHelper;

  @override
  Future<List<CustomerInvoiceModel>> invoices() =>
      _customerInvoiceDatabaseHelper.customerInvoices();
}
