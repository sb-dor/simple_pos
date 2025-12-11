// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:test_pos_app/src/common/constants/constants.dart';
// import 'package:test_pos_app/src/common/global_data/global_data.dart';
// import 'package:test_pos_app/src/common/utils/extensions/order_item_extentions.dart';
// import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_detail_model.dart';
// import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';
// import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';
// import 'package:test_pos_app/src/features/tables/models/table_model.dart';
//
// @Deprecated('No useful anymore')
// class LocalDatabaseService {
//   late final Database database;
//
//   static const String customerInvoiceTable = 'customer_invoices';
//   static const String customerInvoicesDetailsTable = 'customer_invoices_details';
//
//   Future<void> initDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final path = join(databasePath, 'test_pos_app.db');
//
//     database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await _createTables(db);
//       },
//       onUpgrade: (db, oldVersion, newVersion) async => await _createTables(db),
//     );
//   }
//
//   Future<void> _createTables(Database db) async {
//     await db.execute(
//       'CREATE TABLE IF NOT EXISTS $customerInvoiceTable (id INTEGER PRIMARY KEY AUTOINCREMENT, waiter_id INTEGER,'
//       ' place_id INTEGER, total REAL, total_qty REAL, status TEXT, invoice_datetime TEXT)',
//     );
//
//     await db.execute(
//       'CREATE TABLE IF NOT EXISTS $customerInvoicesDetailsTable (id INTEGER PRIMARY KEY AUTOINCREMENT, customer_invoice_id INTEGER,'
//       ' product_id INTEGER, price REAL, qty REAL, total REAL)',
//     );
//   }
//
//   Future<void> addProduct(TableModel? table, CustomerInvoiceDetailModel? item) async {
//     final checkInvoiceForPlace = await database.query(
//       customerInvoiceTable,
//       where: 'place_id = ? and status = ?',
//       whereArgs: [table?.id, pending],
//     );
//
//     int? customerInvoiceId;
//
//     if (checkInvoiceForPlace.isEmpty) {
//       customerInvoiceId = await database.insert(customerInvoiceTable, {
//         'waiter_id': currentWaiter.id,
//         'place_id': table?.id,
//         'status': pending,
//       });
//     } else {
//       customerInvoiceId = int.tryParse("${checkInvoiceForPlace.first['id']}");
//     }
//     await _update(customerInvoiceId, item);
//   }
//
//   Future<void> _update(int? customerInvoiceId, CustomerInvoiceDetailModel? item) async {
//     final checkItemsWithCurrentInvoice = await database.query(
//       customerInvoicesDetailsTable,
//       where: 'customer_invoice_id = ? and product_id = ?',
//       whereArgs: [customerInvoiceId, item?.product?.id],
//     );
//
//     if (checkItemsWithCurrentInvoice.isEmpty) {
//       await database.insert(customerInvoicesDetailsTable, item?.toDb(customerInvoiceId) ?? {});
//     } else {
//       if ((item?.qty ?? 0.0) <= 0.0) {
//         await database.delete(
//           customerInvoicesDetailsTable,
//           where: 'customer_invoice_id = ? and product_id = ?',
//           whereArgs: [customerInvoiceId, item?.product?.id],
//         );
//         // check if invoice doesn't have any data delete invoice
//         checkInvoiceForEmptyDetails(customerInvoiceId ?? 0);
//         return;
//       }
//       await database.update(
//         customerInvoicesDetailsTable,
//         item?.toDb(customerInvoiceId) ?? {},
//         where: 'customer_invoice_id = ? and product_id = ?',
//         whereArgs: [customerInvoiceId, item?.product?.id],
//       );
//     }
//   }
//
//   Future<void> deleteOrderItemFromOrder(OrderItemModel? orderItem, TableModel? table) async {
//     final checkInvoiceForPlace = await database.query(
//       customerInvoiceTable,
//       where: 'place_id = ? and status = ?',
//       whereArgs: [table?.id, pending],
//     );
//     if (checkInvoiceForPlace.isNotEmpty) {
//       await database.delete(
//         customerInvoicesDetailsTable,
//         where: 'customer_invoice_id = ? and product_id = ?',
//         whereArgs: [checkInvoiceForPlace.first['id'], orderItem?.product?.id],
//       );
//
//       checkInvoiceForEmptyDetails(int.parse("${checkInvoiceForPlace.first['id']}"));
//     }
//   }
//
//   // if invoice doesn't have any table remove whole invoice
//   Future<void> checkInvoiceForEmptyDetails(int invoiceId) async {
//     final checkInvoiceForPlace = await database.query(
//       customerInvoicesDetailsTable,
//       where: 'customer_invoice_id = ?',
//       whereArgs: [invoiceId],
//     );
//     if (checkInvoiceForPlace.isEmpty) {
//       await database.delete(customerInvoiceTable, where: 'id = ?', whereArgs: [invoiceId]);
//     }
//   }
//
//   Future<bool> finishCustomerInvoice(TableModel? table, List<OrderItemModel> items) async {
//     final currentDateTime = DateTime.now().toString().substring(0, 19);
//     await database.update(
//       customerInvoiceTable,
//       {
//         'status': null,
//         'total': items.total(),
//         'total_qty': items.totalQty(),
//         'invoice_datetime': currentDateTime,
//       },
//       where: 'place_id = ? and status = ?',
//       whereArgs: [table?.id, pending],
//     );
//
//     return true;
//   }
//
//   Future<List<CustomerInvoiceDetailModel>> customerInvoiceDetails(TableModel? table) async {
//     final invoice = await database.query(
//       customerInvoiceTable,
//       where: 'place_id = ? and status is not null',
//       whereArgs: [table?.id],
//     );
//
//     if (invoice.isEmpty) return <CustomerInvoiceDetailModel>[];
//
//     // return customerInvoiceDetails.map(CustomerInvoiceDetailModel.fromDb).toList();
//     return <CustomerInvoiceDetailModel>[];
//   }
//
//   Future<List<CustomerInvoiceModel>> customerInvoices() async {
//     return <CustomerInvoiceModel>[];
//     // final details =
//     //     (await database.query(
//     //       customerInvoicesDetailsTable,
//     //     )).map(CustomerInvoiceDetailModel.fromDb).toList();
//     //
//     // return (await database.query(
//     //       customerInvoiceTable,
//     //       where: "status is null",
//     //       orderBy: "invoice_datetime desc",
//     //     ))
//     //     .map(
//     //       (invoice) => CustomerInvoiceModel.fromDb(
//     //         invoice,
//     //         details.where((e) => e.customerInvoiceId == invoice['id']).toList(),
//     //       ),
//     //     )
//     //     .toList();
//   }
// }
