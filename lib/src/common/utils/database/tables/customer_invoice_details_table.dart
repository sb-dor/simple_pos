import 'package:drift/drift.dart';
import 'package:test_pos_app/src/common/utils/database/tables/customer_invoices_table.dart';

class CustomerInvoiceDetailsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get customerInvoiceId => integer().nullable().references(CustomerInvoicesTable, #id)();

  IntColumn get productId => integer().nullable()();

  RealColumn get price => real().nullable()();

  RealColumn get qty => real().nullable()();

  RealColumn get total => real().nullable()();

  @override
  String? get tableName => "customer_invoices_details";
}
