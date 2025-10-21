import 'dart:async';

import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/features/table_creation/data/table_creation_datasource.dart';

abstract interface class ITableCreationRepository {
  FutureOr<TableModel?> table(final String tableId);

  FutureOr<bool> save(final TableModel tableModel);
}

final class TableCreationRepositoryImpl implements ITableCreationRepository {
  TableCreationRepositoryImpl(this._iTableCreationDatasource);

  final ITableCreationDatasource _iTableCreationDatasource;

  @override
  FutureOr<TableModel?> table(String tableId) => _iTableCreationDatasource.table(tableId);

  @override
  FutureOr<bool> save(TableModel tableModel) => _iTableCreationDatasource.save(tableModel);
}
