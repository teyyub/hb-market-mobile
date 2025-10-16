class MalYoxla {
  final int id;
  final String name;
  final double salePrice; // maps Java BigDecimal
  final int stockQuantity;

  const MalYoxla({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.stockQuantity,
  });

  factory MalYoxla.fromJson(Map<String, dynamic> json) {
    return MalYoxla(
      id: json['id'] as int,
      name: json['ad'] as String,
      salePrice: json['salePrice'] as double,
      stockQuantity: json['stockQuantity'] as int,
    );
  }

  static const empty = MalYoxla(
    id: -1,
    name: '',
    salePrice: .0,
    stockQuantity: 0,
  );

  bool get isEmpty => id == -1;

  @override
  String toString() {
    return 'MalYoxla(id: $id)';
  }
}
