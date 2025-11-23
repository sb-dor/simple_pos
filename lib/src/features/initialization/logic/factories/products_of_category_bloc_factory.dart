
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_datasource.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_repository.dart';

final class ProductsOfCategoryBlocFactory extends Factory<ProductsOfCategoryBloc> {
  ProductsOfCategoryBlocFactory({
    required final AppDatabase appDatabase,
  }) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  ProductsOfCategoryBloc create() {
    final IProductsOfCategoryDatasource datasource = ProductsOfCategoryDatasourceImpl(
      appDatabase: _appDatabase,
    );

    final IProductsOfCategoryRepository productsOfCategoryRepository =
        ProductsOfCategoryRepositoryImpl(productsOfCategoryDatasource: datasource);

    return ProductsOfCategoryBloc(
      productsOfCategoryRepository: productsOfCategoryRepository,
    );
  }
}
