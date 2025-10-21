import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_detail_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

class OrderItemModel {
  OrderItemModel({this.product, this.price, this.qty});

  ProductModel? product;
  double? price;
  double? qty;

  factory OrderItemModel.fromCustomerInvoiceDetail(CustomerInvoiceDetailModel? detail) {
    return OrderItemModel(product: detail?.product, price: detail?.price, qty: detail?.qty);
  }

  double total() {
    return (price ?? 0.0) * (qty ?? 0.0);
  }
}
