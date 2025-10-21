import 'package:test_pos_app/src/features/image_product_saver/models/temp_product.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_variant.dart';

final product = TempProduct(
  name: 'Test something else okay ',
  description: '16 вариантов',
  type: 'simple',
  isActive: true,
  hasVariants: true,
  price: 15000,
  stockQuantity: 0,
  barcode: null,
  isNew: false,
  discountPrice: 10,
  weight: 300, // in gramms
  length: 30, // in cm
  width: 25, // in cm
  height: 2, // in cm
  productImages: [],
  variants: [
    TempVariant(
      id: 1,
      localUUID: 'generated_uuid_1',
      productId: 1,
      name: 'XS / Черныйsw',
      sku: 'again-body-черный-xs-some-ghing',
      barcode: null,
      price: 2490.00,
      stock: 0,
      isActive: true,
      createdAt: DateTime.parse('2025-04-30T01:19:29.000000Z').toString(),
      updatedAt: DateTime.parse('2025-04-30T01:19:29.000000Z').toString(),
      deletedAt: null,
      // optionValues: [],
      images: [],
    ),
    TempVariant(
      id: 2,
      localUUID: 'generated_uuid_2',
      productId: 1,
      name: 'XS / Фиолетыws',
      sku: 'again-body-фиолет-xs-some-ghing',
      barcode: null,
      price: 2490.00,
      stock: 0,
      isActive: true,
      createdAt: DateTime.parse('2025-04-30T01:19:29.000000Z').toString(),
      updatedAt: DateTime.parse('2025-04-30T01:19:29.000000Z').toString(),
      deletedAt: null,
      // optionValues: [],
      images: [],
    ),
    // ...continue with other variants the same way (id: 3–7)
  ],
  colors: [],
);
