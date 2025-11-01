import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_pos_app/src/common/utils/database/app_database.dart';

@immutable
class TableModel {
  const TableModel({
    this.id,
    this.establishmentId,
    this.name,
    this.vip,
    this.icon,
    this.color,
    this.updatedAt,
    this.imageData,
    this.changed = false,
  });

  final String? id;
  final String? establishmentId;
  final String? name;
  final bool? vip;
  final DateTime? updatedAt;
  final Uint8List? imageData;

  final Widget? icon;
  final Color? color;
  final bool changed;

  factory TableModel.fromDbTable(OrderTableDbTableData db) {
    Color? color;
    if (db.colorValue != null) {
      color = Color(db.colorValue!);
    }
    return TableModel(
      id: db.id,
      establishmentId: db.establishmentId,
      name: db.name,
      vip: db.vip,
      updatedAt: db.updatedAt,
      imageData: db.image,
      color: color,
      changed: db.changed,
    );
  }

  factory TableModel.fromJson(final Map<String, Object?> json) {
    Color? color;
    if (json['color'] != null) {
      color = Color(json['color'] as int);
    }
    return TableModel(
      id: json['id'] as String?,
      establishmentId: json['establishment_id'] as String?,
      name: json['name'] as String?,
      vip: json['vip'] as bool?,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse("${json['updated_at']}") : null,
      imageData: json['image'] != null ? Uint8List.fromList((json['image'] as List).cast()) : null,
      color: color,
      changed: bool.tryParse("${json['changed']}") ?? false,
    );
  }

  TableModel copyWith({
    String? id,
    ValueGetter<String?>? establishmentId,
    ValueGetter<String?>? name,
    ValueGetter<bool?>? vip,
    ValueGetter<DateTime?>? updatedAt,
    ValueGetter<Uint8List?>? imageData,
    ValueGetter<Widget?>? icon,
    ValueGetter<Color?>? color,
    bool? changed,
  }) {
    return TableModel(
      id: id ?? this.id,
      establishmentId: establishmentId != null ? establishmentId() : this.establishmentId,
      name: name != null ? name() : this.name,
      vip: vip != null ? vip() : this.vip,
      updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
      imageData: imageData != null ? imageData() : this.imageData,
      icon: icon != null ? icon() : this.icon,
      color: color != null ? color() : this.color,
      changed: changed ?? false,
    );
  }

  OrderTableDbTableCompanion toDbTableCompanion({bool changed = false}) =>
      OrderTableDbTableCompanion(
        id: Value.absentIfNull(id),
        establishmentId: Value.absentIfNull(establishmentId),
        name: Value(name),
        vip: Value(vip),
        updatedAt: Value(updatedAt),
        image: Value(imageData),
        colorValue: Value(color?.toARGB32()),
        changed: Value(changed),
      );

  Map<String, Object?> toMap() => {
    'id': id,
    'establishment_id': establishmentId,
    'name': name,
    'vip': vip,
    'updated_at': updatedAt,
    'image': imageData,
    'color': color?.toARGB32(),
    "changed": changed,
  };
}
