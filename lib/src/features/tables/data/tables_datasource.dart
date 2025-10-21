import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';

abstract interface class ITablesDatasource {
  Future<List<TableModel>> tables({int page = 1});
}

final class TablesDatasourceImpl implements ITablesDatasource {
  TablesDatasourceImpl({required final AppDatabase appDatabase, required final Logger logger})
    : _orderTableDbTableHelper = OrderTableDbTableHelper(appDatabase, logger),
      _logger = logger;

  final OrderTableDbTableHelper _orderTableDbTableHelper;
  final Logger _logger;

  @override
  Future<List<TableModel>> tables({int page = 1}) => _orderTableDbTableHelper.tables();
}
