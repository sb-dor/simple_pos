import 'package:flutter/foundation.dart';

@immutable
class CategoryModel {
  const CategoryModel({this.id, this.name, this.updatedAt});

  final int? id;
  final String? name;
  final DateTime? updatedAt;

  factory CategoryModel.fromDb(Map<String, dynamic> json) => CategoryModel();
}
