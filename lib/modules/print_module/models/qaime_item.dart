class QaimeItem {
  final String ad;
  final String barkod;
  final double miqdar;
  final double qiymet;
  final double mebleg;

  QaimeItem({
    required this.ad,
    required this.barkod,
    required this.miqdar,
    required this.qiymet,
    required this.mebleg,
  });

  factory QaimeItem.fromJson(Map<String, dynamic> json) {
    return QaimeItem(
      ad: json['ad'],
      barkod: json['barkod'],
      miqdar: json['miqdar'].toDouble(),
      qiymet: json['qiymet'].toDouble(),
      mebleg: json['mebleg'].toDouble(),
    );
  }
}