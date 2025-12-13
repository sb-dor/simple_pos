import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:l/l.dart';

import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/products_of_category/models/product_of_category.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

abstract interface class ISynchronizationDatasource {
  Future<bool> tableSync({required final Establishment establishment});

  Future<bool> categorySync({required final Establishment establishment});

  Future<bool> productsSync({required final Establishment establishment});

  Future<bool> productsOfCategoriesSync({required final Establishment establishment});
}

final class SynchronizationDatasourceImpl implements ISynchronizationDatasource {
  SynchronizationDatasourceImpl({
    required final FirebaseFirestore firebaseStore,
    required final OrderTableDbTableHelper orderTableDbTableHelper,
    required final AppDatabase appDatabase,
  }) : _orderTableDbTableHelper = orderTableDbTableHelper,
       _appDatabase = appDatabase {
    _establishmentRef = firebaseStore
        .collection('establishments')
        .withConverter<Establishment>(
          fromFirestore: (snapshot, _) =>
              Establishment.fromMap(snapshot.data() ?? {}, documentId: snapshot.id),
          toFirestore: (value, _) => value.toMap(),
        );
  }

  final OrderTableDbTableHelper _orderTableDbTableHelper;
  final AppDatabase _appDatabase;

  late final CollectionReference<Establishment> _establishmentRef;

  @override
  Future<bool> tableSync({required final Establishment establishment}) async {
    l.d('Establishment document id: ${establishment.documentId}');

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

    l.d('Remote tables: $remoteTables');

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
        .write(const CategoryTableCompanion(changed: Value(true)));

    final remoteSnapshot = await categoriesRef.get();

    final remoteCategories = remoteSnapshot.docs.map((d) => d.data()).toList();

    l.d('Remote categories: $remoteCategories');

    if (remoteCategories.isEmpty) return true;

    for (final category in remoteCategories) {
      if (category.id == null) continue;
      final findTable = await (_appDatabase.select(
        _appDatabase.categoryTable,
      )..where((element) => element.id.equals(category.id!))).getSingleOrNull();
      if (findTable == null) {
        await _appDatabase
            .into(_appDatabase.categoryTable)
            .insert(category.toDbCategoryCompanion());
      } else {
        await (_appDatabase.update(_appDatabase.categoryTable)
              ..where((element) => element.id.equals(category.id!)))
            .write(category.toDbCategoryCompanion());
      }
    }

    return true;
  }

  @override
  Future<bool> productsSync({required Establishment establishment}) async {
    final establishmentRef = _establishmentRef.doc(establishment.documentId);

    final productsRef = establishmentRef
        .collection('products')
        .withConverter(
          fromFirestore: (doc, _) => ProductModel.fromJson(doc.data() ?? {}),
          toFirestore: (value, _) => value.toMap(),
        );

    final localChangedProducts = (await (_appDatabase.select(
      _appDatabase.productsTable,
    )..where((el) => el.changed.equals(true))).get()).map(ProductModel.fromDbTable);

    if (localChangedProducts.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();

      for (final each in localChangedProducts) {
        final docRef = productsRef.doc(each.id);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          batch.update(docRef, each.toMap());
        } else {
          batch.set(docRef, each);
        }
      }

      await batch.commit();
    }

    await (_appDatabase.update(_appDatabase.productsTable)
          ..where((t) => t.id.isIn(localChangedProducts.map((e) => e.id ?? '').toList())))
        .write(const ProductsTableCompanion(changed: Value(true)));

    final remoteSnapshot = await productsRef.get();

    final remoteProducts = remoteSnapshot.docs.map((d) => d.data()).toList();

    l.d('Remote products: $remoteProducts');

    if (remoteProducts.isEmpty) return true;

    for (final product in remoteProducts) {
      if (product.id == null) continue;
      final findTable = await (_appDatabase.select(
        _appDatabase.productsTable,
      )..where((element) => element.id.equals(product.id!))).getSingleOrNull();
      if (findTable == null) {
        await _appDatabase.into(_appDatabase.productsTable).insert(product.toDbProductCompanion());
      } else {
        await (_appDatabase.update(_appDatabase.productsTable)
              ..where((element) => element.id.equals(product.id!)))
            .write(product.toDbProductCompanion());
      }
    }

    return true;
  }

  @override
  Future<bool> productsOfCategoriesSync({required Establishment establishment}) async {
    final establishmentRef = _establishmentRef.doc(establishment.documentId);

    final productOfCategoriesRef = establishmentRef
        .collection('products_of_categories')
        .withConverter(
          fromFirestore: (doc, _) => ProductOfCategory.fromJson(doc.data() ?? {}),
          toFirestore: (value, _) => value.toJson(),
        );

    final localChangedProductsOfCategories = (await (_appDatabase.select(
      _appDatabase.productsCategoriesTable,
    )..where((el) => el.changed.equals(true))).get()).map(ProductOfCategory.fromDbTable);

    if (localChangedProductsOfCategories.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();

      for (final each in localChangedProductsOfCategories) {
        final docRef = productOfCategoriesRef.doc(
          'category_${each.categoryId}_product_${each.productId}',
        );

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          batch.update(docRef, each.toJson());
        } else {
          batch.set(docRef, each);
        }
      }

      await batch.commit();
    }

    await (_appDatabase.update(_appDatabase.productsCategoriesTable)..where(
          (t) => t.id.isIn(localChangedProductsOfCategories.map((e) => e.id ?? '').toList()),
        ))
        .write(const ProductsCategoriesTableCompanion(changed: Value(true)));

    final remoteSnapshot = await productOfCategoriesRef.get();

    final remoteProductsOfCategories = remoteSnapshot.docs.map((d) => d.data()).toList();

    l.d('Remote products of categories: $remoteProductsOfCategories');

    if (remoteProductsOfCategories.isEmpty) return true;

    for (final productOfCategory in remoteProductsOfCategories) {
      if (productOfCategory.productId == null || productOfCategory.categoryId == null) continue;
      final findTable =
          await (_appDatabase.select(_appDatabase.productsCategoriesTable)..where(
                (element) =>
                    element.productId.equals(productOfCategory.productId!) &
                    element.categoryId.equals(productOfCategory.categoryId!),
              ))
              .getSingleOrNull();
      if (findTable == null) {
        await _appDatabase
            .into(_appDatabase.productsCategoriesTable)
            .insert(productOfCategory.toDbProductCategoryCompanion());
      } else {
        await (_appDatabase.update(_appDatabase.productsCategoriesTable)..where(
              (element) =>
                  element.productId.equals(productOfCategory.productId!) &
                  element.categoryId.equals(productOfCategory.categoryId!),
            ))
            .write(productOfCategory.toDbProductCategoryCompanion());
      }
    }

    return true;
  }
}
