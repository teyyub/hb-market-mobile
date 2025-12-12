class HereketDto {
  final int id;
  final String name;

  HereketDto({required this.id, required this.name});

  factory HereketDto.fromJson(Map<String, dynamic> json) {
    return HereketDto(id: json['id'] as int, name: json['name'] as String);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HereketDto && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'HereketDto(id: $id, name: $name)';
}
