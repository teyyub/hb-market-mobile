import 'package:decimal/decimal.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';

class TransferResponse {
  final int id;
  final Kassa? giver;
  final Kassa? taker;
  final Decimal amount;
  final String note;

  TransferResponse({
    required this.id,
    this.giver,
    this.taker,
    required this.amount,
    required this.note,
  });

  // Factory constructor for creating an instance from JSON
  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    return TransferResponse(
      id: json['id'] ?? 0,
      giver: json['giver'] != null ? Kassa.fromJson(json['giver']) : null,
      taker: json['taker'] != null ? Kassa.fromJson(json['taker']) : null,
      amount: json['amount'] != null
          ? Decimal.parse(json['amount'].toString())
          : Decimal.zero,
      note: json['note'] ?? '',
    );
  }

  // Method for converting the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'veren': veren,
      // 'alan': alan,
      'amount': amount,
      'note': note,
    };
  }
}
