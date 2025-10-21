class TempColorModel {
  TempColorModel({this.id, this.name, this.code});

  final int? id;
  final String? name;
  final String? code;

  factory TempColorModel.fromJson(final Map<String, dynamic> json) {
    return TempColorModel(id: json['id'], name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "code": code};
  }
}
