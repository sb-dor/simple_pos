import 'dart:ui';
import 'package:flutter/foundation.dart';

@immutable
class CategoryModel {
  const CategoryModel({this.id, this.name, this.updatedAt, this.color, this.changed = false});

  factory CategoryModel.fromDb(Map<String, dynamic> json) => CategoryModel();

  final int? id;
  final String? name;
  final DateTime? updatedAt;
  final Color? color;
  final bool changed;

  CategoryModel copyWith({
    int? id,
    ValueGetter<String?>? name,
    ValueGetter<DateTime?>? updatedAt,
    ValueGetter<Color?>? color,
    bool? changed,
  }) => CategoryModel(
    id: id ?? this.id,
    name: name != null ? name() : this.name,
    updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
    color: color != null ? color() : this.color,
    changed: changed ?? this.changed,
  );
}
