import 'dart:async';

import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';

abstract interface class ITableCreationDatasource {
  FutureOr<TableModel?> table(final String tableId);

  FutureOr<bool> save(final TableModel tableModel);
}

final class TableCreationDatasourceImpl implements ITableCreationDatasource {
  TableCreationDatasourceImpl({
    required final AppDatabase appDatabase,
    required final Logger logger,
  }) : _orderTableDbTableHelper = OrderTableDbTableHelper(appDatabase, logger);

  final OrderTableDbTableHelper _orderTableDbTableHelper;

  @override
  Future<TableModel?> table(String tableId) => _orderTableDbTableHelper.table(tableId);

  @override
  Future<bool> save(TableModel tableModel) => _orderTableDbTableHelper.save(tableModel);
}
