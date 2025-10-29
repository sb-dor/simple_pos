import 'package:test_pos_app/src/features/product_creation/data/product_creation_datasource.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/products/models/product_type.dart';

abstract interface class IProductCreationRepository {
  Future<ProductModel?> product(final String? productId);

  Future<bool> save(final ProductModel product);
}

final class ProductCreationRepositoryImpl implements IProductCreationRepository {
  ProductCreationRepositoryImpl({
    required final IProductCreationDatasource productCreationDatasource,
  }) : _iProductCreationDatasource = productCreationDatasource;

  final IProductCreationDatasource _iProductCreationDatasource;

  @override
  Future<ProductModel?> product(String? productId) async {
    final productData = await _iProductCreationDatasource.product(productId);

    if (productData == null) return null;

    return ProductModel(
      id: productData.id,
      productType: ProductType.fromType(productData.productType),
      name: productData.name,
      price: productData.price,
      wholesalePrice: productData.wholesalePrice,
      packQty: productData.packQty,
      barcode: productData.barcode,
      visible: productData.visible,
      changed: productData.changed,
      imageData: productData.imageData,
      updatedAt: productData.updatedAt,
    );
  }

  @override
  Future<bool> save(ProductModel product) => _iProductCreationDatasource.save(product);
}
