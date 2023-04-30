import 'dart:convert';

class Album {
  // name, id
  String name;
  String id;

  Album({
    required this.name,
    required this.id,
  });

  Album copyWith({
    String? name,
    String? id,
  }) {
    return Album(
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

  // album map
  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  // to json
  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  // to string
  @override
  String toString() => 'Album(name: $name, id: $id)';

  @override
  bool operator ==(covariant Album other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  // get hashcode
  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
