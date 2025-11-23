import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:l/l.dart';

import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/establishment_database_helper.dart';
import 'package:test_pos_app/src/common/utils/database/database_helpers/order_table_db_table_helper.dart';
import 'package:test_pos_app/src/common/utils/key_value_storage/shared_preferences_service.dart';
import 'package:test_pos_app/src/features/authentication/models/authentication_response_model.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/authentication/models/user_model.dart';

abstract interface class IAuthenticationDatasource {
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

final class AuthenticationDatasourceImpl implements IAuthenticationDatasource {
  AuthenticationDatasourceImpl({
    required final FirebaseFirestore firebaseStore,
    required final SharedPreferencesService sharedPreferencesService,
    required final EstablishmentDatabaseHelper establishmentDatabaseHelper,
    required final OrderTableDbTableHelper orderTableDbTableHelper,
  }) : _sharedPreferencesService = sharedPreferencesService,
       _establishmentDatabaseHelper = establishmentDatabaseHelper,
       _orderTableDbTableHelper = orderTableDbTableHelper {
    _usersRef = firebaseStore
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromMap(
            snapshot.data() ?? {},
            documentId: snapshot.id, // document id -> for deletion and update
          ),
          toFirestore: (user, _) => user.toMap(),
        );

    _establishmentRef = firebaseStore
        .collection('establishments')
        .withConverter<Establishment>(
          fromFirestore: (snapshot, _) =>
              Establishment.fromMap(snapshot.data() ?? {}, documentId: snapshot.id),
          toFirestore: (establishment, _) => establishment.toMap(),
        );
  }

  final SharedPreferencesService _sharedPreferencesService;
  final EstablishmentDatabaseHelper _establishmentDatabaseHelper;
  final OrderTableDbTableHelper _orderTableDbTableHelper;

  late final CollectionReference<UserModel> _usersRef;
  late final CollectionReference<Establishment> _establishmentRef;

  @override
  Future<AuthenticationResponseModel> user() async {
    final userId = _sharedPreferencesService.getString(userUUIDKey);

    if (userId == null) {
      return AuthenticationResponseModel(message: messageUserDoesNotExist);
    }

    final establishments = <Establishment>[];

    final users = await _usersRef.where('id', isEqualTo: userId).limit(1).get();

    l.d(users);

    final user = users.docs.firstOrNull?.data();

    final localEstablishment = await _establishmentDatabaseHelper.getEstablishment();

    if (localEstablishment == null) {
      final firebaseEstablishments = await _establishmentRef
          .where('id', whereIn: user?.establishmentIds ?? <int>[])
          .get();

      if (firebaseEstablishments.docs.isNotEmpty) {
        establishments.addAll(firebaseEstablishments.docs.map((element) => element.data()));
      }
    } else {
      establishments.add(localEstablishment);
    }

    l.d('login establishemnt: $localEstablishment | $establishments');

    final message = user == null ? messageUserDoesNotExist : null;

    return AuthenticationResponseModel(
      message: message,
      userModel: user,
      establishments: establishments,
    );
  }

  @override
  Future<bool> registerUser({
    required final UserModel user,
    required final Establishment establishment,
  }) async {
    final findUser = await _usersRef
        .where('email', isEqualTo: user.email)
        .where('password', isEqualTo: user.password)
        .limit(1)
        .get();

    l.d('finding user in server: ${findUser.docs.firstOrNull}');

    final establishmentIds = <String>[...user.establishmentIds!];

    if (findUser.docs.isNotEmpty) {
      establishmentIds.insertAll(0, findUser.docs.first.data().establishmentIds ?? <String>[]);
    }

    final newUser = user.copyWith(establishmentIds: establishmentIds);

    final establishmentRef = await _establishmentRef.add(establishment);
    final createdEs = establishment.copyWith(documentId: establishmentRef.id);

    await saveEstablishment(establishment: createdEs);

    // l.d( "creating user: $user | from firebase ${findUser.docs.first}");

    if (findUser.docs.isNotEmpty) {
      await _usersRef.doc(findUser.docs.first.id).update(newUser.toMap());
    } else {
      await _usersRef.add(newUser);
    }

    if (user.id != null) {
      await _sharedPreferencesService.saveString(userUUIDKey, user.id!);
    }

    return true;
  }

  @override
  Future<AuthenticationResponseModel> login({
    required final String email,
    required final String password,
  }) async {
    final establishments = <Establishment>[];

    final users = await _usersRef
        .where('email', isEqualTo: email.trim())
        .where('password', isEqualTo: password.trim())
        .get();

    final user = users.docs.firstOrNull?.data();

    if (user != null && (user.establishmentIds ?? <String>[]).isNotEmpty) {
      final establishmentsData = await _establishmentRef
          .where('id', whereIn: user.establishmentIds ?? <String>[])
          .get();
      establishments.addAll(
        establishmentsData.docs.map((element) {
          final establishment = element.data().copyWith(documentId: element.id);
          return establishment;
        }),
      );
    }

    l.d('login data: $user | establishements: ${establishments.length}');

    if (user?.id != null) {
      await _sharedPreferencesService.saveString(userUUIDKey, user!.id!);
    }

    final message = user == null ? messageUserDoesNotExist : null;

    return AuthenticationResponseModel(
      message: message,
      userModel: user,
      establishments: establishments,
    );
  }

  @override
  Future<void> saveEstablishment({required Establishment establishment}) =>
      _establishmentDatabaseHelper.saveEstablishment(establishment);

  @override
  Future<bool> logout() async {
    await _sharedPreferencesService.remove(userUUIDKey);
    await _establishmentDatabaseHelper.deleteEstablishment();
    await _orderTableDbTableHelper.deleteAllTables();
    return true;
  }
}
