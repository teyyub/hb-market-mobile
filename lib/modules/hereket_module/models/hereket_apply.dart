class HereketApplyDto {
  int qdplan;
  int qdaxil;

  HereketApplyDto({required this.qdplan, required this.qdaxil});

  // JSON-dan obyekt yaratmaq
  factory HereketApplyDto.fromJson(Map<String, dynamic> json) {
    return HereketApplyDto(
      qdplan: json['qdplan'],
      qdaxil: json['qdaxil'],
    );
  }

  // Obyekti JSON-a çevirmək
  Map<String, dynamic> toJson() {
    return {
      'qdplan': qdplan,
      'qdaxil': qdaxil,
    };
  }
}
