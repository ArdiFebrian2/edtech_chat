class MessageEntity {
  final String id;
  final String roomId;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String text;
  final DateTime createdAt;
  final String type;

  MessageEntity({
    required this.id,
    required this.roomId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.text,
    required this.createdAt,
    required this.type,
  });
}
