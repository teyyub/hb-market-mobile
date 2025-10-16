class FieldValue {
  final dynamic value;
  final String alignment;

  FieldValue({required this.value, required this.alignment});

  factory FieldValue.fromJson(Map<String, dynamic> json) {
    return FieldValue(value: json['value'], alignment: json['alignment']);
  }

  @override
  String toString() {
    return 'FieldValue(value: $value, alignment: $alignment)';
  }
}
