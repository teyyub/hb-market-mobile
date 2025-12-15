class HereketSelahDto {
  String name;
  String aktiv;

  HereketSelahDto({required this.name, required this.aktiv});

  // JSON-dan obyekt yaratmaq
  factory HereketSelahDto.fromJson(Map<String, dynamic> json) {
    return HereketSelahDto(
      name: json['name'],
      aktiv: json['aktiv'],
    );
  }

  // Obyekti JSON-a çevirmək
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'aktiv': aktiv,
    };
  }
}
