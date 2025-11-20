import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_pos_app/src/common/utils/compress_image.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

class TableModelDataChange {
  bool isVip = false;
  Color selectedColor = Colors.white;
  XFile? imageData;
  String name = '';
}

class TableCreationChangeNotifierController with ChangeNotifier {
  TableCreationChangeNotifierController({required final TextEditingController textController})
    : _nameController = textController {
    _nameController.addListener(_textListener);
  }

  final TextEditingController _nameController;
  final TableModelDataChange tableModelDataChange = TableModelDataChange();
  String? error;

  void _textListener() {
    tableModelDataChange.name = _nameController.text.trim();
    if (_nameController.text.trim().isEmpty) {
      error = Constants.fieldCannotBeEmpty;
    } else {
      error = null;
    }
    notifyListeners();
  }

  bool get isValidate {
    _textListener();
    return error == null;
  }

  Future<void> init(TableModel tableModel) async {
    _nameController.text = tableModel.name ?? '';
    tableModelDataChange.isVip = tableModel.vip ?? false;
    tableModelDataChange.selectedColor = tableModel.color ?? Colors.blue;
    if (tableModel.imageData != null) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/tempImage.png')..createSync();
      file.writeAsBytesSync(tableModel.imageData!);
      tableModelDataChange.imageData = XFile(file.path);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      late final XFile? compressImage;
      if (kIsWeb) {
        compressImage = await CompressImage().compressImageForWeb(pickedFile);
      } else {
        compressImage = await CompressImage().compressImage(pickedFile);
      }
      tableModelDataChange.imageData = compressImage;
      notifyListeners();
    }
  }

  Future<void> deleteImage() async {
    tableModelDataChange.imageData = null;
    notifyListeners();
  }

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tableModelDataChange.selectedColor,
            onColorChanged: (color) {
              tableModelDataChange.selectedColor = color;
              notifyListeners();
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))],
      ),
    ).ignore();
  }

  void changeVIP() {
    tableModelDataChange.isVip = !tableModelDataChange.isVip;
    notifyListeners();
  }

  @override
  void dispose() {
    _nameController.removeListener(_textListener);
    super.dispose();
  }
}
