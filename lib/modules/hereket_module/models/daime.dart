class QaimeDto {
  final int? id;
  final int? idVC;
  final String? ad;
  final String? barkod;
  final int? litr;
  final int? litrN4;
  final double? alis0;
  final double? alis;
  final double? alis1;
  final double? alis2;
  final double? alis3;
  final double? alisN4;
  final double? satis0;
  final double? satis;
  final double? satis1;
  final double? satis2;
  final double? satis3;
  final double? satisN4;

  QaimeDto({
    this.id,
    this.idVC,
    this.ad,
    this.barkod,
    this.litr,
    this.litrN4,
    this.alis0,
    this.alis,
    this.alis1,
    this.alis2,
    this.alis3,
    this.alisN4,
    this.satis0,
    this.satis,
    this.satis1,
    this.satis2,
    this.satis3,
    this.satisN4,
  });

  factory QaimeDto.fromJson(Map<String, dynamic> json) {
    return QaimeDto(
      id: json['id'],
      ad: json['ad'],
      barkod: json['barkod'],
      litr: json['litr'],
      litrN4: json['litrN4'],
      alis0: (json['alis0'] as num?)?.toDouble(),
      alis: (json['alis'] as num?)?.toDouble(),
      alis1: (json['alis1'] as num?)?.toDouble(),
      alis2: (json['alis2'] as num?)?.toDouble(),
      alis3: (json['alis3'] as num?)?.toDouble(),
      alisN4: (json['alisN4'] as num?)?.toDouble(),
      satis: (json['satis'] as num?)?.toDouble(),
      satis1: (json['satis1'] as num?)?.toDouble(),
      satis2: (json['satis2'] as num?)?.toDouble(),
      satis3: (json['satis3'] as num?)?.toDouble(),
      satisN4: (json['satisN4'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idVC': idVC,
      'ad': ad,
      'barkod': barkod,
      'litr': litr,
      'litrN4': litrN4,
      'alis0': alis0,
      'alis': alis,
      'alis1': alis1,
      'alis2': alis2,
      'alis3': alis3,
      'alisN4': alisN4,
      'satis': satis,
      'satis1': satis1,
      'satis2': satis2,
      'satis3': satis3,
      'satisN4': satisN4,
    };
  }

  @override
  String toString() {
    return 'QaimeDto(id: $id, idVC: $idVC, ad: $ad, barkod: $barkod, litr: $litr,'
        ' litrN4: $litrN4,  alis0: $alis0, '
        'alis: $alis, '
        'alis1: $alis1, '
        'alis2: $alis2, '
        'alis3: $alis3, '
        'alisN4: $alisN4, '
        'satis0: $satis0,'
        'satis: $satis,'
        'satis1: $satis1, '
        'satis2: $satis2, '
        'satis3: $satis3, '
        'satisN4: $satisN4)';
  }

  Map<String, dynamic> toFieldMap() => {
    'alis0': alis0,
    'alis': alis,
    // 'alis1': alis1,
    // 'alis2': alis2,
    // 'alis3': alis3,
    // 'alisN4': alisN4,
    'satis': satis,
    // 'satis1': satis1,
    'satis2': satis2,
    'satis3': satis3,
    // 'satisN4': satisN4,
  };
}
  // 🔽 bunu buraya əlavə et
  extension QaimeDtoExtension on QaimeDto? {
  String valueOf(String key) {
  if (this == null || key.isEmpty) return '';
  final value = this!.toFieldMap()[key];
  return value?.toString() ?? '';
  }
}
