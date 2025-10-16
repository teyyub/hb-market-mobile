class Report {
  final int id;
  final String name;

  Report({required this.id, required this.name});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(id: json['id'] as int, name: json['name'] as String);
  }

  @override
  String toString() {
    return 'Report(id: $id, name: $name)';
  }
}
