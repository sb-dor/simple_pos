import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/features/authentication/models/user_role.dart';

@immutable
class UserModel {
  const UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.documentId,
    this.userRole,
    // this.establishment,
    this.establishmentIds,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? documentId;
  final UserRole? userRole;

  // final Establishment? establishment;
  final List<String>? establishmentIds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          documentId == other.documentId &&
          // establishment == other.establishment &&
          establishmentIds == other.establishmentIds);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      documentId.hashCode ^
      // establishment.hashCode ^
      establishmentIds.hashCode;

  @override
  String toString() {
    return 'UserModel{'
        ' id: $id,'
        ' name: $name,'
        ' email: $email,'
        ' password: $password,'
        ' documentId: $documentId'
        // ' establishment: $establishment,'
        ' establishmentIds: $establishmentIds'
        '}';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? documentId,
    UserRole? userRole,
    // Establishment? establishment,
    List<String>? establishmentIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      documentId: documentId ?? this.documentId,
      userRole: userRole ?? this.userRole,
      // establishment: establishment ?? this.establishment,
      establishmentIds: establishmentIds ?? this.establishmentIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      "document_id": documentId,
      "user_role_id": userRole?.userRoleId,
      'establishment_ids': establishmentIds,
    };
  }

  factory UserModel.fromMap(final Map<String, Object?> map, {final String? documentId}) {
    return UserModel(
      id: map['id'] as String?,
      name: map['name'] as String?,
      email: map['email'] as String?,
      password: map['password'] as String?,
      documentId: documentId ?? (map['document_id'] as String?),
      userRole: map['user_role_id'] == null
          ? null
          : UserRoleEx.fromId(int.tryParse("${map['user_role_id']}")),
      establishmentIds: map['establishment_ids'] == null
          ? null
          : (map['establishment_ids'] as List<dynamic>)
                .map((element) => element.toString())
                .toList(),
      // establishment: map['establishment'] == null ? null : Establishment.fromMap(map),
    );
  }
}
