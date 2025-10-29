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
    this.changed = false,
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

  factory ProductModel.fromDb(Map<String, dynamic> db) => ProductModel();
}
