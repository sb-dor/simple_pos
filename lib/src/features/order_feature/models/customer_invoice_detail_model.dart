import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/common/global_data/global_data.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

@immutable
class CustomerInvoiceDetailModel {
  const CustomerInvoiceDetailModel({
    this.id,
    this.customerInvoiceId,
    this.product,
    this.price,
    this.qty,
    this.total,
  });

  factory CustomerInvoiceDetailModel.fromDb(CustomerInvoiceDetailsTableData db) =>
      CustomerInvoiceDetailModel(
        id: db.id,
        customerInvoiceId: db.customerInvoiceId,
        product: products.firstWhereOrNull((e) => e.id == db.productId),
        price: db.price,
        qty: db.qty,
        total: db.total,
      );

  factory CustomerInvoiceDetailModel.fromOrderItem(OrderItemModel? item) =>
      CustomerInvoiceDetailModel(product: item?.product, price: item?.price, qty: item?.qty);

  final int? id;
  final int? customerInvoiceId;
  final ProductModel? product;
  final double? price;
  final double? qty;
  final double? total;

  Map<String, dynamic> toDb(int? customerInvoiceId) => {
    'customer_invoice_id': customerInvoiceId,
    'product_id': product?.id,
    'price': price,
    'qty': qty,
    'total': (price ?? 0.0) * (qty ?? 0.0),
  };

  CustomerInvoiceDetailsTableCompanion toDbCompanion(int? customerInvoiceId) =>
      CustomerInvoiceDetailsTableCompanion(
        customerInvoiceId: Value(customerInvoiceId),
        productId: Value(product?.id),
        price: Value(price),
        qty: Value(qty),
        total: Value(total),
      );
}
