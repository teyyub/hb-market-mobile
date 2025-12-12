class Partnyor {
  final int id;
  final String ad;
  final double borc;
  final String tip;
  final String aktiv;

  Partnyor({
    required this.id,
    required this.ad,
    required this.borc,
    required this.tip,
    required this.aktiv,
  });

  // fromJson
  factory Partnyor.fromJson(Map<String, dynamic> json) {
    return Partnyor(
      id: json['id'],
      ad: json['ad'],
      borc: (json['borc'] as num).toDouble(),
      tip: json['tip'],
      aktiv: json['aktiv'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {'id': id, 'ad': ad, 'borc': borc, 'tip': tip, 'aktiv': aktiv};
  }

  // toString (for debugging)
  @override
  String toString() {
    return 'Partnyor(id: $id, ad: $ad, borc: $borc, tip: $tip, aktiv: $aktiv)';
  }

  // Add equality based on id
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Partnyor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
