class Message {
  final int id;
  final int chatId;
  final int senderId;
  final String content;
  final String createdAt;

  Message({
    required this.id,
    required this.chatId,
    required this.content,
    required this.senderId,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    chatId: json['chat_id'],
    senderId: json['sender_id'],
    content: json['content'],
    createdAt: json['created_at'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat_id": chatId,
    "sender_id": senderId,
    "content": content,
    "created_at": createdAt,
  };
}
