import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/image_product_saver/controller/image_product_constant.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_image_model.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_product.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_variant.dart';
import 'package:uuid/uuid.dart';

class ImageProductUpdateController with ChangeNotifier {

  ImageProductUpdateController(this._logger);
  final Logger _logger;

  bool sending = false;

  TempProduct? tempProduct;

  Future<void> product(int productId) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: ImageProductConstant.baseURL,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${ImageProductConstant.token}',
            // if needed
          },
        ),
      );

      final response = await dio.get('/products?product_id=$productId');

      _logger.log(Level.debug, response.data);

      tempProduct = TempProduct.fromJson(response.data as Map<String, Object?>);

      notifyListeners();
    } on DioException catch (error, stackTrace) {
      _logger.log(Level.error, 'error is: ${error.response}');
      Error.throwWithStackTrace(error, stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> update() async {
    if (tempProduct == null) return;
    try {
      if (sending) return;

      sending = true;

      notifyListeners();

      final dio = Dio(
        BaseOptions(
          baseUrl: ImageProductConstant.baseURL,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${ImageProductConstant.token}',
            // if needed
          },
        ),
      );

      final map = tempProduct!.toJson();

      _logger.log(Level.debug, "message of product: ${map['variants']}");

      final files = <MultipartFile>[];
      final pathImages = <String>[];
      final productAndVariantImagesPosition = <String, int>{};

      for (var i = 0; i < tempProduct!.productImages.length; i++) {
        final each = tempProduct!.productImages[i];
        if (each.file != null) {
          files.add(await MultipartFile.fromFile(each.file!.path, filename: each.file?.name));
          productAndVariantImagesPosition['product_image_file_${files.length - 1}'] = i;
        }
        if (each.path != null) {
          pathImages.add(each.path!);
          productAndVariantImagesPosition['product_image_path_${each.path!}'] = i;
        }
      }

      for (final each in tempProduct!.variants) {
        final files = <MultipartFile>[];
        final pathImages = <String>[];
        for (var i = 0; i < (each.images ?? <TempImageModel>[]).length; i++) {
          final eachImage = (each.images ?? <TempImageModel>[])[i];
          if (eachImage.file != null) {
            files.add(
              await MultipartFile.fromFile(eachImage.file!.path, filename: eachImage.file?.name),
            );
            productAndVariantImagesPosition['variant_${each.localUUID}_image_file_${files.length - 1}'] =
                i;
          }
          if (eachImage.path != null) {
            pathImages.add(eachImage.path!);
            productAndVariantImagesPosition['variant_${each.localUUID}_image_path_${eachImage.path!}'] =
                i;
          }
        }
        if (files.isNotEmpty) {
          map['variant_images_${each.localUUID}[]'] = files;
        }
        if (pathImages.isNotEmpty) {
          map['variant_name_images_${each.localUUID}[]'] = pathImages;
        }
      }

      // new files here
      map['product_images[]'] = files;
      map['images[]'] = pathImages;
      map.addAll(productAndVariantImagesPosition);

      _logger.log(Level.debug, map);

      final formData = FormData.fromMap(map);

      final response = await dio.post('/products/update/${tempProduct?.id}', data: formData);

      _logger.log(Level.debug, response.data);

      sending = false;
      notifyListeners();
    } on DioException catch (error, stackTrace) {
      sending = false;
      notifyListeners();
      _logger.log(Level.error, 'error is: ${error.response}');
      Error.throwWithStackTrace(error, stackTrace);
    } catch (error, stackTrace) {
      sending = false;
      notifyListeners();
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> pickImageForProduct() async {
    if (tempProduct == null) return;

    final images = await ImagePicker().pickMultiImage();

    if (images.isEmpty) return;

    tempProduct!.productImages.addAll(images.map((element) => TempImageModel(file: element)));

    notifyListeners();
  }

  Future<void> pickImageForProductVariant(final TempVariant productVariant) async {
    final images = await ImagePicker().pickMultiImage();

    if (images.isEmpty) return;

    productVariant.images ??= <TempImageModel>[];

    productVariant.images?.addAll(images.map((element) => TempImageModel(file: element)));

    notifyListeners();
  }

  Future<void> removeImageFromProduct(int index) async {
    if (tempProduct == null) return;

    tempProduct?.productImages.removeAt(index);

    notifyListeners();
  }

  Future<void> removeImageFromProductVariant(final TempVariant variant, int index) async {
    variant.images?.removeAt(index);
    notifyListeners();
  }

  Future<void> removeVariant(int index) async {
    if (tempProduct == null) return;

    tempProduct?.variants.removeAt(index);

    notifyListeners();
  }

  Future<void> addVariant() async {
    if (tempProduct == null) return;
    final variant = TempVariant(
      localUUID: const Uuid().v4(),
      name: Faker().vehicle.model(),
      barcode: null,
      price: 2490,
      stock: 0,
      isActive: true,
      deletedAt: null,
    );
    tempProduct?.variants.add(variant);
    notifyListeners();
  }

  void reorderVariantImages(TempVariant variant, int oldIndex, int newIndex) {
    final images = variant.images;
    if (images == null || images.length < 2) return;

    final updatedList = List.of(images);
    final movedImage = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, movedImage);

    variant.images = updatedList;
    notifyListeners();
  }

  void reorderProductImages(int oldIndex, int newIndex) {
    // Adjust the newIndex if moving down
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = tempProduct!.productImages.removeAt(oldIndex);
    tempProduct!.productImages.insert(newIndex, item);
    notifyListeners();
  }
}
