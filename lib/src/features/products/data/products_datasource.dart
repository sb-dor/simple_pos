import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/products/models/product_type.dart';

abstract interface class IProductsDatasource {
  Future<List<ProductModel>> products();
}

final class ProductsDatasourceImpl implements IProductsDatasource {
  ProductsDatasourceImpl({required final AppDatabase appDatabase}) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  Future<List<ProductModel>> products() async {
    final productsReq = await _appDatabase.select(_appDatabase.productsTable).get();

    return productsReq
        .map(
          (product) => ProductModel(
            id: product.id,
            productType: ProductType.fromType(product.productType),
            name: product.name,
            price: product.price,
            wholesalePrice: product.wholesalePrice,
            packQty: product.packQty,
            barcode: product.barcode,
            visible: product.visible,
            changed: product.changed,
            imageData: product.imageData,
            updatedAt: product.updatedAt,
          ),
        )
        .toList();
  }
}
