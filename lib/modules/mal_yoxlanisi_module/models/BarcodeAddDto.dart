class BarcodeAddDto {
  int? id;
  int? amount;
  String? barcode;
  String? name;
  double? price;
  final String? oz1;
  final String? oz2;
  final String? oz3;
  final String? oz4;
  BarcodeAddDto({
    this.id,
    this.amount,
    this.barcode,
    this.name,
    this.price,
    this.oz1,
    this.oz2,
    this.oz3,
    this.oz4,
  });

  /// JSON → Dart
  factory BarcodeAddDto.fromJson(Map<String, dynamic> json) {
    return BarcodeAddDto(
      id: json['id'],
      amount: json['amount'],
      barcode: json['barcode'],
      name: json['name'],
      price: json['price'] != null ? json['price'].toDouble() : null,

    );
  }

  /// Dart → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'barcode': barcode,
      'name': name,
      'price': price,
      'oz1':oz1,
      'oz2':oz2,
      'oz3':oz3,
      'oz4':oz4,
    };
  }

  @override
  String toString() {
    return 'BarcodeAddDto(id: $id, amount: $amount, barcode: $barcode, '
        'name: $name, price: $price )';
  }
}
