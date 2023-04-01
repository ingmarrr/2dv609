class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String fullName;
  final String phone;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      fullName: json['fullName'],
      phone: json['phone'],
    );
  }
}
