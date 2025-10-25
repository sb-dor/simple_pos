import 'dart:ui';

import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

abstract interface class ICategoriesDatasource {
  Future<List<CategoryModel>> categories();
}

final class CategoriesDatasourceImpl implements ICategoriesDatasource {
  CategoriesDatasourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<CategoryModel>> categories() async {
    final categoriesReq = await _appDatabase.select(_appDatabase.categoryTable).get();

    return categoriesReq
        .map(
          (category) => CategoryModel(
            id: category.id,
            name: category.name,
            updatedAt: category.updatedAt,
            color: category.colorValue == null ? null : Color(category.colorValue!),
            changed: category.changed,
          ),
        )
        .toList();
  }
}
