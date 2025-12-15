import '../../kassa_module/models/kassa_short.dart';

class MalOdenisDto {
  final int id;
  final double mebleg;
  final KassaShortDto kassa;

  MalOdenisDto({
    required this.id,
    required this.mebleg,
    required this.kassa,
  });

  factory MalOdenisDto.fromJson(Map<String, dynamic> json) {
    return MalOdenisDto(
      id: json['id'] as int,
      mebleg: double.parse(json['mebleg'].toString()),
      kassa: KassaShortDto.fromJson(json['kassa']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mebleg': mebleg.toString(),
      'kassa': kassa.toJson(),
    };
  }
}
