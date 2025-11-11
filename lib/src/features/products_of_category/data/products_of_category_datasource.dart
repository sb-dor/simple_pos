import 'package:test_pos_app/src/common/utils/database/app_database.dart';

abstract interface class IProductsOfCategoryDatasource {
  Future<List<ProductsTableData>> productsOfCategory(final String categoryId);
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
}
