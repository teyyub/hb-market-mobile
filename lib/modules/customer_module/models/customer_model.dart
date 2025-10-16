class Customer {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  Customer({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });
}
