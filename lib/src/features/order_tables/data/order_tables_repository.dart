import 'dart:async';

import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/features/order_tables/data/order_tables_datasource.dart';

abstract interface class IOrderTablesRepository {
  FutureOr<List<TableModel>> tables({int page = 1});
}

final class OrderTablesRepositoryImpl implements IOrderTablesRepository {
  OrderTablesRepositoryImpl(this._iOrderTablesDatasource);

  final IOrderTablesDatasource _iOrderTablesDatasource;

  @override
  FutureOr<List<TableModel>> tables({int page = 1}) => _iOrderTablesDatasource.tables(page: page);
}
