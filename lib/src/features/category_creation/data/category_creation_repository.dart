import 'dart:ui';

import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_datasource.dart';

abstract interface class ICategoryCreationRepository {
  Future<CategoryModel?> category(final String? categoryId);

  Future<bool> save(final CategoryModel category);
}

final class CategoryCreationRepositoryImpl implements ICategoryCreationRepository {
  CategoryCreationRepositoryImpl(this._iCategoryCreationDatasource);

  final ICategoryCreationDatasource _iCategoryCreationDatasource;

  @override
  Future<CategoryModel?> category(final String? categoryId) async {
    final categoryData = await _iCategoryCreationDatasource.category(categoryId);

    if (categoryData == null) return null;

    return CategoryModel(
      id: categoryData.id,
      name: categoryData.name,
      updatedAt: categoryData.updatedAt,
      color: categoryData.colorValue == null ? null : Color(categoryData.colorValue!),
      changed: categoryData.changed,
    );
  }

  @override
  Future<bool> save(CategoryModel category) => _iCategoryCreationDatasource.save(category);
}
