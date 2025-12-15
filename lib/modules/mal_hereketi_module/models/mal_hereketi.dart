class MalHereketiDto {
  int id;
  int? gfaiz;
  double? meblegN2;
  double? rMeb;
  double? oden;
  String? mAd;
  String? dtAd;

  MalHereketiDto({
    required this.id,
    this.gfaiz,
    this.meblegN2,
    this.rMeb,
    this.oden,
    this.mAd,
    this.dtAd,
  });

  factory MalHereketiDto.fromJson(Map<String, dynamic> json) {
    return MalHereketiDto(
      id: json['id'],
      gfaiz: json['gfaiz'],
      meblegN2: (json['meblegN2'] as num?)?.toDouble(),
      rMeb: (json['rmeb'] as num?)?.toDouble(),
      oden: (json['oden'] as num?)?.toDouble()?? .0,
      mAd: json['mad'],
      dtAd: json['dtAd'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gfaiz': gfaiz,
      'meblegN2': meblegN2,
      'rMeb': rMeb,
      'oden': oden,
      'mAd': mAd,
      'dtAd': dtAd,
    };
  }
}
