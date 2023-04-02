class Session {
  final int id;
  final int userId;
  final String token;

  Session({
    required this.id,
    required this.userId,
    required this.token,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      userId: json['userId'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'token': token,
    };
  }
}
