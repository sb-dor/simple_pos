import 'package:test_pos_app/src/features/categories/data/categories_datasource.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

/// Abstract interface for the categories repository.
/// Defines the contract for fetching categories.
abstract interface class ICategoriesRepository {
  /// Fetches the list of categories.
  ///
  /// Returns a [Future] that completes with a list of [CategoryModel].
  Future<List<CategoryModel>> categories();
}

/// Concrete implementation of [ICategoriesRepository] that delegates
/// operations to an [ICategoriesDatasource].
final class CategoriesRepositoryImpl implements ICategoriesRepository {
  /// Constructs the repository with the provided data source.
  CategoriesRepositoryImpl(this._iCategoriesDatasource);

  /// The data source used to fetch category data.
  final ICategoriesDatasource _iCategoriesDatasource;

  @override
  Future<List<CategoryModel>> categories() => _iCategoriesDatasource.categories();
}
