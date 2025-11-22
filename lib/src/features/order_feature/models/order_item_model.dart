import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_detail_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

class OrderItemModel {
  OrderItemModel({this.product, this.price, this.qty});

  factory OrderItemModel.fromCustomerInvoiceDetail(CustomerInvoiceDetailModel? detail) =>
      OrderItemModel(product: detail?.product, price: detail?.price, qty: detail?.qty);

  ProductModel? product;
  double? price;
  double? qty;

  double total() => (price ?? 0.0) * (qty ?? 0.0);
}
