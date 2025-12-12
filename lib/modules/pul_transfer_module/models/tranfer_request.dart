import 'package:decimal/decimal.dart';

class TransferRequest {
  final int? id;
  final int? giver;
  final int? taker;
  final Decimal amount;
  final String? note;

  TransferRequest({
    this.id,
    this.giver,
    this.taker,
    required this.amount,
    this.note,
  });

  // Factory constructor to create a TransferRequest from JSON
  factory TransferRequest.fromJson(Map<String, dynamic> json) {
    return TransferRequest(
      id: json['id'] ?? 0,
      giver: json['veren'] ?? '',
      taker: json['alan'] ?? '',
      amount: json['amount'] ?? 0,
      note: json['note'] ?? '',
    );
  }

  // Method to convert TransferRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'giverId': giver,
      'takerId': taker,
      'amount': amount,
      'note': note,
    };
  }
}
