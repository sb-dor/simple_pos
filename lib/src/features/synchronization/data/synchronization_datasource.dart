import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

abstract interface class ISynchronizationDatasource {
  Future<bool> tableSync({required final Establishment establishment});

  Future<bool> categorySync({required final Establishment establishment});
}

final class SynchronizationDatasourceImpl implements ISynchronizationDatasource {
  SynchronizationDatasourceImpl({
    required final FirebaseFirestore firebaseStore,
    required final OrderTableDbTableHelper orderTableDbTableHelper,
    required final AppDatabase appDatabase,
    required final Logger logger,
  }) : _orderTableDbTableHelper = orderTableDbTableHelper,
       _appDatabase = appDatabase,
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

  final OrderTableDbTableHelper _orderTableDbTableHelper;
  final AppDatabase _appDatabase;
  final Logger _logger;

  late final CollectionReference<Establishment> _establishmentRef;

  @override
  Future<bool> tableSync({required final Establishment establishment}) async {
    _logger.log(Level.debug, "Establishment document id: ${establishment.documentId}");

    final establishmentRef = _establishmentRef.doc(establishment.documentId);

    final tablesRef = establishmentRef
        .collection('tables')
        .withConverter(
          fromFirestore: (doc, _) => TableModel.fromJson(doc.data() ?? {}),
          toFirestore: (value, _) => value.toMap(),
        );

    final localChangedTables = await _orderTableDbTableHelper.tables(getOnlyChanged: true);

    if (localChangedTables.isNotEmpty) {
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
      await _orderTableDbTableHelper.save(table.copyWith(changed: false));
    }

    return true;
  }

  @override
  Future<bool> categorySync({required final Establishment establishment}) async {
    final establishmentRef = _establishmentRef.doc(establishment.documentId);

    final categoriesRef = establishmentRef
        .collection('categories')
        .withConverter(
          fromFirestore: (doc, _) => CategoryModel.fromJson(doc.data() ?? {}),
          toFirestore: (value, _) => value.toJson(),
        );

    final localChangedCategories = (await (_appDatabase.select(
      _appDatabase.categoryTable,
    )..where((el) => el.changed.equals(true))).get()).map(CategoryModel.fromDbTable);

    if (localChangedCategories.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();

      for (final each in localChangedCategories) {
        final docRef = categoriesRef.doc(each.id);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          batch.update(docRef, each.toJson());
        } else {
          batch.set(docRef, each);
        }
      }

      await batch.commit();
    }

    await (_appDatabase.update(_appDatabase.categoryTable)
          ..where((t) => t.id.isIn(localChangedCategories.map((e) => e.id ?? '').toList())))
        .write(CategoryTableCompanion(changed: const Value(true)));

    final remoteSnapshot = await categoriesRef.get();

    final remoteCategories = remoteSnapshot.docs.map((d) => d.data()).toList();

    _logger.log(Level.info, "Remote categories: $remoteCategories");

    if (remoteCategories.isEmpty) return true;

    for (final category in remoteCategories) {
      if (category.id == null) continue;
      final findTable = await (_appDatabase.select(
        _appDatabase.categoryTable,
      )..where((element) => element.id.equals(category.id!))).getSingleOrNull();
      if (findTable == null) {
        await (_appDatabase
            .into(_appDatabase.categoryTable)
            .insert(category.toDbCategoryCompanion()));
      } else {
        await (_appDatabase.update(_appDatabase.categoryTable)
              ..where((element) => element.id.equals(category.id!)))
            .write(category.toDbCategoryCompanion());
      }
    }

    return true;
  }
}
