import 'package:drift/drift.dart';

class CustomerInvoicesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get waiterId => integer().nullable()();

  TextColumn get tableId => text().nullable()();

  RealColumn get total => real().nullable()();

  RealColumn get totalQty => real().nullable()();

  TextColumn get status => text().nullable()();

  TextColumn get invoiceDatetime => text().nullable()();

  @override
  String? get tableName => 'customer_invoices';
}
