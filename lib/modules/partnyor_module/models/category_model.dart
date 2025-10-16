class Category {
  final int id;
  final String ad;
  

  Category({required this.id, required this.ad});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int, ad: json['ad'] as String);
  }

  @override
  String toString() {
    return 'Kassa(id: $id, ad: $ad)';
  }
}
