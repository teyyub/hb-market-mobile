class HereketApplyResponseDto {
  bool? success;
  int? id;
  String? message;

  HereketApplyResponseDto({
    this.success,
    this.id,
    this.message,
  });

  factory HereketApplyResponseDto.fromJson(Map<String, dynamic> json) {
    return HereketApplyResponseDto(
      success: json['success'],
      id: json['id'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'id': id,
      'message': message,
    };
  }
}
