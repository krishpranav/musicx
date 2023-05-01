import 'dart:convert';

class Artist {
  // Name, id
  String name;
  String? id;

  // required
  Artist({
    required this.name,
    this.id,
  });

  Artist copyWith({
    String? name,
    String? id,
  }) {
    return Artist(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  // map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  // fromMap[Artist]
  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      name: map['name'] as String,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  // json
  String toJson() => json.encode(toMap());

  // artist from jsoj
  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  // to string
  @override
  String toString() => 'Artist(name: $name, id: $id)';

  // operator
  @override
  bool operator ==(covariant Artist other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  // hashcode
  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
