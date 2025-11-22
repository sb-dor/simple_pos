import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

abstract interface class IProductCreationDatasource {
  Future<ProductsTableData?> product(final String? productId);

  Future<bool> save(final ProductModel product);
}

final class ProductCreationDatasource implements IProductCreationDatasource {
  ProductCreationDatasource({required final AppDatabase appDatabase}) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  Future<ProductsTableData?> product(String? productId) async {
    if (productId == null) return null;

    final productReq = _appDatabase.select(_appDatabase.productsTable)
      ..where((el) => el.id.equals(productId));

    return productReq.getSingleOrNull();
  }

  @override
  Future<bool> save(ProductModel product) async {
    final findProduct = await this.product(product.id);

    if (findProduct != null) {
      await (_appDatabase.update(
        _appDatabase.productsTable,
      )..where((el) => el.id.equals(product.id!))).write(
        ProductsTableData(
          id: product.id,
          productType: product.productType.type,
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
      );
      return true;
    } else if (product.id != null) {
      await _appDatabase
          .into(_appDatabase.productsTable)
          .insert(
            ProductsTableData(
              id: product.id,
              productType: product.productType.type,
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
          );
      return true;
    }

    return false;
  }
}
