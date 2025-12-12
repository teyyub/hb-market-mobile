class PulEmeliyyati {
  final int id;
  final String mad;
  final double mebleg;
  final String kad;
  final int kassa;
  final int mus;
  final String? sign;
  final String? sebeb;
  final String? qeyd;
  final String? aktiv;

  PulEmeliyyati({
    required this.id,
    required this.mad,
    required this.mebleg,
    required this.kad,
    required this.kassa,
    required this.mus,
    this.sign,
    this.sebeb,
    this.qeyd,
    this.aktiv,
  });

  // fromJson
  factory PulEmeliyyati.fromJson(Map<String, dynamic> json) {
    return PulEmeliyyati(
      id: json['id'],
      mad: json['mad'] ?? '',
      mebleg: (json['mebleg'] as num).toDouble(),
      sebeb: json['sebeb'] ?? '',
      qeyd: json['qeyd'] ?? '',
      kad: json['kad'] ?? '',
      kassa: json['kassa'] ?? '',
      mus: json['mus'] ?? '',
      sign: json['sign'] ?? '',
      aktiv: json['aktiv'] ?? '',
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
