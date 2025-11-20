import 'package:flutter/foundation.dart';

@immutable
class WaiterModel {
  const WaiterModel({this.id, this.name});

  final int? id;
  final String? name;

  factory WaiterModel.fromDb(Map<String, Object?> db) =>
      WaiterModel(id: db['id'] as int?, name: db['name'] as String?);
}
