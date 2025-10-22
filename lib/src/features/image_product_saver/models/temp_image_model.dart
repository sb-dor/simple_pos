import 'package:image_picker/image_picker.dart';
import 'package:test_pos_app/src/features/image_product_saver/controller/image_product_constant.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/image_size.dart';

class TempImageModel {
  TempImageModel({this.id, this.file, this.path});

  final int? id;
  final XFile? file;
  final String? path;

  factory TempImageModel.fromJson(final Map<String, dynamic> json) {
    return TempImageModel(id: json['id'], file: null, path: json['path']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{"id": id, "path": path};

  String imageURL(ImageSize imageSize) {
    final getImage = "${ImageProductConstant.baseURL}/product/image/${imageSize.value}_$path";
    return getImage;
  }
}
