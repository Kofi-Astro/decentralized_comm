class User {
  final int id;
  final String username;
  final String createdAt;

  User({required this.id, required this.username, required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id       : json['id'],
    username : json['username'],
    createdAt: json['created_at'],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'created_at': createdAt,
    'id': id,
  };
}
