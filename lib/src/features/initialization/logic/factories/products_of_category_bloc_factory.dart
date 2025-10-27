import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_repository.dart';

final class ProductsOfCategoryBlocFactory extends Factory<ProductsOfCategoryBloc> {
  ProductsOfCategoryBlocFactory({required AppDatabase appDatabase}) : _appDatabase = appDatabase;

  late final AppDatabase _appDatabase;

  @override
  ProductsOfCategoryBloc create() {
    final IProductsOfCategoryRepository productsOfCategoryRepository =
        ProductsOfCategoryRepositoryImpl(appDatabase: _appDatabase);

    return ProductsOfCategoryBloc(productsOfCategoryRepository: productsOfCategoryRepository);
  }
}
