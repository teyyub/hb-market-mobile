class YonlendirmeDto {
  final int? id;
  final bool? kecidOk;

  YonlendirmeDto({this.id, this.kecidOk});

  // Factory constructor to create an instance from JSON
  factory YonlendirmeDto.fromJson(Map<String, dynamic> json) {
    return YonlendirmeDto(
      id: json['id'] as int?,
      kecidOk: json['kecidOk'] as bool?,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'kecidOk': kecidOk};
  }

  /// Creates a copy of this YonlendirmeDto with optional new values
  YonlendirmeDto copyWith({int? id, bool? kecidOk}) {
    return YonlendirmeDto(id: id ?? this.id, kecidOk: kecidOk ?? this.kecidOk);
  }
}
