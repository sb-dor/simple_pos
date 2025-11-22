import 'dart:ui';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';

@immutable
class CategoryModel {
  const CategoryModel({
    this.id,
    this.establishmentId,
    this.name,
    this.updatedAt,
    this.color,
    this.changed = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    Color? color;
    if (json['color'] != null) {
      color = Color(json['color'] as int);
    }
    return CategoryModel(
      id: json['id'] as String?,
      establishmentId: json['establishment_id'] as String?,
      name: json['name'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse("${json['updated_at']}") : null,
      color: color,
      changed: bool.tryParse("${json['changed']}") ?? false,
    );
  }

  factory CategoryModel.fromDbTable(CategoryTableData? db) {
    Color? color;
    if (db?.colorValue != null) {
      color = Color(db!.colorValue!);
    }
    return CategoryModel(
      id: db?.id,
      establishmentId: db?.establishmentId,
      name: db?.name,
      updatedAt: db?.updatedAt,
      color: color,
      changed: db?.changed ?? false,
    );
  }

  final String? id;
  final String? establishmentId;
  final String? name;
  final DateTime? updatedAt;
  final Color? color;
  final bool changed;

  CategoryModel copyWith({
    String? id,
    ValueGetter<String?>? establishmentId,
    ValueGetter<String?>? name,
    ValueGetter<DateTime?>? updatedAt,
    ValueGetter<Color?>? color,
    bool? changed,
  }) => CategoryModel(
    id: id ?? this.id,
    establishmentId: establishmentId != null ? establishmentId() : this.establishmentId,
    name: name != null ? name() : this.name,
    updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
    color: color != null ? color() : this.color,
    changed: changed ?? this.changed,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'establishment_id': establishmentId,
    'name': name,
    'updated_at': updatedAt,
    'color': color?.toARGB32(),
    'changed': changed,
  };

  CategoryTableCompanion toDbCategoryCompanion() => CategoryTableCompanion(
    id: Value.absentIfNull(id),
    establishmentId: Value.absentIfNull(establishmentId),
    name: Value(name),
    updatedAt: Value(updatedAt),
    colorValue: Value(color?.toARGB32()),
    changed: const Value(false),
  );
}
