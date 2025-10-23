import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

final class CategoriesDatabaseHelperImpl {
  CategoriesDatabaseHelperImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<CategoryModel>> categories() {
    // TODO: implement categories
    throw UnimplementedError();
  }
}
