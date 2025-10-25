import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

class CategoryCreationData {
  CategoryCreationData({required this.name, required this.color});

  final String name;
  final Color color;
}

class CategoryCreationWidgetController extends ChangeNotifier {
  CategoryCreationWidgetController({required final TextEditingController nameController})
    : _nameController = nameController {
    _nameController.addListener(_nameListener);
  }

  final TextEditingController _nameController;

  CategoryCreationData get categoryCreationData =>
      CategoryCreationData(name: name, color: _selectedColor);

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
      _error = Constants.fieldCannotBeEmpty;
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

  void pickColor(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pick a color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              _selectedColor = color;
              notifyListeners();
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Done"))],
      ),
    ).ignore();
  }

  @override
  void dispose() {
    _nameController.removeListener(_nameListener);
    super.dispose();
  }
}
