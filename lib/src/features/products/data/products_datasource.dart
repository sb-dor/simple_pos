import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

abstract interface class IProductsDatasource {
  Future<List<ProductModel>> products();
}

final class ProductsDatasourceImpl implements IProductsDatasource {

  ProductsDatasourceImpl({required final AppDatabase appDatabase}) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  Future<List<ProductModel>> products() {
    // TODO: implement products
    throw UnimplementedError();
  }
}
