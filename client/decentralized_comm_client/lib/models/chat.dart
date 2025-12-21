class Chat {
  final int id;
  final String? name;
  final bool isGroup;

  Chat({required this.id, this.name, required this.isGroup});

  factory Chat.fromJson(Map<String, dynamic> json) =>
      Chat(id: json['id'], name: json['name'], isGroup: json['is_group']);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_group": isGroup,
  };
}
