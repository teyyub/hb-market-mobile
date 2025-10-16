class Obyekt {
  final int id;
  final String name;
  final String? email;
  final String? type;

  const Obyekt({required this.id, required this.name, this.email, this.type});

  factory Obyekt.fromJson(Map<String, dynamic> json) {
    return Obyekt(id: json['id'] as int, name: json['name'] as String);
  }

  static const empty = Obyekt(id: -1, name: '', email: null, type: null);

  bool get isEmpty => id == -1 || name.isEmpty;

  @override
  String toString() {
    return 'Obyect(id: $id, name: $name)';
  }
}
