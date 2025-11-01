import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
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

  factory ProductModel.fromJson(Map<String, Object?> json) {
    return ProductModel(
      id: json['id'] as String?,
      productType: json['product_type'] == null
          ? ProductType.regular
          : ProductType.fromType(json['product_type'] as String?),
      name: json['name'] as String?,
      price: double.tryParse("${json['price']}"),
      wholesalePrice: double.tryParse("${json['wholesale_price']}"),
      packQty: json['pack_qty'] as double?,
      barcode: json['barcode'] as String?,
      visible: bool.tryParse("${json['visible']}") ?? false,
      changed: bool.tryParse("${json['changed']}") ?? false,
      imageData: json['image_data'] != null
          ? Uint8List.fromList((json['image_data'] as List).cast())
          : null,
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse("${json['updated_at']}"),
    );
  }

  factory ProductModel.fromDbTable(ProductsTableData db) {
    return ProductModel(
      id: db.id,
      name: db.name,
      productType: db.productType == null ? ProductType.regular : ProductType.fromType(db.productType!),
      price: db.price,
      wholesalePrice: db.wholesalePrice,
      packQty: db.packQty,
      barcode: db.barcode,
      visible: db.visible,
      changed: db.changed,
      imageData: db.imageData,
      updatedAt: db.updatedAt,
    );
  }

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
      'category_id': category?.id,
      'product_type': productType.type,
      'name': name,
      'price': price,
      'wholesale_price': wholesalePrice,
      'pack_qty': packQty,
      'barcode': barcode,
      'visible': visible,
      'changed': changed,
      'image_data': imageData,
      'updated_at': updatedAt,
    };
  }


  ProductsTableCompanion toDbProductCompanion() => ProductsTableCompanion(
    id: Value.absentIfNull(id),
    productType: Value(productType.type),
    name: Value(name),
    price: Value(price),
    wholesalePrice: Value(wholesalePrice),
    packQty: Value(packQty),
    barcode: Value(barcode),
    visible: Value(visible),
    imageData: Value(imageData),
    updatedAt: Value(updatedAt),
    changed: Value(false),
  );
}
