class Message {
  final int id;
  final int chatId;
  final senderId;
  final String content;

  Message({
    required this.id,
    required this.chatId,
    required this.content,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    chatId: json['chat_id'],
    senderId: json['sender_id'],
    content: json['content'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat_id": chatId,
    "sender_id": senderId,
    "content": content,
  };
}
