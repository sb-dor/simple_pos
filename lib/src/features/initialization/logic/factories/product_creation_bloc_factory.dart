import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_pos_app/src/features/product_creation/bloc/product_creation_bloc.dart';
import 'package:test_pos_app/src/features/product_creation/data/product_creation_datasource.dart';
import 'package:test_pos_app/src/features/product_creation/data/product_creation_repository.dart';

final class ProductCreationBlocFactory extends Factory<ProductCreationBloc> {
  ProductCreationBlocFactory({required final AppDatabase appDatabase}) : _appDatabase = appDatabase;

  final AppDatabase _appDatabase;

  @override
  ProductCreationBloc create() {
    final IProductCreationDatasource productCreationDatasource = ProductCreationDatasource(
      appDatabase: _appDatabase,
    );

    final IProductCreationRepository productCreationRepository = ProductCreationRepositoryImpl(
      productCreationDatasource: productCreationDatasource,
    );

    return ProductCreationBloc(productCreationRepository: productCreationRepository);
  }
}
