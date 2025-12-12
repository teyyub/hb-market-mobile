class PartnyorLight {
  final int? id;
  final String? ad;

  PartnyorLight({this.id, this.ad});

  // fromJson
  factory PartnyorLight.fromJson(Map<String, dynamic> json) {
    return PartnyorLight(id: json['id'], ad: json['ad']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PartnyorLight && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PartnyorLight(id: $id, ad: $ad)';
}
