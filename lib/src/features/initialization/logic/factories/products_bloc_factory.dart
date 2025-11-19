import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_initialization.dart';
import 'package:test_pos_app/src/features/products/bloc/products_bloc.dart';
import 'package:test_pos_app/src/features/products/data/products_datasource.dart';
import 'package:test_pos_app/src/features/products/data/products_repository.dart';

final class ProductsBlocFactory extends Factory<ProductsBloc> {
  ProductsBlocFactory(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  ProductsBloc create() {
    final IProductsDatasource productsDatasource = ProductsDatasourceImpl(
      appDatabase: _appDatabase,
    );

    final IProductsRepository productsRepository = ProductsRepositoryImpl(
      iProductsDatasource: productsDatasource,
    );

    return ProductsBloc(iProductsRepository: productsRepository);
  }
}
