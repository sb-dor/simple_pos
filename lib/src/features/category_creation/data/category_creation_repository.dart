import 'dart:ui';

import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_datasource.dart';

/// Abstract interface for the category creation repository.
/// Provides methods to fetch, save, and clear products of a category.
abstract interface class ICategoryCreationRepository {
  /// Retrieves a category by its ID.
  ///
  /// [categoryId] — the ID of the category to fetch.
  /// Returns a [Future] that completes with a [CategoryModel] if found, or `null` otherwise.
  Future<CategoryModel?> category(final String categoryId);

  /// Saves a category.
  ///
  /// [category] — the category data to save.
  /// Returns a [Future] that completes with `true` if saving was successful.
  Future<bool> save(final CategoryModel category);

  /// Clears all saved products of a category.
  ///
  /// Use only when closing a screen.
  /// [categoryId] — the ID of the category to clear.
  /// Returns `true` if the products were cleared, `false` if the category already exists.
  Future<bool> clearProducts(final String categoryId);
}

/// Concrete implementation of [ICategoryCreationRepository] that delegates
/// operations to an [ICategoryCreationDatasource].
final class CategoryCreationRepositoryImpl implements ICategoryCreationRepository {
  /// Constructs the repository with the provided data source.
  CategoryCreationRepositoryImpl(this._iCategoryCreationDatasource);

  /// Data source used to fetch, save, and clear category data.
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
    // If category exists, we do not clear its saved products
    if (findCategory != null) return false;
    await _iCategoryCreationDatasource.clearProducts(categoryId);
    return true;
  }
}
