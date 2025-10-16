class UpdateRequestDto {
  final int mustId;
  final int kassaId;
  final double amount;
  final String sign;

  UpdateRequestDto({
    required this.mustId,
    required this.kassaId,
    required this.amount,
    required this.sign,
  });

  Map<String, dynamic> toJson() {
    return {
      'mustId': mustId,
      'kassaId': kassaId,
      'amount': amount,
      'sign': sign,
    };
  }
}
