import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/categories/categories_database_helper.dart';
import 'package:test_pos_app/src/features/categories/bloc/categories_bloc.dart';
import 'package:test_pos_app/src/features/categories/data/categories_datasource.dart';
import 'package:test_pos_app/src/features/categories/data/categories_repository.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';

final class CategoriesBlocFactory extends Factory<CategoriesBloc> {
  CategoriesBlocFactory({required final AppDatabase appDatabase}) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  CategoriesBloc create() {
    final categoryDatabaseHelper = CategoriesDatabaseHelperImpl(_appDatabase);
    final ICategoriesDatasource categoriesDatasource = CategoriesDatasourceImpl(
      categoryDatabaseHelper,
    );
    final ICategoriesRepository categoriesRepository = CategoriesRepositoryImpl(
      categoriesDatasource,
    );
    return CategoriesBloc(repository: categoriesRepository);
  }
}
