import 'package:isar/isar.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@Collection()
class MessageModel {
  Id id = Isar.autoIncrement; // ID internal untuk Isar

  late String messageId; // Firestore doc id
  late String roomId;
  late String authorId;
  String? authorName;
  String? authorRole;
  String? authorPhoto; // 🔹 tambahan agar cocok dengan entity
  late String text;
  late DateTime createdAt;
  late String type; // 'text' | 'image' | 'action'
  String? imageUrl;

  MessageModel();

  /// 🔹 Convert from domain entity (MessageEntity → MessageModel)
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel()
      ..messageId = entity.id
      ..roomId = entity.roomId
      ..authorId = entity.authorId
      ..authorName = entity.authorName
      ..authorRole = entity.authorRole
      ..authorPhoto = entity.authorPhoto
      ..text = entity.text
      ..createdAt = entity.createdAt
      ..type = entity.type;
  }

  /// 🔹 Convert to domain entity (MessageModel → MessageEntity)
  MessageEntity toEntity() {
    return MessageEntity(
      id: messageId,
      roomId: roomId,
      authorId: authorId,
      authorName: authorName ?? 'Unknown',
      authorRole: authorRole ?? 'student',
      authorPhoto: authorPhoto ?? '',
      text: text,
      createdAt: createdAt,
      type: type,
    
    );
  }

  /// 🔹 Convert to Map (optional, for Firestore or debug)
  Map<String, dynamic> toMap() => {
    'messageId': messageId,
    'roomId': roomId,
    'authorId': authorId,
    'authorName': authorName,
    'authorRole': authorRole,
    'authorPhoto': authorPhoto,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
    'type': type,
    if (imageUrl != null) 'imageUrl': imageUrl,
  };

  /// 🔹 Convert from Map (optional)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel()
      ..messageId = map['messageId'] ?? ''
      ..roomId = map['roomId'] ?? ''
      ..authorId = map['authorId'] ?? ''
      ..authorName = map['authorName']
      ..authorRole = map['authorRole']
      ..authorPhoto = map['authorPhoto']
      ..text = map['text'] ?? ''
      ..createdAt = DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now()
      ..type = map['type'] ?? 'text'
      ..imageUrl = map['imageUrl'];
  }
}
