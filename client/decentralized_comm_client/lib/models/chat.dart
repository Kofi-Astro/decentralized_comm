class Chat {
  final int id;
  final String name;
  final bool isGroup;
  final int ownerId;

  Chat({
    required this.id,
    required this.name,
    required this.isGroup,
    required this.ownerId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json['id'],
    name: json['name'],
    isGroup: json['is_group'],
    ownerId: json['owner_id'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_group": isGroup,
    "owner_id": ownerId,
  };
}
