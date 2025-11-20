import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';

extension OrderItemExtensions on List<OrderItemModel> {
  double total() => fold(0, (prev, item) => prev += item.total());

  double totalQty() => fold(0, (prev, item) => prev += item.qty ?? 0.0);
}
