import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_source.dart';
import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

abstract class IOrderFeatureRepo {
  Future<void> addToDb({required TableModel? table, required OrderItemModel? item});

  Future<bool> finishInvoice(TableModel? table, List<OrderItemModel> items);

  Future<List<OrderItemModel>> dbOrderItems(TableModel? table);

  Future<void> deleteOrderItemFromOrder(OrderItemModel? item, TableModel? table);

  Future<List<ProductModel>> categoriesProducts(CategoryModel category);

  Future<TableModel?> table(String id);
}

class OrderFeatureRepoImpl implements IOrderFeatureRepo {
  final IOrderFeatureSource _iOrderFeatureSource;

  OrderFeatureRepoImpl(this._iOrderFeatureSource);

  @override
  Future<void> addToDb({required TableModel? table, required OrderItemModel? item}) =>
      _iOrderFeatureSource.addToDb(table: table, item: item);

  @override
  Future<bool> finishInvoice(TableModel? table, List<OrderItemModel> items) =>
      _iOrderFeatureSource.finishInvoice(table, items);

  @override
  Future<List<OrderItemModel>> dbOrderItems(TableModel? table) =>
      _iOrderFeatureSource.dbOrderItems(table);

  @override
  Future<void> deleteOrderItemFromOrder(OrderItemModel? item, TableModel? table) =>
      _iOrderFeatureSource.deleteOrderItemFromOrder(item, table);

  @override
  Future<List<ProductModel>> categoriesProducts(CategoryModel category) =>
      _iOrderFeatureSource.categoriesProducts(category);

  @override
  Future<TableModel?> table(String id) => _iOrderFeatureSource.table(id);
}
