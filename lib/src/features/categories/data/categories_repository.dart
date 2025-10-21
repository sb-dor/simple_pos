import 'package:test_pos_app/src/features/categories/data/categories_datasource.dart';

abstract interface class ICategoriesRepository {}

final class CategoriesRepositoryImpl implements ICategoriesRepository {
  CategoriesRepositoryImpl(this._iCategoriesDatasource);

  final ICategoriesDatasource _iCategoriesDatasource;
}
