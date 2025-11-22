import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/common/global_data/global_data.dart';
import 'package:test_pos_app/src/common/models/waiter_model.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_detail_model.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

@immutable
class CustomerInvoiceModel {
  const CustomerInvoiceModel({
    this.id,
    this.waiter,
    this.table,
    this.total,
    this.totalQty,
    this.status,
    this.details,
    this.invoiceDateTime,
  });

  factory CustomerInvoiceModel.fromDb(
    CustomerInvoicesTableData db,
    List<CustomerInvoiceDetailModel> details,
  ) => CustomerInvoiceModel(
    id: db.id,
    waiter: currentWaiter,
    total: db.total,
    totalQty: db.totalQty,
    status: db.status,
    details: details,
    invoiceDateTime: db.invoiceDatetime,
  );

  final int? id;
  final WaiterModel? waiter;
  final TableModel? table;
  final double? total;
  final double? totalQty;
  final String? status;
  final List<CustomerInvoiceDetailModel>? details;
  final String? invoiceDateTime;

  Map<String, dynamic> toMap() => {
    'id': id,
    'waiter': waiter,
    'table': table,
    'total': total,
    'totalQty': totalQty,
    'status': status,
    'details': details,
    'invoiceDateTime': invoiceDateTime,
  };

  CustomerInvoiceModel copyWith({
    int? id,
    WaiterModel? waiter,
    TableModel? table,
    double? total,
    double? totalQty,
    String? status,
    List<CustomerInvoiceDetailModel>? details,
    String? invoiceDateTime,
  }) => CustomerInvoiceModel(
    id: id ?? this.id,
    waiter: waiter ?? this.waiter,
    table: table ?? this.table,
    total: total ?? this.total,
    totalQty: totalQty ?? this.totalQty,
    status: status ?? this.status,
    details: details ?? this.details,
    invoiceDateTime: invoiceDateTime ?? this.invoiceDateTime,
  );
}
