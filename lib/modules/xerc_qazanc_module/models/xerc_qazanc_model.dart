class XercQazanc {
  final int id;
  final String mad;
  final int musId;
  final double mebleg;
  final double? oden;
  final int kassa;
  final String kad;
  final String? sebeb;
  final String? qeyd;
  final int? xkat;
  final String? xkatAd;
  final int? xakat;
  final String? xakatAd;
  final String? sign;
  final String? aktiv;

  XercQazanc({
    required this.id,
    required this.mad,
    required this.musId,
    required this.mebleg,
    this.oden,
    required this.kassa,
    required this.kad,
    this.sebeb,
    this.qeyd,
    this.xkat,
    this.xkatAd,
    this.xakat,
    this.xakatAd,
    this.sign,
    this.aktiv,
  });

  // fromJson
  factory XercQazanc.fromJson(Map<String, dynamic> json) {
    return XercQazanc(
      id: json['id'],
      mad: json['mad'],
      musId: json['mus'],
      mebleg: (json['mebleg'] as num).toDouble(),
      oden: (json['oden'] as num?)?.toDouble(),
      sebeb: json['sebeb'] ?? '',
      qeyd: json['qeyd'] ?? '',
      kad: json['kad'] ?? '',
      kassa: json['kassa'],
      xkat: json['xkat'],
      xkatAd: json['xkatAd'] ?? '',
      xakat: json['xakat'],
      xakatAd: json['xakatAd'] ?? '',
      sign: json['sign'] ?? '',
      aktiv: json['aktiv'] ?? '',
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mad': mad,
      'mus': musId,
      'mebleg': mebleg,
      'oden': oden,
      'kassa': kassa,
      'kad': kad,
      'sebeb': sebeb,
      'qeyd': qeyd,
      'xkat': xkat,
      'xkatAd': xkatAd,
      'xakat': xakat,
      'xakatAd': xakatAd,
      'sign': sign,
      'aktiv': aktiv,
    };
  }

  @override
  String toString() {
    return 'XercQazanc('
        'id: $id, '
        'mad: $mad, '
        'musId: $musId, '
        'mebleg: $mebleg, '
        'oden: $oden ?? '
        ', '
        'kassa: $kassa, '
        'kad: $kad, '
        'sebeb: $sebeb, '
        'qeyd: $qeyd, '
        'xkat: $xkat, '
        'xkatAd: $xkatAd, '
        'xakat: $xakat?? '
        ', '
        'xakatAd: $xakatAd??'
        ', '
        'sign: $sign, '
        'aktiv: $aktiv'
        ')';
  }
}
