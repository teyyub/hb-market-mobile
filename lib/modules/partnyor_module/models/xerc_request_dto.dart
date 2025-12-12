class XercRequestDto {
  final int? id;
  final int mustId;
  final int kassaId;
  final double? amount;
  final double? pays;
  final int? categoryId;
  final int? subCategoryId;
  final String? sebeb;
  final String? qeyd;
  final String? sign;

  XercRequestDto({
    this.id,
    required this.mustId,
    required this.kassaId,
    this.amount,
    this.pays,
    this.categoryId,
    this.subCategoryId,
    this.sebeb,
    this.qeyd,
    this.sign,
  });

  Map<String, dynamic> toJson() {
    return {
      'mustId': mustId,
      'kassaId': kassaId,
      'amount': amount,
      'pays': pays,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'sebeb': sebeb,
      'qeyd': qeyd,
      'sign': sign,
    };
  }

  Map<String, dynamic> toJson1() {
    return {
      'mus': mustId,
      'kassa': kassaId,
      'mebleg': amount,
      'oden': pays,
      'xkat': categoryId,
      'xakat': subCategoryId,
      'sebeb': sebeb,
      'qeyd': qeyd,
      'sign': sign,
    };
  }

  @override
  String toString() {
    return 'XercQazanc('
        'mustId: $mustId, '
        'kassaId: $kassaId, '
        'mebleg: $amount, '
        'oden: $pays, '
        // 'kad: $kad, '
        'sebeb: $sebeb, '
        'qeyd: $qeyd, '
        // 'xkat: $xkat, '
        // 'xakat: $xakat, '
        'sign: $sign, '
        // 'aktiv: $aktiv'
        ')';
  }
}
