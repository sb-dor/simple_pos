import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';

@immutable
class CashierFeatureStateModel {
  const CashierFeatureStateModel({
    required this.hasMore,
    required this.allCustomerInvoices,
    required this.invoices,
  });

  factory CashierFeatureStateModel.initial() => const CashierFeatureStateModel(
    hasMore: true,
    allCustomerInvoices: <CustomerInvoiceModel>[],
    invoices: <CustomerInvoiceModel>[],
  );
  final bool hasMore;

  final List<CustomerInvoiceModel> allCustomerInvoices;

  final List<CustomerInvoiceModel> invoices;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashierFeatureStateModel &&
          runtimeType == other.runtimeType &&
          hasMore == other.hasMore &&
          allCustomerInvoices == other.allCustomerInvoices &&
          invoices == other.invoices);

  @override
  int get hashCode => hasMore.hashCode ^ allCustomerInvoices.hashCode ^ invoices.hashCode;

  @override
  String toString() =>
      'CashierFeatureStateModel { '
      'hasMore: $hasMore, '
      'allCustomerInvoices: $allCustomerInvoices, '
      'invoices: $invoices'
      '}';

  CashierFeatureStateModel copyWith({
    bool? hasMore,
    List<CustomerInvoiceModel>? allCustomerInvoices,
    List<CustomerInvoiceModel>? invoices,
  }) => CashierFeatureStateModel(
    hasMore: hasMore ?? this.hasMore,
    allCustomerInvoices: allCustomerInvoices ?? this.allCustomerInvoices,
    invoices: invoices ?? this.invoices,
  );
}
