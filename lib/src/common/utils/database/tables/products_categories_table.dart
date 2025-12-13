import 'package:drift/drift.dart';

class ProductsCategoriesTable extends Table {
  TextColumn get id => text()();

  TextColumn get productId => text().nullable()();

  TextColumn get categoryId => text().nullable()();

  BoolColumn get changed => boolean().nullable()();
}
