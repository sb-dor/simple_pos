import 'package:drift/drift.dart'; // import for "&" or "|"
import 'package:l/l.dart';
import 'package:test_pos_app/src/common/constants/constants.dart';
import 'package:test_pos_app/src/common/global_data/global_data.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/extensions/order_item_extentions.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_detail_model.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';
import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

// in order to use "&" or "|" expression import drift.dart package
final class CustomerInvoiceDatabaseHelper {
  CustomerInvoiceDatabaseHelper(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<void> addProduct(TableModel? table, CustomerInvoiceDetailModel? item) async {
    final checkInvoiceForPlace =
        await (_appDatabase.select(_appDatabase.customerInvoicesTable)..where(
              (element) => element.tableId.equals(table?.id ?? '') & element.status.equals(pending),
            ))
            .get();

    int? customerInvoiceId;

    if (checkInvoiceForPlace.isEmpty) {
      customerInvoiceId = await _appDatabase
          .into(_appDatabase.customerInvoicesTable)
          .insert(
            CustomerInvoicesTableCompanion(
              waiterId: Value(currentWaiter.id),
              tableId: Value(table?.id),
              status: const Value(pending),
            ),
          );
    } else {
      customerInvoiceId = int.tryParse('${checkInvoiceForPlace.first.id}');
    }
    await _update(customerInvoiceId, item);
  }

  Future<void> _update(int? customerInvoiceId, CustomerInvoiceDetailModel? item) async {
    final checkItemsWithCurrentInvoice =
        await (_appDatabase.select(_appDatabase.customerInvoiceDetailsTable)..where(
              (element) =>
                  element.customerInvoiceId.equals(customerInvoiceId ?? 0) &
                  element.productId.equals(item?.product?.id ?? ''),
            ))
            .get();

    if (checkItemsWithCurrentInvoice.isEmpty) {
      if (item != null) {
        await _appDatabase
            .into(_appDatabase.customerInvoiceDetailsTable)
            .insert(item.toDbCompanion(customerInvoiceId));
      }
    } else {
      if (item != null) {
        if ((item.qty ?? 0.0) <= 0.0) {
          await (_appDatabase.delete(_appDatabase.customerInvoiceDetailsTable)..where(
                (element) =>
                    element.customerInvoiceId.equals(customerInvoiceId ?? 0) &
                    element.productId.equals(item.product?.id ?? ''),
              ))
              .go();

          // check if invoice doesn't have any data delete invoice
          checkInvoiceForEmptyDetails(customerInvoiceId ?? 0);
          return;
        }

        await (_appDatabase.update(_appDatabase.customerInvoiceDetailsTable)..where(
              (element) =>
                  element.customerInvoiceId.equals(customerInvoiceId ?? 0) &
                  element.productId.equals(item.product?.id ?? ''),
            ))
            .write(item.toDbCompanion(customerInvoiceId));
      }
    }
  }

  Future<void> deleteOrderItemFromOrder(OrderItemModel? orderItem, TableModel? table) async {
    final checkInvoiceForPlace =
        await (_appDatabase.select(_appDatabase.customerInvoicesTable)..where(
              (element) => element.tableId.equals(table?.id ?? '') & element.status.equals(pending),
            ))
            .get();

    if (checkInvoiceForPlace.isNotEmpty) {
      await (_appDatabase.delete(_appDatabase.customerInvoiceDetailsTable)..where(
            (element) =>
                element.customerInvoiceId.equals(checkInvoiceForPlace.first.id) &
                element.productId.equals(orderItem?.product?.id ?? ''),
          ))
          .go();

      checkInvoiceForEmptyDetails(int.parse('${checkInvoiceForPlace.first.id}'));
    }
  }

  // if invoice doesn't have any table remove whole invoice
  Future<void> checkInvoiceForEmptyDetails(int invoiceId) async {
    final checkInvoiceForPlace = await (_appDatabase.select(
      _appDatabase.customerInvoiceDetailsTable,
    )..where((element) => element.customerInvoiceId.equals(invoiceId))).get();

    if (checkInvoiceForPlace.isEmpty) {
      await (_appDatabase.delete(
        _appDatabase.customerInvoicesTable,
      )..where((element) => element.id.equals(invoiceId))).go();
    }
  }

  Future<bool> finishCustomerInvoice(TableModel? table, List<OrderItemModel> items) async {
    final currentDateTime = DateTime.now().toString().substring(0, 19);
    await (_appDatabase.update(_appDatabase.customerInvoicesTable)..where(
          (element) => element.tableId.equals(table?.id ?? '') & element.status.equals(pending),
        ))
        .write(
          CustomerInvoicesTableCompanion(
            status: const Value(null),
            total: Value(items.total()),
            totalQty: Value(items.totalQty()),
            invoiceDatetime: Value(currentDateTime),
          ),
        );

    return true;
  }

  Future<List<CustomerInvoiceDetailModel>> customerInvoiceDetails(TableModel? table) async {
    final invoice =
        await (_appDatabase.select(_appDatabase.customerInvoicesTable)..where(
              (element) => element.tableId.equals(table?.id ?? '') & element.status.isNotNull(),
            ))
            .get();

    if (invoice.isEmpty) return <CustomerInvoiceDetailModel>[];

    final customerInvoiceDetails = await (_appDatabase.select(
      _appDatabase.customerInvoiceDetailsTable,
    )..where((element) => element.customerInvoiceId.equals(invoice.first.id))).get();

    l.d(customerInvoiceDetails);

    return customerInvoiceDetails.map(CustomerInvoiceDetailModel.fromDb).toList();
  }

  Future<List<CustomerInvoiceModel>> customerInvoices() async {
    final details = (await _appDatabase.select(_appDatabase.customerInvoiceDetailsTable).get()).map(
      CustomerInvoiceDetailModel.fromDb,
    );

    final customerInvoices =
        await (_appDatabase.select(_appDatabase.customerInvoicesTable)
              ..where((element) => element.status.isNull())
              ..orderBy([(element) => OrderingTerm.desc(element.invoiceDatetime)]))
            .get();

    l.d(customerInvoices);

    final customerInvoicesList = <CustomerInvoiceModel>[];

    for (final each in customerInvoices) {
      final tableData = await (_appDatabase.select(
        _appDatabase.orderTableDbTable,
      )..where((element) => element.id.equals(each.tableId ?? ''))).getSingleOrNull();

      if (tableData == null) continue;
      customerInvoicesList.add(
        CustomerInvoiceModel.fromDb(
          each,
          details.where((e) => e.customerInvoiceId == each.id).toList(),
        ).copyWith(table: TableModel.fromDbTable(tableData)),
      );
    }

    return customerInvoicesList;
  }

  Future<void> clearAllCustomerInvoice() async {
    await _appDatabase.delete(_appDatabase.customerInvoiceDetailsTable).go();
    await _appDatabase.delete(_appDatabase.customerInvoicesTable).go();
  }
}
