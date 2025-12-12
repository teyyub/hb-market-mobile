import 'package:decimal/decimal.dart';

class HereketDPlan {
  final int? id;
  final int? hereketId;
  final int? dPlanId;
  final int? amount;
  final double? price;
  final double? sellPrice;
  final String? note;

  HereketDPlan({
    this.id,
    this.hereketId,
    this.dPlanId,
    this.amount,
    this.price,
    this.sellPrice,
    this.note,
  });

  /// ------------ FROM JSON ------------
  factory HereketDPlan.fromJson(Map<String, dynamic> json) {
    return HereketDPlan(
      id: json['id'] as int?,
      hereketId: json['hereketId'] as int?,
      dPlanId: json['planId'] as int?,
      amount: json['amount'] as int?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      sellPrice: json['sellPrice'] != null ? (json['sellPrice'] as num).toDouble() : null,
      note: json['note'] as String?,
    );
  }

  /// ------------ TO JSON ------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hereketId': hereketId,
      'planId': dPlanId,
      'amount': amount,
      'price': price,
      'sellPrice': sellPrice,
      'note': note,
    };
  }


  HereketDPlan copyWith({
    int? dPlanId,
    int? hereketId,
    int? amount,
    double? price,
    double? sellPrice,
    String? note,
  }) {
    return HereketDPlan(
      dPlanId: dPlanId ?? this.dPlanId,
      hereketId: hereketId ?? this.hereketId,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      sellPrice: sellPrice ?? this.sellPrice,
      note: note ?? this.note,
    );
  }
  /// ------------ TO STRING ------------
  @override
  String toString() {
    return 'HereketDPlan(id: $id, hereketId: $hereketId, dPlanId: $dPlanId, amount: $amount, price: $price, sellPrice: $sellPrice, note: $note)';
  }
}
