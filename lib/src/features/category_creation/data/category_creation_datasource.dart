import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

abstract interface class ICategoryCreationDatasource {
  Future<CategoryTableData?> category(final String? categoryId);

  Future<bool> save(final CategoryModel category);
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
  Future<bool> save(CategoryModel category) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
