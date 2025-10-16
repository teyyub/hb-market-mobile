class Kassa {
  final int id;
  final String ad;
  final double money;
  final String aktiv;

  Kassa({
    required this.id,
    required this.ad,
    required this.money,
    required this.aktiv,
  });

  factory Kassa.fromJson(Map<String, dynamic> json) {
    return Kassa(
      id: json['id'] as int,
      ad: json['ad'] as String,
      money: 0.0,
      aktiv: json['aktiv'] as String,
    );
  }

  @override
  String toString() {
    return 'Kassa(id: $id, ad: $ad)';
  }
}
