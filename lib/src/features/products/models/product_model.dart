import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/products/models/product_type.dart';

@immutable
class ProductModel {
  const ProductModel({
    this.id,
    this.category,
    this.productType = ProductType.regular,
    this.name,
    this.price,
    this.wholesalePrice,
    this.packQty,
    this.barcode,
    this.visible = true,
    this.changed = true,
    this.imageData,
    this.updatedAt,
  });

  final String? id;
  final CategoryModel? category;
  final ProductType productType;
  final String? name;
  final double? price;
  final double? wholesalePrice;
  final double? packQty;
  final String? barcode;
  final bool visible;
  final bool changed;
  final Uint8List? imageData;
  final DateTime? updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          category == other.category &&
          productType == other.productType &&
          name == other.name &&
          price == other.price &&
          wholesalePrice == other.wholesalePrice &&
          packQty == other.packQty &&
          barcode == other.barcode &&
          visible == other.visible &&
          changed == other.changed &&
          imageData == other.imageData &&
          updatedAt == other.updatedAt);

  @override
  int get hashCode =>
      id.hashCode ^
      category.hashCode ^
      productType.hashCode ^
      name.hashCode ^
      price.hashCode ^
      wholesalePrice.hashCode ^
      packQty.hashCode ^
      barcode.hashCode ^
      visible.hashCode ^
      changed.hashCode ^
      imageData.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'ProductModel{'
        ' id: $id,'
        ' category: $category,'
        ' productType: $productType,'
        ' name: $name,'
        ' price: $price,'
        ' wholesalePrice: $wholesalePrice,'
        ' packQty: $packQty,'
        ' barcode: $barcode,'
        ' visible: $visible,'
        ' changed: $changed,'
        ' imageData: $imageData,'
        ' updatedAt: $updatedAt,'
        '}';
  }

  ProductModel copyWith({
    String? id,
    ValueGetter<CategoryModel?>? category,
    ValueGetter<String?>? name,
    ValueGetter<double?>? price,
    ValueGetter<double?>? wholesalePrice,
    ValueGetter<double?>? packQty,
    ValueGetter<String?>? barcode,
    ProductType? productType,
    bool? visible,
    bool? changed,
    ValueGetter<Uint8List?>? imageData,
    ValueGetter<DateTime?>? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      category: category != null ? category() : this.category,
      name: name != null ? name() : this.name,
      price: price != null ? price() : this.price,
      wholesalePrice: wholesalePrice != null ? wholesalePrice() : this.wholesalePrice,
      packQty: packQty != null ? packQty() : this.packQty,
      barcode: barcode != null ? barcode() : this.barcode,
      productType: productType ?? this.productType,
      visible: visible ?? this.visible,
      changed: changed ?? this.changed,
      imageData: imageData != null ? imageData() : this.imageData,
      updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'productType': productType,
      'name': name,
      'price': price,
      'wholesalePrice': wholesalePrice,
      'packQty': packQty,
      'barcode': barcode,
      'visible': visible,
      'changed': changed,
      'imageData': imageData,
      'updatedAt': updatedAt,
    };
  }
}
