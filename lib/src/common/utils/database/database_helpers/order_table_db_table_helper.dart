import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';

final class OrderTableDbTableHelper {
  OrderTableDbTableHelper(this._appDatabase, this._logger);

  final AppDatabase _appDatabase;
  final Logger _logger;

  Future<TableModel?> table(String tableId) async {
    final findTable = await _findTable(tableId);
    if (findTable != null) {
      return TableModel.fromDbTable(findTable);
    }
    return null;
  }

  Future<bool> save(TableModel tableModel) async {
    try {
      final findTable = await _findTable(tableModel.id!);
      if (findTable == null) {
        await (_appDatabase
            .into(_appDatabase.orderTableDbTable)
            .insert(tableModel.toDbTableCompanion(changed: tableModel.changed)));
      } else {
        await (_appDatabase.update(_appDatabase.orderTableDbTable)
              ..where((element) => element.id.equals(tableModel.id!)))
            .write(tableModel.toDbTableCompanion(changed: tableModel.changed));
      }
      return true;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<TableModel>> tables({final bool getOnlyChanged = false}) async {
    final allTablesData = _appDatabase.select(_appDatabase.orderTableDbTable);

    if (getOnlyChanged) {
      allTablesData.where((filter) => filter.changed.equals(true));
    }

    final allTablesDataResult = await allTablesData.get();

    return allTablesDataResult.map(TableModel.fromDbTable).toList();
  }

  Future<OrderTableDbTableData?> _findTable(final String tableId) async {
    return (_appDatabase.select(
      _appDatabase.orderTableDbTable,
    )..where((element) => element.id.equals(tableId))).getSingleOrNull();
  }

  Future<void> markAsSynced(List<String> ids) async {
    await (_appDatabase.update(
      _appDatabase.orderTableDbTable,
    )..where((t) => t.id.isIn(ids))).write(OrderTableDbTableCompanion(changed: const Value(true)));
  }

  Future<void> deleteAllTables() async =>
      await _appDatabase.delete(_appDatabase.orderTableDbTable).go();
}
