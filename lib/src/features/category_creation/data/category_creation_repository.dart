import 'package:test_pos_app/src/features/category_creation/data/category_creation_datasource.dart';

abstract interface class ICategoryCreationRepository {}

final class CategoryCreationRepositoryImpl implements ICategoryCreationRepository {
  CategoryCreationRepositoryImpl(this._iCategoryCreationDatasource);

  final ICategoryCreationDatasource _iCategoryCreationDatasource;
}
