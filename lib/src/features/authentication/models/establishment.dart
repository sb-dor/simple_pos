class Establishment {
  final String? id;
  final String? name;
  final String? documentId;

  const Establishment({this.id, this.name, this.documentId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Establishment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          documentId == other.documentId);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ documentId.hashCode;

  @override
  String toString() {
    return 'Establishment{'
        ' id: $id,'
        ' name: $name,'
        ' documentId: $documentId,'
        '}';
  }

  Establishment copyWith({String? id, String? name, String? documentId}) {
    return Establishment(
      id: id ?? this.id,
      name: name ?? this.name,
      documentId: documentId ?? this.documentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'documentId': documentId};
  }

  factory Establishment.fromMap(final Map<String, Object?> map, {final String? documentId}) {
    return Establishment(
      id: map['id'] as String?,
      name: map['name'] as String?,
      documentId: documentId ?? (map['document_id'] as String?),
    );
  }
}
