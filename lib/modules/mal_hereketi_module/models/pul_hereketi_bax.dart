class MalHereketiBaxDto {
  final int id;
  final String? nAd;
  final String? seri;
  final int? miqdar;
  final double? qiymet;
  final String? qeyd;

  MalHereketiBaxDto({
    required this.id,
    this.nAd,
    this.seri,
    this.miqdar,
    this.qiymet,
    this.qeyd,
  });

  factory MalHereketiBaxDto.fromJson(Map<String, dynamic> json) {
    return MalHereketiBaxDto(
      id: json['id'],
      nAd: json['nad'],
      seri: json['seri'],
      miqdar: json['miqdar'],
      qiymet: (json['qiymet'] as num?)?.toDouble(),
      qeyd: json['qeyd'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nAd': nAd,
      'seri': seri,
      'miqdar': miqdar,
      'qiymet': qiymet,
      'qeyd': qeyd,
    };
  }
}
