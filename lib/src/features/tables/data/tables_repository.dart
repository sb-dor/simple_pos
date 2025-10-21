import 'package:test_pos_app/src/features/tables/models/table_model.dart';

import 'tables_datasource.dart';

abstract interface class ITablesRepository {
  Future<List<TableModel>> tables({int page = 1});
}

final class TablesRepositoryImpl implements ITablesRepository {
  TablesRepositoryImpl(this._iTablesDatasource);

  final ITablesDatasource _iTablesDatasource;

  @override
  Future<List<TableModel>> tables({int page = 1}) => _iTablesDatasource.tables(page: page);
}
