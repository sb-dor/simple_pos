import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_datasource.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_repository.dart';

final class ProductsOfCategoryBlocFactory extends Factory<ProductsOfCategoryBloc> {
  ProductsOfCategoryBlocFactory({
    required final AppDatabase appDatabase,
    required final Logger logger,
  }) : _appDatabase = appDatabase,
       _logger = logger;

  final AppDatabase _appDatabase;
  final Logger _logger;

  @override
  ProductsOfCategoryBloc create() {
    final IProductsOfCategoryDatasource datasource = ProductsOfCategoryDatasourceImpl(
      appDatabase: _appDatabase,
    );

    final IProductsOfCategoryRepository productsOfCategoryRepository =
        ProductsOfCategoryRepositoryImpl(productsOfCategoryDatasource: datasource);

    return ProductsOfCategoryBloc(
      productsOfCategoryRepository: productsOfCategoryRepository,
      logger: _logger,
    );
  }
}
