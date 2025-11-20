// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  // driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  // late SchemaVerifier verifier;
  //
  // setUpAll(() {
  //   verifier = SchemaVerifier(GeneratedHelper());
  // });
  //
  // group('simple database migrations', () {
  //   // These simple tests verify all possible schema updates with a simple (no
  //   // data) migration. This is a quick way to ensure that written database
  //   // migrations properly alter the schema.
  //   const versions = GeneratedHelper.versions;
  //   for (final (i, fromVersion) in versions.indexed) {
  //     group('from $fromVersion', () {
  //       for (final toVersion in versions.skip(i + 1)) {
  //         test('to $toVersion', () async {
  //           final schema = await verifier.schemaAt(fromVersion);
  //           final db = AppDatabase(schema.newConnection());
  //           await verifier.migrateAndValidate(db, toVersion);
  //           await db.close();
  //         });
  //       }
  //     });
  //   }
  // });
  //
  // // The following template shows how to write tests ensuring your migrations
  // // preserve existing data.
  // // Testing this can be useful for migrations that change existing columns
  // // (e.g. by alterating their type or constraints). Migrations that only add
  // // tables or columns typically don't need these advanced tests. For more
  // // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // // TODO: This generated template shows how these tests could be written. Adopt
  // // it to your own needs when testing migrations with data integrity.
  // test('migration from v1 to v2 does not corrupt data', () async {
  //   // Add data to insert into the old database, and the expected rows after the
  //   // migration.
  //   // TODO: Fill these lists
  //   final oldCustomerInvoicesData = <v1.CustomerInvoicesData>[];
  //   final expectedNewCustomerInvoicesData = <v2.CustomerInvoicesData>[];
  //
  //   final oldCustomerInvoicesDetailsData = <v1.CustomerInvoicesDetailsData>[];
  //   final expectedNewCustomerInvoicesDetailsData =
  //       <v2.CustomerInvoicesDetailsData>[];
  //
  //   final oldEstablishmentTableData = <v1.EstablishmentTableData>[];
  //   final expectedNewEstablishmentTableData = <v2.EstablishmentTableData>[];
  //
  //   final oldOrderTableDbTableData = <v1.OrderTableDbTableData>[];
  //   final expectedNewOrderTableDbTableData = <v2.OrderTableDbTableData>[];
  //
  //   await verifier.testWithDataIntegrity(
  //     oldVersion: 1,
  //     newVersion: 2,
  //     createOld: v1.DatabaseAtV1.new,
  //     createNew: v2.DatabaseAtV2.new,
  //     openTestedDatabase: AppDatabase.new,
  //     createItems: (batch, oldDb) {
  //       batch.insertAll(oldDb.customerInvoices, oldCustomerInvoicesData);
  //       batch.insertAll(
  //         oldDb.customerInvoicesDetails,
  //         oldCustomerInvoicesDetailsData,
  //       );
  //       batch.insertAll(oldDb.establishmentTable, oldEstablishmentTableData);
  //       batch.insertAll(oldDb.orderTableDbTable, oldOrderTableDbTableData);
  //     },
  //     validateItems: (newDb) async {
  //       expect(
  //         expectedNewCustomerInvoicesData,
  //         await newDb.select(newDb.customerInvoices).get(),
  //       );
  //       expect(
  //         expectedNewCustomerInvoicesDetailsData,
  //         await newDb.select(newDb.customerInvoicesDetails).get(),
  //       );
  //       expect(
  //         expectedNewEstablishmentTableData,
  //         await newDb.select(newDb.establishmentTable).get(),
  //       );
  //       expect(
  //         expectedNewOrderTableDbTableData,
  //         await newDb.select(newDb.orderTableDbTable).get(),
  //       );
  //     },
  //   );
  // });
}
