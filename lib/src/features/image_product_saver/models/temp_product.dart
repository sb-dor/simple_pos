import 'package:faker/faker.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_color_model.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_image_model.dart';
import 'package:uuid/uuid.dart';

import 'temp_variant.dart';

class TempProduct {
  final int? id;
  final String? localUUID; // temp only for image update
  final String name;
  final String description;
  final String type;
  final bool isActive;
  final bool hasVariants;
  double price;
  final double? costPrice;
  final int stockQuantity;
  final String? barcode;
  final bool isNew;
  final double discountPrice;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final List<TempImageModel> productImages;
  final List<TempVariant> variants;
  final List<TempColorModel>? colors;

  TempProduct({
    this.id,
    this.localUUID,
    required this.name,
    required this.description,
    required this.type,
    required this.isActive,
    required this.hasVariants,
    required this.price,
    this.costPrice,
    required this.stockQuantity,
    this.barcode,
    required this.isNew,
    required this.discountPrice,
    this.weight,
    this.length,
    this.width,
    this.height,
    required this.productImages,
    required this.variants,
    this.colors,
  });

  factory TempProduct.fromJson(Map<String, dynamic> json) {
    return TempProduct(
      id: json['id'],
      localUUID: Uuid().v4(),
      name: json['name'],
      description: json['description'],
      type: json['type'],
      isActive: json['is_active'],
      hasVariants: json['has_variants'],
      price: double.tryParse("${json['price']}") ?? 0,
      costPrice: double.tryParse("${json['cost_price']}"),
      stockQuantity: json['stock_quantity'] ?? 0,
      barcode: json['barcode'],
      isNew: json['is_new'],
      discountPrice: double.tryParse("${json['discount_price']}") ?? 0.0,
      weight: double.tryParse("${json['weight']}"),
      length: double.tryParse("${json['length']}"),
      width: double.tryParse("${json['width']}"),
      height: double.tryParse("${json['height']}"),
      productImages: (json['images'] as List<dynamic>)
          .map((v) => TempImageModel.fromJson(v))
          .toList(),
      variants: (json['variants'] as List<dynamic>).map((v) => TempVariant.fromJson(v)).toList(),
      colors: (json['colors'] as List<dynamic>?)?.map((v) => TempColorModel.fromJson(v)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'local_uuid': localUUID,
    'description': Faker().lorem.sentences(3),
    'type': type,
    'default_unit_id': 1,
    'is_active': isActive ? 1 : 0,
    'has_variants': hasVariants ? 1 : 0,
    'price': price,
    "cost_price": costPrice,
    'stock_quantity': stockQuantity,
    'barcode': barcode,
    'discount_price': discountPrice,
    'weight': weight,
    'length': length,
    'width': width,
    'height': height,
    'variants': variants.map((v) => v.toJson()).toList(),
    "colors": colors?.map((v) => v.toMap()).toList(),
  };

  TempProduct copyWith({
    int? id,
    String? localUUID,
    String? name,
    String? description,
    String? type,
    bool? isActive,
    bool? hasVariants,
    double? price,
    double? costPrice,
    int? stockQuantity,
    String? barcode,
    bool? isNew,
    double? discountPrice,
    double? weight,
    double? length,
    double? width,
    double? height,
    List<TempImageModel>? productImages,
    List<TempVariant>? variants,
    List<TempColorModel>? colors,
  }) {
    return TempProduct(
      id: id ?? this.id,
      localUUID: localUUID ?? this.localUUID,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      hasVariants: hasVariants ?? this.hasVariants,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      barcode: barcode ?? this.barcode,
      isNew: isNew ?? this.isNew,
      discountPrice: discountPrice ?? this.discountPrice,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      productImages: productImages ?? this.productImages,
      variants: variants ?? this.variants,
      colors: colors ?? this.colors,
    );
  }
}
