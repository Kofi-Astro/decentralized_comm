class Chat {
  final int id;
  final bool isGroup;
  final int? recipientId;
  final String? recipientUsername;

  Chat({
    required this.id,
    required this.isGroup,
    required this.recipientId,
    required this.recipientUsername,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json['id'],
    isGroup: json['is_group'],
    recipientId: json['recipient']?['id'],
    recipientUsername: json['recipient']?['username'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_group": isGroup,
    "recipientId": recipientId,
    "recipientUsername": recipientUsername,
  };
}
