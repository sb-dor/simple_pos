import 'package:drift/drift.dart';

import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';

final class EstablishmentDatabaseHelper {
  EstablishmentDatabaseHelper(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<void> saveEstablishment(Establishment establishment) async {
    if (establishment.id == null) return;

    await _appDatabase.delete(_appDatabase.establishmentTable).go();

    await _appDatabase
        .into(_appDatabase.establishmentTable)
        .insert(
          EstablishmentTableCompanion.insert(
            id: establishment.id!,
            name: Value(establishment.name),
            documentId: Value(establishment.documentId),
          ),
        );
  }

  Future<Establishment?> getEstablishment() async {
    final query = await _appDatabase.select(_appDatabase.establishmentTable).getSingleOrNull();

    if (query == null) return null;

    return Establishment.fromMap(query.toJson(), documentId: query.documentId);
  }

  Future<void> deleteEstablishment() async {
    await _appDatabase.delete(_appDatabase.establishmentTable).go();
  }
}
