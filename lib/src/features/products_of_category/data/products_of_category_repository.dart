import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_datasource.dart';

abstract interface class IProductsOfCategoryRepository {
  Future<List<ProductModel>> productsOfCategory(final String categoryId);

  Future<bool> saveProductsToCategory({
    required final String categoryId,
    required final List<ProductModel> products,
  });
}

final class ProductsOfCategoryRepositoryImpl implements IProductsOfCategoryRepository {
  ProductsOfCategoryRepositoryImpl({
    required final IProductsOfCategoryDatasource productsOfCategoryDatasource,
  }) : _iProductsOfCategoryDatasource = productsOfCategoryDatasource;

  final IProductsOfCategoryDatasource _iProductsOfCategoryDatasource;

  @override
  Future<List<ProductModel>> productsOfCategory(final String categoryId) async {
    final products = await _iProductsOfCategoryDatasource.productsOfCategory(categoryId);

    return products.map(ProductModel.fromDbTable).toList();
  }

  @override
  Future<bool> saveProductsToCategory({
    required final String categoryId,
    required final List<ProductModel> products,
  }) => _iProductsOfCategoryDatasource.saveProductsToCategory(
    categoryId: categoryId,
    products: products,
  );
}
