// search_item.dart
class SearchItem {
  final int id;
  final String title;

  SearchItem({required this.id, required this.title});

  // Factory constructor to create object from JSON
  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(id: json['id'], title: json['title']);
  }

  // Convert object to JSON (optional)
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
