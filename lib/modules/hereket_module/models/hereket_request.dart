import 'package:decimal/decimal.dart';

class HereketRequest {
  final int? id;
  final int? hereketId;
  final int? obyektId;
  final int? partnyorId;
  final int? subPartnyorId;
  final Decimal percentage;
  final String? note;

  HereketRequest({
    this.id,
    this.hereketId,
    this.obyektId,
    this.partnyorId,
    this.subPartnyorId,
    required this.percentage,
    this.note,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'hereketId': hereketId,
      'obyektId': obyektId,
      'partnerId': partnyorId,
      'subPartnerId': subPartnyorId,
      'percentage': percentage.toString(), // Decimal to String
      'note': note,
    };
  }

  // Create object from JSON
  factory HereketRequest.fromJson(Map<String, dynamic> json) {
    return HereketRequest(
      id: json['id'],
      hereketId: json['hereketId'],
      obyektId: json['obyektId'],
      partnyorId: json['partnyorId'],
      subPartnyorId: json['subPartnyorId'],
      percentage: Decimal.parse(json['faiz'].toString()), // String to Decimal
      note: json['note'],
    );
  }
}
