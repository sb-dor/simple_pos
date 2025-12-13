import 'package:drift/drift.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class IProductsOfCategoryDatasource {
  Future<List<ProductsTableData>> productsOfCategory(final String categoryId);

  Future<bool> saveProductsToCategory({
    required final String categoryId,
    required final List<ProductModel> products,
  });
}

final class ProductsOfCategoryDatasourceImpl implements IProductsOfCategoryDatasource {
  ProductsOfCategoryDatasourceImpl({required final AppDatabase appDatabase})
    : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  Future<List<ProductsTableData>> productsOfCategory(final String categoryId) async {
    final products = await (_appDatabase.select(
      _appDatabase.productsCategoriesTable,
    )..where((el) => el.categoryId.equals(categoryId))).get();

    final productsIds = products.map((el) => el.productId ?? '').toList();

    return (_appDatabase.select(
      _appDatabase.productsTable,
    )..where((el) => el.id.isIn(productsIds))).get();
  }

  @override
  Future<bool> saveProductsToCategory({
    required String categoryId,
    required List<ProductModel> products,
  }) async {
    final rows = products
        .map(
          (p) => ProductsCategoriesTableCompanion(
            id: Value(const Uuid().v4()),
            productId: Value(p.id),
            categoryId: Value(categoryId),
            changed: const Value(true),
          ),
        )
        .toList();

    await _appDatabase.batch((batch) {
      batch
        ..deleteWhere(
          _appDatabase.productsCategoriesTable,
          (tbl) => tbl.categoryId.equals(categoryId),
        )
        ..insertAll(_appDatabase.productsCategoriesTable, rows);
    });

    return true;
  }
}
