import 'package:faker/faker.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_color_model.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_image_model.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_variant.dart';
import 'package:uuid/uuid.dart';

class TempProduct {
  TempProduct({
    required this.name,
    required this.description,
    required this.type,
    required this.isActive,
    required this.hasVariants,
    required this.price,
    required this.stockQuantity,
    required this.isNew,
    required this.discountPrice,
    required this.productImages,
    required this.variants,
    this.id,
    this.localUUID,
    this.costPrice,
    this.barcode,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.colors,
  });

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

  factory TempProduct.fromJson(Map<String, Object?> json) => TempProduct(
    id: json['id'] as int?,
    localUUID: Uuid().v4(),
    name: json['name'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    isActive: json['is_active'] as bool,
    hasVariants: json['has_variants'] as bool,
    price: double.tryParse("${json['price']}") ?? 0,
    costPrice: double.tryParse("${json['cost_price']}"),
    stockQuantity: json['stock_quantity'] as int,
    barcode: json['barcode'] as String,
    isNew: json['is_new'] as bool,
    discountPrice: double.tryParse("${json['discount_price']}") ?? 0.0,
    weight: double.tryParse("${json['weight']}"),
    length: double.tryParse("${json['length']}"),
    width: double.tryParse("${json['width']}"),
    height: double.tryParse("${json['height']}"),
    productImages: (json['images'] as List<dynamic>)
        .map((v) => TempImageModel.fromJson(v as Map<String, dynamic>))
        .toList(),
    variants: (json['variants'] as List<dynamic>)
        .map((v) => TempVariant.fromJson(v as Map<String, dynamic>))
        .toList(),
    colors: (json['colors'] as List<dynamic>?)
        ?.map((v) => TempColorModel.fromJson(v as Map<String, dynamic>))
        .toList(),
  );

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
  }) => TempProduct(
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
