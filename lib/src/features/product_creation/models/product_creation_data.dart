import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/features/products/models/product_type.dart';

class ProductCreationData {
  const ProductCreationData({
    this.name,
    this.price,
    this.wholesalePrice,
    this.packQty,
    this.productType,
    this.barcode,
    this.visible = true,
    this.image,
  });

  final String? name;
  final double? price;
  final double? wholesalePrice;
  final double? packQty;
  final ProductType? productType;
  final String? barcode;
  final bool visible;
  final Uint8List? image;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCreationData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          wholesalePrice == other.wholesalePrice &&
          packQty == other.packQty &&
          productType == other.productType &&
          barcode == other.barcode &&
          visible == other.visible &&
          image == other.image);

  @override
  int get hashCode =>
      name.hashCode ^
      price.hashCode ^
      wholesalePrice.hashCode ^
      packQty.hashCode ^
      productType.hashCode ^
      barcode.hashCode ^
      visible.hashCode ^
      image.hashCode;

  @override
  String toString() => 'ProductCreationData{'
        ' name: $name,'
        ' price: $price,'
        ' wholesalePrice: $wholesalePrice,'
        ' packQty: $packQty,'
        ' productType: $productType,'
        ' barcode: $barcode,'
        ' visible: $visible,'
        ' image: $image,'
        '}';

  ProductCreationData copyWith({
    ValueGetter<String?>? name,
    ValueGetter<double?>? price,
    ValueGetter<double?>? wholesalePrice,
    ValueGetter<double?>? packQty,
    ProductType? productType,
    ValueGetter<String?>? barcode,
    bool? visible,
    ValueGetter<Uint8List?>? image,
  }) => ProductCreationData(
      name: name != null ? name() : this.name,
      price: price != null ? price() : this.price,
      wholesalePrice: wholesalePrice != null ? wholesalePrice() : this.wholesalePrice,
      packQty: packQty != null ? packQty() : this.packQty,
      productType: productType ?? this.productType,
      barcode: barcode != null ? barcode() : this.barcode,
      visible: visible ?? this.visible,
      image: image != null ? image() : this.image,
    );
}
