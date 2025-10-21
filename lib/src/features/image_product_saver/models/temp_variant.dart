import 'package:faker/faker.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_color_model.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_image_model.dart';
import 'package:uuid/uuid.dart';

class TempVariant {
  final int? id;
  final String? localUUID;
  final int? productId;
  final String? name;
  final String? sku;
  final String? barcode;
  double? price;
  final double? costPrice;
  final int? stock;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  List<TempImageModel>? images;
  final List<TempColorModel>? colors;

  TempVariant({
    this.id,
    this.localUUID,
    this.productId,
    this.name,
    this.sku,
    this.barcode,
    this.price,
    this.costPrice,
    this.stock,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.images,
    this.colors,
  });

  factory TempVariant.fromJson(Map<String, dynamic> json) {
    return TempVariant(
      id: json['id'],
      localUUID: const Uuid().v4(),
      productId: json['product_id'],
      name: json['name'],
      sku: json['sku'],
      barcode: json['barcode'],
      price: double.tryParse("${json['price']}"),
      costPrice: double.tryParse("${json['cost_price']}"),
      stock: int.tryParse("${json['stock_quantity']}"),
      isActive: json['is_active'] is bool ? json['is_active'] : json['is_active'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      images: (json['images'] as List<dynamic>?)
          ?.map((element) => TempImageModel.fromJson(element))
          .toList(),
      colors: (json['colors'] as List<dynamic>?)?.map((v) => TempColorModel.fromJson(v)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'local_uuid': localUUID,
    'product_id': productId,
    "description": Faker().lorem.sentences(3),
    'name': name,
    'sku': sku,
    'barcode': barcode,
    'price': price,
    'cost_price': costPrice,
    'stock': stock,
    'is_active': isActive == true ? 1 : 0,
    'colors': colors?.map((element) => element.toMap()).toList(),
    // 'images[]': images?.where((e) => e.path != null).map((e) => e.path).toList(),
  };
}
