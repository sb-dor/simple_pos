import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

abstract interface class IProductsOfCategoryRepository {
  Future<List<ProductModel>> productsOfCategory(final String? categoryId);
}

final class ProductsOfCategoryRepositoryImpl implements IProductsOfCategoryRepository {
  ProductsOfCategoryRepositoryImpl({required final AppDatabase appDatabase})
    : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  Future<List<ProductModel>> productsOfCategory(final String? categoryId) {
    // TODO: implement productsOfCategory
    throw UnimplementedError();
  }
}
