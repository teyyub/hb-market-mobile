class WorkItem {
  final int id;
  final String name;

  WorkItem({required this.id, required this.name});


  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  factory WorkItem.fromJson(Map<String, dynamic> json) => WorkItem(
    id: json['id'],
    name: json['name'],
  );

  @override
  String toString() {
    return 'WorkItem{id: $id, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WorkItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}
