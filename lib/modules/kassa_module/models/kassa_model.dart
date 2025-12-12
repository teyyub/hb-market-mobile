class Kassa {
  final int id;
  final String ad;
  final double? money;
  final String? aktiv;

  Kassa({required this.id, required this.ad, this.money, this.aktiv});

  factory Kassa.fromJson(Map<String, dynamic> json) {
    return Kassa(
      id: json['id'] as int,
      ad: json['ad'] as String,
      money: json['pul'] as double ,
      aktiv: json['aktiv']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Kassa(id: $id, ad: $ad)';
  }
}
