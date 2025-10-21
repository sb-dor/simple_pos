import 'dart:async';

import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';

abstract interface class IOrderTablesDatasource {
  FutureOr<List<TableModel>> tables({int page = 1});
}

final class OrderTablesDatasourceImpl implements IOrderTablesDatasource {
  OrderTablesDatasourceImpl({required final AppDatabase appDatabase, required final Logger logger})
    : _orderTableDbTableHelper = OrderTableDbTableHelper(appDatabase, logger),
      _logger = logger;

  final Logger _logger;
  final OrderTableDbTableHelper _orderTableDbTableHelper;

  @override
  Future<List<TableModel>> tables({int page = 1}) => _orderTableDbTableHelper.tables();
}
