class OdenisRequestDto {
  final int pulal;
  final int qdaxil;
  final double mebleg;
  final int kassaId;

  OdenisRequestDto({
    required this.pulal,
    required this.qdaxil,
    required this.mebleg,
    required this.kassaId,
  });

  factory OdenisRequestDto.fromJson(Map<String, dynamic> json) {
    return OdenisRequestDto(
      pulal: json['pulal'],
      qdaxil: json['qdaxil'],
      mebleg: json['mebleg']?.toDouble(),
      kassaId: json['kassaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pulal': pulal,
      'qdaxil': qdaxil,
      'mebleg': mebleg,
      'kassaId': kassaId,
    };
  }
}
