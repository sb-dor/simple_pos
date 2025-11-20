import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/authentication/models/user_model.dart';

@immutable
final class AuthenticationStateModel {
  const AuthenticationStateModel({this.establishment, this.userModel, this.allUserEstablishments});

  final Establishment? establishment;
  final UserModel? userModel;

  final List<Establishment>? allUserEstablishments;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthenticationStateModel &&
          runtimeType == other.runtimeType &&
          establishment == other.establishment &&
          userModel == other.userModel &&
          allUserEstablishments == other.allUserEstablishments);

  @override
  int get hashCode => establishment.hashCode ^ userModel.hashCode ^ allUserEstablishments.hashCode;

  @override
  String toString() => 'AuthenticationStateModel{'
        ' establishment: $establishment,'
        ' userModel: $userModel,'
        ' allUserEstablishments: $allUserEstablishments'
        '}';

  AuthenticationStateModel copyWith({
    ValueGetter<UserModel?>? userModel,
    ValueGetter<Establishment?>? establishment,
    ValueGetter<List<Establishment>?>? allUserEstablishments,
  }) => AuthenticationStateModel(
      userModel: userModel != null ? userModel() : this.userModel,
      establishment: establishment != null ? establishment() : this.establishment,
      allUserEstablishments: allUserEstablishments != null
          ? allUserEstablishments()
          : this.allUserEstablishments,
    );
}
