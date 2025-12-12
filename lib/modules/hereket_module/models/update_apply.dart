class UpdateApplyDto {
  final int id;
  final int nov;
  final double price;

  UpdateApplyDto({
    required this.id,
    required this.nov,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nov': nov,
      'qiymet': price,
    };
  }

}
