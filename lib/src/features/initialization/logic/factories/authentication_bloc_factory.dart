import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';
import 'package:test_pos_app/src/common/utils/key_value_storage/shared_preferences_service.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/authentication/data/authentication_datasource.dart';
import 'package:test_pos_app/src/features/authentication/data/authentication_repository.dart';
import 'package:test_pos_app/src/features/initialization/logic/dependency_composition/dependency_composition.dart';

final class AuthenticationBlocFactory extends Factory<AuthenticationBloc> {
  AuthenticationBlocFactory({
    required final Logger logger,
    required final SharedPreferencesService sharedPreferencesService,
    required final AppDatabase appDatabase,
  }) : _logger = logger,
       _sharedPreferencesService = sharedPreferencesService,
       _appDatabase = appDatabase;

  final Logger _logger;
  final SharedPreferencesService _sharedPreferencesService;
  final AppDatabase _appDatabase;

  @override
  AuthenticationBloc create() {
    final IAuthenticationDatasource datasource = AuthenticationDatasourceImpl(
      firebaseStore: FirebaseFirestore.instance,
      logger: _logger,
      sharedPreferencesService: _sharedPreferencesService,
      appDatabase: _appDatabase,
    );

    final IAuthenticationRepository repository = AuthenticationRepositoryImpl(datasource);

    return AuthenticationBloc(authenticationRepository: repository);
  }
}
