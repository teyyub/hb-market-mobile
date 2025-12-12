class Qeyd {
  final int id;
  final String ad;

  Qeyd({required this.id, required this.ad});

  factory Qeyd.fromJson(Map<String, dynamic> json) {
    return Qeyd(id: json['id'] as int, ad: json['ad'] as String);
  }

  @override
  String toString() {
    return 'Qeyd(id: $id, ad: $ad)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Qeyd) return false;
    if (id != 0 && other.id != 0) return id == other.id;
    return ad == other.ad; // compare text for virtual items
  }

  @override
  int get hashCode => id != 0 ? id.hashCode : ad.hashCode;
}
