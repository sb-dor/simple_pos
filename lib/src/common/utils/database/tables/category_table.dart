import 'package:drift/drift.dart';

class CategoryTable extends Table {

  TextColumn get id => text()();

  TextColumn get establishmentId => text().nullable()();

  TextColumn get name => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  IntColumn get colorValue => integer().nullable()();

  BoolColumn get changed => boolean().withDefault(Variable(false))();
}
