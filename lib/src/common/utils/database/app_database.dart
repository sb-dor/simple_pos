import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.steps.dart';
import 'package:test_pos_app/src/common/utils/database/tables/category_table.dart';
import 'package:test_pos_app/src/common/utils/database/tables/customer_invoice_details_table.dart';
import 'package:test_pos_app/src/common/utils/database/tables/customer_invoices_table.dart';
import 'package:test_pos_app/src/common/utils/database/tables/establishment_table.dart';
import 'package:test_pos_app/src/common/utils/database/tables/order_table_db_table.dart';
import 'package:test_pos_app/src/common/utils/database/tables/products_categories_table.dart';
import 'package:test_pos_app/src/common/utils/database/tables/products_table.dart';

part 'app_database.g.dart';

// REMEMBER IT'S BETTER TO NAME YOUR TABLES COLUMN AT FIRST RATHER THEN CHANGING THEM IN THE FUTURE
@DriftDatabase(
  tables: [
    CustomerInvoicesTable,
    CustomerInvoiceDetailsTable,
    EstablishmentTable,
    OrderTableDbTable,
    CategoryTable,
    ProductsCategoriesTable,
    ProductsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults({required String name})
    : super(
        driftDatabase(
          name: name,
          native: const DriftNativeOptions(shareAcrossIsolates: true),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await m.runMigrationSteps(
          from: from,
          to: to,
          steps: migrationSteps(
            from1To2: (m, schema) async {
              await m.addColumn(orderTableDbTable, orderTableDbTable.changed);
            },
            from2To3: (Migrator m, Schema3 schema) async {
              await m.addColumn(orderTableDbTable, orderTableDbTable.establishmentId);
            },
            from3To4: (Migrator m, Schema4 schema) async {
              await m.createTable(categoryTable);
            },
            from4To5: (Migrator m, Schema5 schema) async {
              await m.createTable(productsCategoriesTable);
              await m.createTable(productsTable);

              await m.alterTable(
                TableMigration(
                  schema.customerInvoicesDetails,
                  columnTransformer: {
                    customerInvoiceDetailsTable.productId: customerInvoiceDetailsTable.productId
                        .cast<String>(),
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
