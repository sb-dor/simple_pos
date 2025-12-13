import 'package:drift/drift.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/tables/products_categories_table.dart';
import 'package:uuid/uuid.dart';

class ProductOfCategory {
  ProductOfCategory({this.id, this.productId, this.categoryId});

  factory ProductOfCategory.fromJson(Map<String, Object?> json) => ProductOfCategory(
    id: json['id'] as String?,
    productId: json['product_id'] as String?,
    categoryId: json['category_id'] as String?,
  );

  factory ProductOfCategory.fromDbTable(ProductsCategoriesTableData db) =>
      ProductOfCategory(id: db.id, productId: db.productId, categoryId: db.categoryId);

  final String? id;
  final String? productId;
  final String? categoryId;

  Map<String, Object?> toJson() {
    return {'id': id, 'product_id': productId, 'category_id': categoryId};
  }

  ProductsCategoriesTableCompanion toDbProductCategoryCompanion() =>
      ProductsCategoriesTableCompanion(
        id: Value(id ?? const Uuid().v4()),
        productId: Value(productId),
        categoryId: Value(categoryId),
      );
}
