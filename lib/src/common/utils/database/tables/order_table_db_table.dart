import 'package:drift/drift.dart';

class OrderTableDbTable extends Table {
  TextColumn get id => text()();

  TextColumn get establishmentId => text()();

  TextColumn get name => text().nullable()();

  BoolColumn get vip => boolean().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  IntColumn get colorValue => integer().nullable()();

  BlobColumn get image => blob().nullable()();

  BoolColumn get changed => boolean().withDefault(const Variable(false))();
}
