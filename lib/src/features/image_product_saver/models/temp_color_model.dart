class TempColorModel {
  TempColorModel({this.id, this.name, this.code});

  factory TempColorModel.fromJson(final Map<String, Object?> json) => TempColorModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
    );

  final int? id;
  final String? name;
  final String? code;

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'code': code};
}
