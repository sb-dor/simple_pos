import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/category_creation/bloc/category_creation_bloc.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_datasource.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_repository.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';

final class CategoryCreationBlocFactory extends Factory<CategoryCreationBloc> {
  CategoryCreationBlocFactory({
    required final AppDatabase appDatabase,
    required final Logger logger,
  }) : _appDatabase = appDatabase,
       _logger = logger;

  final AppDatabase _appDatabase;
  final Logger _logger;

  @override
  CategoryCreationBloc create() {
    final categoryCreationDatasource = CategoryCreationDatasourceImpl(_appDatabase);
    final categoryCreationRepository = CategoryCreationRepositoryImpl(categoryCreationDatasource);
    final categoryCreationBloc = CategoryCreationBloc(
      repository: categoryCreationRepository,
      logger: _logger,
    );
    return categoryCreationBloc;
  }
}
