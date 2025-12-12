import 'package:hbmarket/modules/hereket_module/models/hereket_dto.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_light.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';

class HereketResponse {
  final int id;
  final HereketDto? hereket;
  final Obyekt? obyekt;
  final PartnyorLight? partnyor;
  final int percentage;
  final String? note;

  HereketResponse({
    required this.id,
    this.hereket,
    this.obyekt,
    this.partnyor,
    required this.percentage,
    this.note,
  });

  // Create object from JSON
  factory HereketResponse.fromJson(Map<String, dynamic> json) {
    return HereketResponse(
      id: json['id'],
      hereket: json['hereketDto'] != null
          ? HereketDto.fromJson(json['hereketDto'])
          : null,
      obyekt: json['obyektDto'] != null
          ? Obyekt.fromJson(json['obyektDto'])
          : null,
      partnyor: json['partnerDto'] != null
          ? PartnyorLight.fromJson(json['partnerDto'])
          : null,
      percentage: (json['percentage'] is num)
          ? (json['percentage'] as num).toInt()
          : 0,
      note: json['note'],
    );
  }
  @override
  String toString() {
    return 'HereketResponse(id: $id, '
        'hereket: ${hereket?.toString() ?? "null"}, '
        'obyekt: ${obyekt?.toString() ?? "null"}, '
        'partnyor: ${partnyor?.toString() ?? "null"}, '
        'percentage: $percentage, '
        'note: ${note ?? "null"})';
  }
}
