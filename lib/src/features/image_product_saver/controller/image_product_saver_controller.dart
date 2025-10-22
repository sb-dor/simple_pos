import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/image_product_saver/controller/image_product_constant.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_image_model.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_product.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_variant.dart';
import 'package:dio/dio.dart';

class ImageProductSaverController with ChangeNotifier {
  ImageProductSaverController(this._logger);

  final Logger _logger;

  bool sending = false;

  Future<void> setImagesWithProduct(final TempProduct product) async {
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

      final map = product.toJson();

      final List<MultipartFile> files = [];

      for (final each in product.productImages) {
        if (each.file != null) {
          files.add(await MultipartFile.fromFile(each.file!.path, filename: each.file?.name));
        }
      }

      for (final each in product.variants) {
        final List<MultipartFile> files = [];
        for (final eachImage in (each.images ?? <TempImageModel>[])) {
          if (eachImage.file != null) {
            files.add(
              await MultipartFile.fromFile(eachImage.file!.path, filename: eachImage.file?.name),
            );
          }
        }
        if (files.isNotEmpty) {
          map['variant_images_${each.localUUID}[]'] = files;
        }
      }

      map['product_images[]'] = files;

      final formData = FormData.fromMap(map);

      final response = await dio.post("/products", data: formData);

      _logger.log(Level.debug, response.data);

      sending = false;
      notifyListeners();
    } on DioException catch (error, stackTrace) {
      sending = false;
      notifyListeners();
      _logger.log(Level.error, "error is: ${error.response}");
      Error.throwWithStackTrace(error, stackTrace);
    } catch (error, stackTrace) {
      sending = false;
      notifyListeners();
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> pickImageForProduct(final TempProduct product) async {
    final images = await ImagePicker().pickMultiImage();

    if (images.isEmpty) return;

    product.productImages.addAll(images.map((element) => TempImageModel(file: element)));

    notifyListeners();
  }

  Future<void> pickImageForProductVariant(final TempVariant productVariant) async {
    final images = await ImagePicker().pickMultiImage();

    if (images.isEmpty) return;

    productVariant.images?.addAll(images.map((element) => TempImageModel(file: element)));

    notifyListeners();
  }
}
