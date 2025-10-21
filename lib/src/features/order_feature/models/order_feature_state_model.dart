import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';

// GlobalData.categories.first

//GlobalData.products.where((e) => e.category?.id == GlobalData.categories.first.id).toList()
class OrderFeatureStateModel {
  final List<ProductModel> productsForShow;

  final List<OrderItemModel> orderItems;

  final OrderItemModel? orderItemForChange;

  final TableModel? table;

  final CategoryModel? category;

  const OrderFeatureStateModel({
    required this.productsForShow,
    required this.orderItems,
    this.orderItemForChange,
    this.table,
    this.category,
  });

  factory OrderFeatureStateModel.initial() {
    return OrderFeatureStateModel(
      productsForShow: <ProductModel>[],
      orderItems: <OrderItemModel>[],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderFeatureStateModel &&
          runtimeType == other.runtimeType &&
          productsForShow == other.productsForShow &&
          orderItems == other.orderItems &&
          orderItemForChange == other.orderItemForChange &&
          table == other.table &&
          category == other.category);

  @override
  int get hashCode =>
      productsForShow.hashCode ^
      orderItems.hashCode ^
      orderItemForChange.hashCode ^
      table.hashCode ^
      category.hashCode;

  @override
  String toString() {
    return 'OrderFeatureStateModel{'
        ' productsForShow: $productsForShow,'
        ' orderItems: $orderItems,'
        ' orderItemForChange: $orderItemForChange,'
        ' table: $table,'
        ' category: $category,'
        '}';
  }

  OrderFeatureStateModel copyWith({
    List<ProductModel>? productsForShow,
    List<OrderItemModel>? orderItems,
    OrderItemModel? orderItemForChange,
    TableModel? table,
    CategoryModel? category,
  }) {
    return OrderFeatureStateModel(
      productsForShow: productsForShow ?? this.productsForShow,
      orderItems: orderItems ?? this.orderItems,
      orderItemForChange: orderItemForChange ?? this.orderItemForChange,
      table: table ?? this.table,
      category: category ?? this.category,
    );
  }
}
