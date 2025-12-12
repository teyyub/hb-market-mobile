class Category {
  final int id;
  final String ad;

  Category({required this.id, required this.ad});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int, ad: json['ad'] as String);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category(id: $id, ad: $ad)';
  }
}
