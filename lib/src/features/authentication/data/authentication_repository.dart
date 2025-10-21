import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/authentication/data/authentication_datasource.dart';
import 'package:test_pos_app/src/features/authentication/models/authentication_response_model.dart';
import 'package:test_pos_app/src/features/authentication/models/user_model.dart';

abstract interface class IAuthenticationRepository {
  Future<AuthenticationResponseModel> user();

  Future<bool> registerUser({
    required final UserModel user,
    required final Establishment establishment,
  });

  Future<AuthenticationResponseModel> login({
    required final String email,
    required final String password,
  });

  Future<void> saveEstablishment({required final Establishment establishment});

  Future<bool> logout();
}

final class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  AuthenticationRepositoryImpl(this._iAuthenticationDatasource);

  final IAuthenticationDatasource _iAuthenticationDatasource;

  @override
  Future<AuthenticationResponseModel> user() => _iAuthenticationDatasource.user();

  @override
  Future<bool> registerUser({
    required final UserModel user,
    required final Establishment establishment,
  }) => _iAuthenticationDatasource.registerUser(user: user, establishment: establishment);

  @override
  Future<AuthenticationResponseModel> login({
    required final String email,
    required final String password,
  }) => _iAuthenticationDatasource.login(email: email, password: password);

  @override
  Future<void> saveEstablishment({required Establishment establishment}) =>
      _iAuthenticationDatasource.saveEstablishment(establishment: establishment);

  @override
  Future<bool> logout() => _iAuthenticationDatasource.logout();
}
