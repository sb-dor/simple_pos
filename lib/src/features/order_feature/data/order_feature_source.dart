import 'package:test_pos_app/src/common/global_data/global_data.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/customer_invoices/customer_invoice_database_helper.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_detail_model.dart';
import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

abstract class IOrderFeatureSource {
  Future<void> addToDb({required TableModel? table, required OrderItemModel? item});

  Future<bool> finishInvoice(TableModel? table, List<OrderItemModel> items);

  Future<List<OrderItemModel>> dbOrderItems(TableModel? table);

  Future<void> deleteOrderItemFromOrder(OrderItemModel? item, TableModel? table);

  Future<List<ProductModel>> categoriesProducts(CategoryModel category);

  Future<TableModel?> table(String id);
}

class OrderFeatureSourceImpl implements IOrderFeatureSource {
  OrderFeatureSourceImpl({
    required final CustomerInvoiceDatabaseHelper customerInvoiceDatabaseHelper,
    required final OrderTableDbTableHelper orderTableDbTableHelper,
  }) : _customerInvoiceDatabaseHelper = customerInvoiceDatabaseHelper,
       _orderTableDbTableHelper = orderTableDbTableHelper;

  final CustomerInvoiceDatabaseHelper _customerInvoiceDatabaseHelper;
  final OrderTableDbTableHelper _orderTableDbTableHelper;

  @override
  Future<void> addToDb({required TableModel? table, required OrderItemModel? item}) async {
    final customerInvoiceModel = CustomerInvoiceDetailModel.fromOrderItem(item);
    await _customerInvoiceDatabaseHelper.addProduct(table, customerInvoiceModel);
  }

  @override
  Future<bool> finishInvoice(TableModel? table, List<OrderItemModel> items) =>
      _customerInvoiceDatabaseHelper.finishCustomerInvoice(table, items);

  @override
  Future<List<OrderItemModel>> dbOrderItems(TableModel? table) async {
    final customerInvoicesDetails = await _customerInvoiceDatabaseHelper.customerInvoiceDetails(
      table,
    );
    return customerInvoicesDetails.map(OrderItemModel.fromCustomerInvoiceDetail).toList();
  }

  @override
  Future<void> deleteOrderItemFromOrder(OrderItemModel? item, TableModel? table) =>
      _customerInvoiceDatabaseHelper.deleteOrderItemFromOrder(item, table);

  @override
  Future<List<ProductModel>> categoriesProducts(CategoryModel category) async =>
      products.where((e) => e.category?.id == category.id).toList();

  @override
  Future<TableModel?> table(String id) => _orderTableDbTableHelper.table(id);
}
