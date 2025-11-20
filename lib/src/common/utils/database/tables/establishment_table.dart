import 'package:drift/drift.dart';

class EstablishmentTable extends Table {
  TextColumn get id => text().unique()();

  TextColumn get name => text().nullable()();

  TextColumn get documentId => text().named('document_id').nullable()();
}
