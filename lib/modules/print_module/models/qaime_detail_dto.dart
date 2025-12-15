import 'package:intl/intl.dart';

class QaimeDetailDto {
  final int id;
  final double mebleg;
  final double borc;
  final double rmeb;
  final double oden;
  final double endirim;
  final String dtAd;
  final String? dtAd1;
  final String mAd;
  final String oAd;
  final String lAd;
  final DateTime printedAt;

  QaimeDetailDto({
    required this.id,
    required this.mebleg,
    required this.borc,
    required this.rmeb,
    required this.oden,
    required this.endirim,
    required this.dtAd,
    this.dtAd1,
    required this.mAd,
    required this.oAd,
    required this.lAd,
    required this.printedAt
  });

  factory QaimeDetailDto.fromJson(Map<String, dynamic> json) {
    DateTime printedAt;
    // if (json['printedAt'] != null) {
      final formatter = DateFormat("MM.dd.yyyy HH.mm");
      printedAt = formatter.parse(json['printedAt']);
    // }
    return QaimeDetailDto(
      id: json['id'],
      mebleg: json['mebleg'].toDouble(),
      borc: json['borc'].toDouble(),
      rmeb: json['rmeb'].toDouble(),
      oden: json['oden'].toDouble(),
      endirim: json['endirim'].toDouble(),
      dtAd: json['dt_ad'],
      dtAd1: json['dt_ad1'],
      mAd: json['m_ad'],
      oAd: json['o_ad'],
      lAd: json['l_ad'],
      printedAt: printedAt
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mebleg': mebleg,
      'borc': borc,
      'rmeb': rmeb,
      'oden': oden,
      'endirim': endirim,
      'dt_ad': dtAd,
      'dt_ad1': dtAd1,
      'm_ad': mAd,
      'o_ad': oAd,
      'l_ad': lAd,
    };
  }
}


