import 'dart:ui';

import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_datasource.dart';

abstract interface class ICategoryCreationRepository {
  Future<CategoryModel?> category(final String categoryId);

  Future<bool> save(final CategoryModel category);

  /// use only when you are closing screen
  /// it should clear all saved products of category if category was not created
  Future<bool> clearProducts(final String categoryId);
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

  @override
  Future<bool> clearProducts(final String categoryId) async {
    final findCategory = await category(categoryId);
    // if category exists we will return false
    // cause if category exists we dont want clear it's saved products
    if (findCategory != null) return false;
    await _iCategoryCreationDatasource.clearProducts(categoryId);
    return true;
  }
}
