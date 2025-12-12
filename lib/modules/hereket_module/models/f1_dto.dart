import 'package:decimal/decimal.dart';

class F1Dto {
  final int? id;
  final int? hereketId; //dtip demekdir
  final int? dPlanId;
  final int? nov;
  final int? amount;
  final double? price;
  final double? sellPrice;
  final String? note;

  F1Dto({
    this.id,
    this.hereketId,
    this.dPlanId,
    this.nov,
    this.amount,
    this.price,
    this.sellPrice,
    this.note,
  });

  /// ------------ FROM JSON ------------
  factory F1Dto.fromJson(Map<String, dynamic> json) {
    return F1Dto(
      id: json['id'] as int?,
      hereketId: json['hareketId'] as int?,
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
      'id': id,
      'hareketId': hereketId,
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
    return 'HereketDPlan(id: $id, hareketId: $hereketId, dPlanId: $dPlanId, amount: $amount, price: $price, sellPrice: $sellPrice, note: $note)';
  }
}
