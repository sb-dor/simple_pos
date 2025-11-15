import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/authentication/data/authentication_datasource.dart';
import 'package:test_pos_app/src/features/authentication/models/authentication_response_model.dart';
import 'package:test_pos_app/src/features/authentication/models/user_model.dart';

/// Abstract interface for the authentication repository.
/// Defines methods for fetching the current user, registering a new user,
/// logging in, saving the selected establishment, and logging out.
abstract interface class IAuthenticationRepository {
  /// Retrieves the current authenticated user.
  /// Returns an [AuthenticationResponseModel] containing user data and associated establishments.
  Future<AuthenticationResponseModel> user();

  /// Registers a new user along with an associated establishment.
  ///
  /// [user] — the data of the new user to register.
  /// [establishment] — the establishment associated with the new user.
  /// Returns [bool] indicating whether registration was successful.
  Future<bool> registerUser({
    required final UserModel user,
    required final Establishment establishment,
  });

  /// Logs in a user with the provided credentials.
  ///
  /// [email] — the user's email.
  /// [password] — the user's password.
  /// Returns an [AuthenticationResponseModel] containing user data and associated establishments.
  Future<AuthenticationResponseModel> login({
    required final String email,
    required final String password,
  });

  /// Saves the establishment selected by the user.
  ///
  /// [establishment] — the establishment to save as the active one.
  Future<void> saveEstablishment({required final Establishment establishment});

  /// Logs out the current user from the system.
  /// Returns [bool] indicating whether logout was successful.
  Future<bool> logout();
}

/// Concrete implementation of [IAuthenticationRepository] that delegates
/// operations to an [IAuthenticationDatasource].
final class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  /// Constructs the repository with a given authentication data source.
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
