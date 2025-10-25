import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/establishment_database_helper.dart';
import 'package:test_pos_app/src/features/synchronization/data/synchronization_datasource.dart';

abstract interface class ISynchronizationRepository {
  Future<bool> sync();
}

final class SynchronizationRepositoryImpl implements ISynchronizationRepository {
  SynchronizationRepositoryImpl({
    required final ISynchronizationDatasource synchronizationDatasource,
    required final EstablishmentDatabaseHelper establishmentDatabaseHelper,
    required final Logger logger,
  }) : _establishmentDatabaseHelper = establishmentDatabaseHelper,
       _synchronizationDatasource = synchronizationDatasource;

  final ISynchronizationDatasource _synchronizationDatasource;
  final EstablishmentDatabaseHelper _establishmentDatabaseHelper;

  @override
  Future<bool> sync() async {
    final currentEstablishment = await _establishmentDatabaseHelper.getEstablishment();
    if (currentEstablishment == null || currentEstablishment.id == null) return false;
    final tableSync = await _synchronizationDatasource.tableSync(
      establishment: currentEstablishment,
    );
    if (!tableSync) return false;
    final categorySync = await _synchronizationDatasource.categorySync(
      establishment: currentEstablishment,
    );

    return categorySync;
  }
}
