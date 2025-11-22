import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

class CategoryCreationData {
  CategoryCreationData({required this.categoryId, required this.name, required this.color});

  final String categoryId;
  final String name;
  final Color color;
}

class CategoryCreationWidgetController with ChangeNotifier {
  CategoryCreationWidgetController({
    required final TextEditingController nameController,
    required final String categoryId,
  }) : _nameController = nameController,
       _categoryId = categoryId {
    _nameController.addListener(_nameListener);
  }

  final TextEditingController _nameController;

  final String _categoryId;

  CategoryCreationData get categoryCreationData =>
      CategoryCreationData(categoryId: _categoryId, name: name, color: _selectedColor);

  String get categoryId => _categoryId;

  Color _selectedColor = Colors.white;

  Color get selectedColor => _selectedColor;

  String get name => _nameController.text.trim();

  String? _error;

  String? get error => _error;

  bool get validated {
    _nameListener();
    return error == null;
  }

  void _nameListener() {
    if (_nameController.text.trim().isEmpty) {
      _error = fieldCannotBeEmpty;
    } else {
      _error = null;
    }
    notifyListeners();
  }

  void init(CategoryModel category) {
    _selectedColor = category.color ?? Colors.white;
    _nameController.text = category.name ?? '';
    notifyListeners();
  }

  Future<void> pickColor(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              _selectedColor = color;
              notifyListeners();
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))],
      ),
    ).ignore();
  }

  @override
  void dispose() {
    _nameController.removeListener(_nameListener);
    super.dispose();
  }
}
