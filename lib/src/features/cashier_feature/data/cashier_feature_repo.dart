import 'package:test_pos_app/src/features/cashier_feature/data/cashier_feature_data_source.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';

abstract interface class ICashierFeatureRepo {
  Future<List<CustomerInvoiceModel>> invoices();
}

class CashierFeatureRepoImpl implements ICashierFeatureRepo {
  final ICashierFeatureDataSource _cashierFeatureDataSource;

  CashierFeatureRepoImpl(this._cashierFeatureDataSource);

  @override
  Future<List<CustomerInvoiceModel>> invoices() => _cashierFeatureDataSource.invoices();
}
