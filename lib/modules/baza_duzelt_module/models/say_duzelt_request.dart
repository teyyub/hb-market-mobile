import 'package:decimal/decimal.dart';

class SayDuzeltRequest {
  final int id;
  final String barcode;
  final Decimal? count;
  final Decimal? remain;

  SayDuzeltRequest({
    required this.id,
    required this.barcode,
    this.count,
    this.remain,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'barcode': barcode, 'count': count, 'remain': remain};
  }
}
