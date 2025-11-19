import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/categories/bloc/categories_bloc.dart';
import 'package:test_pos_app/src/features/categories/data/categories_datasource.dart';
import 'package:test_pos_app/src/features/categories/data/categories_repository.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';

final class CategoriesBlocFactory extends Factory<CategoriesBloc> {
  CategoriesBlocFactory({required final AppDatabase appDatabase}) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  CategoriesBloc create() {
    final ICategoriesDatasource categoriesDatasource = CategoriesDatasourceImpl(_appDatabase);
    final ICategoriesRepository categoriesRepository = CategoriesRepositoryImpl(
      categoriesDatasource,
    );
    return CategoriesBloc(repository: categoriesRepository);
  }
}
