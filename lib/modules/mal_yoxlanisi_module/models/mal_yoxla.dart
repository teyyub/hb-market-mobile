class MalYoxla {
  final int id;
  final String name;
  final String barcode;
  final double alis;
  final double satis;
  final double salePrice; // maps Java BigDecimal
  final int stockQuantity;
  final double sat2;
  final double sat3;
  final double sat4;
  final double sat5;
  final double sat6;
  final String? oz1;
  final String? oz2;
  final String? oz3;
  final String? oz4;

  const MalYoxla({
    required this.id,
    required this.name,
    required this.barcode,
    required this.alis,
    required this.satis,
    required this.salePrice,
    required this.stockQuantity,
    required this.sat2,
    required this.sat3,
    required this.sat4,
    required this.sat5,
    required this.sat6,
    this.oz1,
    this.oz2,
    this.oz3,
    this.oz4
  });

  factory MalYoxla.fromJson(Map<String, dynamic> json) {
    return MalYoxla(
      id: json['id'] as int,
      name: json['ad'] as String,
      barcode: json['seri'] as String,
      alis: json['alis'] as double,
      satis: json['satis'] as double,
      salePrice: json['salePrice'] as double,
      stockQuantity: json['stockQuantity'] as int,
      sat2 :json['sat2'] as double,
      sat3 :json['sat3'] as double,
      sat4 :json['sat4'] as double,
      sat5 :json['sat5'] as double,
      sat6 :json['sat6'] as double,
      oz1: json['oz1'] as String,
      oz2: json['oz2'] as String,
      oz3: json['oz3'] as String,
      oz4: json['oz4'] as String,
    );
  }

  static const MalYoxla empty = MalYoxla(
    id: -1,
    name: '',
    barcode:'',
    alis : .0,
    satis: .0,
    sat2:0,
    sat3:0,
    sat4:0,
    sat5:0,
    sat6:0,
    salePrice: .0,
    stockQuantity: 0,
  );

  bool get isEmpty => id == -1;

  @override
  String toString() {
    return 'MalYoxla(id: $id, name: $name, salePrice: $salePrice, stockQuantity: $stockQuantity)';
  }
}
