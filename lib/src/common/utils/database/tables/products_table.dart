import 'package:drift/drift.dart';

class ProductsTable extends Table {
  TextColumn get id => text().nullable()();

  TextColumn get productType => text().nullable()();

  TextColumn get name => text().nullable()();

  RealColumn get price => real().nullable()();

  RealColumn get wholesalePrice => real().nullable()();

  RealColumn get packQty => real().nullable()();

  TextColumn get barcode => text().nullable()();

  BoolColumn get visible => boolean().withDefault(const Constant(true))();

  BoolColumn get changed => boolean().withDefault(const Constant(false))();

  BlobColumn get imageData => blob().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();
}
