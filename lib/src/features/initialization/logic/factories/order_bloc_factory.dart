import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_repo.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_source.dart';

final class OrderBlocFactory extends Factory<OrderFeatureBloc> {
  OrderBlocFactory({required final AppDatabase appDatabase, required final Logger logger})
    : _appDatabase = appDatabase,
      _logger = logger;

  final AppDatabase _appDatabase;
  final Logger _logger;

  @override
  OrderFeatureBloc create() {
    final IOrderFeatureSource datasource = OrderFeatureSourceImpl(
      appDatabase: _appDatabase,
      logger: _logger,
    );

    final IOrderFeatureRepo repo = OrderFeatureRepoImpl(datasource);

    return OrderFeatureBloc(repository: repo);
  }
}
