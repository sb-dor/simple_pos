import 'package:drift/drift.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

abstract interface class ICategoryCreationDatasource {
  Future<CategoryTableData?> category(final String? categoryId);

  Future<bool> save(final CategoryModel category);

  Future<void> clearProducts(final String categoryId);
}

final class CategoryCreationDatasourceImpl implements ICategoryCreationDatasource {
  CategoryCreationDatasourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<CategoryTableData?> category(final String? categoryId) async {
    if (categoryId == null) return null;

    final categoryReq = _appDatabase.select(_appDatabase.categoryTable);

    categoryReq.where((el) => el.id.equals(categoryId));

    return categoryReq.getSingleOrNull();
  }

  @override
  Future<bool> save(CategoryModel category) async {
    final findCategory = await this.category(category.id);

    if (findCategory != null) {
      await (_appDatabase.update(
        _appDatabase.categoryTable,
      )..where((el) => el.id.equals(category.id!))).write(
        CategoryTableCompanion(
          id: Value(findCategory.id),
          name: Value(category.name),
          colorValue: Value(category.color?.toARGB32()),
          updatedAt: Value(DateTime.now()),
          changed: Value(category.changed),
        ),
      );
      return true;
    } else if (category.id != null) {
      await _appDatabase
          .into(_appDatabase.categoryTable)
          .insert(
            CategoryTableCompanion(
              id: Value(category.id!),
              name: Value(category.name),
              colorValue: Value(category.color?.toARGB32()),
              updatedAt: Value(category.updatedAt),
              changed: Value(category.changed),
            ),
          );
      return true;
    }

    return false;
  }

  @override
  Future<void> clearProducts(final String categoryId) async {
    await (_appDatabase.delete(
      _appDatabase.productsCategoriesTable,
    )..where((el) => el.categoryId.equals(categoryId))).go();
  }
}
