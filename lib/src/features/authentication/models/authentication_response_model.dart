import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/authentication/models/user_model.dart';

final class AuthenticationResponseModel {
  AuthenticationResponseModel({this.message, this.userModel, this.establishments});

  final String? message;
  final UserModel? userModel;
  final List<Establishment>? establishments;
}
