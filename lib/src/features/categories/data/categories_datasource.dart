import 'package:test_pos_app/src/common/utils/database/database_helpers/categories/categories_database_helper.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

abstract interface class ICategoriesDatasource {
  Future<List<CategoryModel>> categories();
}

final class CategoriesDatasourceImpl implements ICategoriesDatasource {
  CategoriesDatasourceImpl(this._categoriesDatabaseHelper);

  final ICategoriesDatabaseHelper _categoriesDatabaseHelper;

  @override
  Future<List<CategoryModel>> categories() {
    // TODO: implement categories
    throw UnimplementedError();
  }
}
