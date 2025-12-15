class KassaShortDto {
  final int id;
  final String ad;

  KassaShortDto({
    required this.id,
    required this.ad,
  });

  factory KassaShortDto.fromJson(Map<String, dynamic> json) {
    return KassaShortDto(
      id: json['id'] as int,
      ad: json['ad'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
    };
  }
}
