class ApiResponse<T> {
  final bool success;
  final int status;
  final String message;
  final T? data;
  final DateTime timestamp;

  ApiResponse({
    required this.success,
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonT,) {
    return ApiResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
