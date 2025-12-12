class QaimeBaxDto {
  int id;
  String? ad;
  String? barkod;
  int? miqdar;
  double? qiymet;
  String? qeyd;
  int? nov;

  QaimeBaxDto({
    required this.id,
    this.ad,
    this.barkod,
    this.miqdar,
    this.qiymet,
    this.qeyd,
    this.nov,
  });

  factory QaimeBaxDto.fromJson(Map<String, dynamic> json) {
    return QaimeBaxDto(
      id: json['id'],
      ad: json['ad'],
      barkod: json['barkod'],
      miqdar: (json['miqdar'] as num?)?.toInt(),
      qiymet: (json['qiymet'] as num?)?.toDouble(),
      qeyd: json['qeyd'],
      nov: json['nov'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'barkod': barkod,
      'miqdar': miqdar,
      'qiymet': qiymet,
      'qeyd': qeyd,
      'nov': nov,
    };
  }
}
