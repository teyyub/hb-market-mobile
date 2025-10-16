import 'package:flutter/foundation.dart';

class Temizlenme {
  final int id;
  final DateTime date;

  Temizlenme({required this.id, required this.date});

  // Add this method
  Temizlenme copyWith({DateTime? date}) {
    return Temizlenme(id: id, date: date ?? this.date);
  }

  // From JSON (e.g., response from your Spring Boot API)
  factory Temizlenme.fromJson(Map<String, dynamic> json) {
    return Temizlenme(
      id: json['id'],
      date: DateTime.parse(json['date']), // assumes ISO 8601 format
    );
  }

  // To JSON (for sending update requests)
  Map<String, dynamic> toJson() {
    return {'id': id, 'date': date.toIso8601String()};
  }
}
