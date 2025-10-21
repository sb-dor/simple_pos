import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class CompressImage {
  Future<XFile?> compressImageForWeb(
    XFile file, {
    int quality = 70,
    int minWidth = 800,
    int minHeight = 600,
  }) async {
    final compressed = await FlutterImageCompress.compressWithList(
      await file.readAsBytes(),
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
      format: CompressFormat.jpeg,
    );
    return XFile.fromData(compressed);
  }

  Future<XFile?> compressImage(
    XFile file, {
    int quality = 70,
    int minWidth = 800,
    int minHeight = 600,
  }) async {
    final dir = await getTemporaryDirectory(); // Get temp directory
    final targetPath = "${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path, // Input file path
      targetPath, // Output file path
      quality: quality, // Compression quality (0-100)
      minWidth: minWidth,
      minHeight: minHeight,
      format: CompressFormat.jpeg, // Change format if needed
    );

    if (result == null) return null;

    return XFile(result.path);
  }
}
