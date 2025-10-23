import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';

abstract interface class ITablesDatasource {
  Future<List<TableModel>> tables({int page = 1});
}

final class TablesDatasourceImpl implements ITablesDatasource {
  TablesDatasourceImpl({required final OrderTableDbTableHelper orderTableDbTableHelper})
    : _orderTableDbTableHelper = orderTableDbTableHelper;

  final OrderTableDbTableHelper _orderTableDbTableHelper;

  @override
  Future<List<TableModel>> tables({int page = 1}) => _orderTableDbTableHelper.tables();
}
