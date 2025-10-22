import 'package:test_pos_app/src/features/categories/data/categories_datasource.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

abstract interface class ICategoriesRepository {
  Future<List<CategoryModel>> categories();
}

final class CategoriesRepositoryImpl implements ICategoriesRepository {
  CategoriesRepositoryImpl(this._iCategoriesDatasource);

  final ICategoriesDatasource _iCategoriesDatasource;

  @override
  Future<List<CategoryModel>> categories() => _iCategoriesDatasource.categories();
}
