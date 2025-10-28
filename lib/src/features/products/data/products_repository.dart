import 'package:test_pos_app/src/features/products/data/products_datasource.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

abstract interface class IProductsRepository {
  Future<List<ProductModel>> products();
}

final class ProductsRepositoryImpl implements IProductsRepository {
  ProductsRepositoryImpl({required final IProductsDatasource iProductsDatasource})
    : _iProductsDatasource = iProductsDatasource;

  final IProductsDatasource _iProductsDatasource;

  @override
  Future<List<ProductModel>> products() => _iProductsDatasource.products();
}
