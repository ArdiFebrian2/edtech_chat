import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../models/room_model.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageEntity>> listenMessages(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return MessageEntity(
              id: doc.id,
              roomId: roomId,
              authorId: data['authorId'] ?? '',
              authorName: data['authorName'] ?? 'Unknown',
              authorRole: data['authorRole'] ?? 'student',
              text: data['text'] ?? '',
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              type: data['type'] ?? 'text',
            );
          }).toList(),
        );
  }

  Future<void> sendMessage(String roomId, MessageEntity message) async {
    final userDoc = await _firestore
        .collection('users')
        .doc(message.authorId)
        .get();
    final userData = userDoc.data() ?? {};

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add({
          'authorId': message.authorId,
          'authorName': userData['name'] ?? 'Unknown',
          'authorRole': userData['role'] ?? 'student',
          'authorPhoto': userData['photoUrl'] ?? '',
          'text': message.text,
          'createdAt': message.createdAt,
          'type': message.type,
        });
  }

  Stream<List<RoomModel>> getRooms(String uid) {
    return _firestore
        .collection('rooms')
        .where('memberIds', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RoomModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<bool> createTrioRoom(RoomEntity room) async {
    final hasTutor = room.members.any((m) => m['role'] == 'tutor');
    final hasParent = room.members.any((m) => m['role'] == 'parent');
    final hasStudent = room.members.any((m) => m['role'] == 'student');

    if (room.type == "trio" && hasTutor && hasParent && hasStudent) {
      await _firestore.collection('rooms').add({
        'type': room.type,
        'members': room.members,
        'memberIds': room.memberIds,
        'createdAt': room.createdAt,
      });
      return true;
    } else {
      throw Exception("Trio room must contain tutor, parent, and student");
    }
  }
}
