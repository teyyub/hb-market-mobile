import 'package:decimal/decimal.dart';

class ApplyDto {
  final int? dPlanId;
  final int? amount;
  final double? price;
  final double? sellPrice;
  final String? note;

  ApplyDto({
    this.dPlanId,
    this.amount,
    this.price,
    this.sellPrice,
    this.note,
  });

  /// ------------ FROM JSON ------------
  factory ApplyDto.fromJson(Map<String, dynamic> json) {
    return ApplyDto(
      dPlanId: json['dPlanId'] as int?,
      amount: json['amount'] as int?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      sellPrice: json['sellPrice'] != null ? (json['sellPrice'] as num).toDouble() : null,
      note: json['note'] as String?,
    );
  }

  /// ------------ TO JSON ------------
  Map<String, dynamic> toJson() {
    return {
      'dPlanId': dPlanId,
      'amount': amount,
      'price': price,
      'sellPrice': sellPrice,
      'note': note,
    };
  }

  /// ------------ TO STRING ------------
  @override
  String toString() {
    return 'HereketDPlan(dPlanId: $dPlanId, amount: $amount, price: $price, sellPrice: $sellPrice, note: $note)';
  }
}
