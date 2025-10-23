import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/establishment_database_helper.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

abstract interface class ISynchronizationRepository {
  Future<bool> tableSync();
}

final class SynchronizationRepositoryImpl implements ISynchronizationRepository {
  SynchronizationRepositoryImpl({
    required final FirebaseFirestore firebaseStore,
    required final EstablishmentDatabaseHelper establishmentDatabaseHelper,
    required final OrderTableDbTableHelper orderTableDbTableHelper,
    required final Logger logger,
  }) : _establishmentDatabaseHelper = establishmentDatabaseHelper,
       _orderTableDbTableHelper = orderTableDbTableHelper,
       _logger = logger {
    _establishmentRef = firebaseStore
        .collection('establishments')
        .withConverter<Establishment>(
          fromFirestore: (snapshot, _) {
            return Establishment.fromMap(snapshot.data() ?? {}, documentId: snapshot.id);
          },
          toFirestore: (value, _) => value.toMap(),
        );
  }

  final EstablishmentDatabaseHelper _establishmentDatabaseHelper;
  final OrderTableDbTableHelper _orderTableDbTableHelper;
  final Logger _logger;

  late final CollectionReference<Establishment> _establishmentRef;

  @override
  Future<bool> tableSync() async {
    final currentEstablishment = await _establishmentDatabaseHelper.getEstablishment();

    _logger.log(Level.info, "Establishment: $currentEstablishment");

    if (currentEstablishment == null || currentEstablishment.documentId == null) return false;

    _logger.log(Level.debug, "Establishment document id: ${currentEstablishment.documentId}");

    final establishmentRef = _establishmentRef.doc(currentEstablishment.documentId);

    final tablesRef = establishmentRef
        .collection('tables')
        .withConverter(
          fromFirestore: (doc, _) => TableModel.fromJson(doc.data() ?? {}),
          toFirestore: (value, _) => value.toMap(),
        );

    final localChangedTables = await _orderTableDbTableHelper.tables(getOnlyChanged: true);

    if (localChangedTables.isNotEmpty) {
      if (localChangedTables.isEmpty) return true;

      // Optional: use WriteBatch for efficiency
      final batch = FirebaseFirestore.instance.batch();

      for (final each in localChangedTables) {
        final docRef = tablesRef.doc(each.id);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          batch.update(docRef, each.toMap());
        } else {
          batch.set(docRef, each);
        }
      }

      await batch.commit();
    }

    await _orderTableDbTableHelper.markAsSynced(localChangedTables.map((e) => e.id ?? '').toList());

    final remoteSnapshot = await tablesRef.get();

    final remoteTables = remoteSnapshot.docs.map((d) => d.data()).toList();

    _logger.log(Level.info, "Remote tables: $remoteTables");

    if (remoteTables.isEmpty) return true;

    for (final table in remoteTables) {
      await _orderTableDbTableHelper.save(table);
    }

    return true;
  }
}
