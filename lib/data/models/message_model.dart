import 'package:isar/isar.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@Collection()
class MessageModel {
  Id id = Isar.autoIncrement;

  late String messageId;
  late String roomId;
  late String authorId;
  String? authorName;
  String? authorRole;
  late String text;
  late DateTime createdAt;
  late String type;

  MessageModel();
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel()
      ..messageId = entity.id
      ..roomId = entity.roomId
      ..authorId = entity.authorId
      ..authorName = entity.authorName
      ..authorRole = entity.authorRole
      ..text = entity.text
      ..createdAt = entity.createdAt
      ..type = entity.type;
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: messageId,
      roomId: roomId,
      authorId: authorId,
      authorName: authorName ?? 'Unknown',
      authorRole: authorRole ?? 'student',
      text: text,
      createdAt: createdAt,
      type: type,
    );
  }

  Map<String, dynamic> toMap() => {
    'messageId': messageId,
    'roomId': roomId,
    'authorId': authorId,
    'authorName': authorName,
    'authorRole': authorRole,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
    'type': type,
  };
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel()
      ..messageId = map['messageId'] ?? ''
      ..roomId = map['roomId'] ?? ''
      ..authorId = map['authorId'] ?? ''
      ..authorName = map['authorName']
      ..authorRole = map['authorRole']
      ..text = map['text'] ?? ''
      ..createdAt = DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now()
      ..type = map['type'] ?? 'text';
  }
}
