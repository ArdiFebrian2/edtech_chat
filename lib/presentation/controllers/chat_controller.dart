import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/room_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var messages = <MessageEntity>[].obs;
  var currentUserName = ''.obs; // ✅ simpan nama user yang sedang login
  String currentUserId = '';
  final Map<String, Map<String, dynamic>> _userCache = {};

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserInfo();
  }

  /// 🔹 Ambil data user yang sedang login dari Firestore
  Future<void> _loadCurrentUserInfo() async {
    final user = _auth.currentUser;
    if (user != null) {
      currentUserId = user.uid;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        currentUserName.value = doc['name'] ?? user.email?.split('@').first ?? 'Unknown';
      } else {
        currentUserName.value = user.email?.split('@').first ?? 'Unknown';
      }
    }
  }

  /// 🔹 Listen to messages in a room (real-time)
  void listenToMessages(String roomId) {
    _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        final data = doc.data();
        _userCache[data['authorId']] = {
          'name': data['authorName'] ?? 'Unknown',
          'photo': data['authorPhoto'] ?? '',
          'role': data['authorRole'] ?? 'student',
        };

        return MessageEntity(
          id: doc.id,
          roomId: roomId,
          authorId: data['authorId'],
          authorName: data['authorName'] ?? 'Unknown',
          authorRole: data['authorRole'] ?? 'student',
          authorPhoto: data['authorPhoto'] ?? '',
          text: data['text'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          type: data['type'],
        );
      }).toList();
    });
  }

  /// 🔹 Kirim pesan ke Firestore
  Future<void> sendMessage(
    String roomId,
    String authorId,
    String text,
    String authorName,
  ) async {
    final userDoc = await _firestore.collection('users').doc(authorId).get();
    final userData = userDoc.data() ?? {};

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add({
      'authorId': authorId,
      'authorName': authorName, // dikirim dari parameter
      'authorRole': userData['role'] ?? 'student',
      'authorPhoto': userData['photoUrl'] ?? '',
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'type': 'text',
    });
  }

  /// 🔹 Stream daftar room user
  Stream<List<RoomEntity>> getRoomsStream(String uid) {
    return _firestore
        .collection('rooms')
        .where('memberIds', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return RoomEntity(
              id: doc.id,
              type: data['type'] ?? 'single',
              members: List<Map<String, dynamic>>.from(data['members'] ?? []),
              memberIds: List<String>.from(data['memberIds'] ?? []),
              createdAt: (data['createdAt'] is Timestamp)
                  ? (data['createdAt'] as Timestamp).toDate()
                  : DateTime.now(),
            );
          }).toList(),
        );
  }

  /// 🔹 Resolve user info (cache)
  Map<String, dynamic>? resolveUser(String userId) {
    return _userCache[userId];
  }

  /// 🔹 Buat room trio (Student + Parent + Tutor)
  Future<void> createTrioRoom(String userId) async {
    try {
      print('🔹 [DEBUG] Creating trio room for $userId');

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() ?? {};

      if (userData.isEmpty) {
        Get.snackbar("Error", "User not found in Firestore.");
        return;
      }

      final role = userData['role'] ?? 'unknown';
      if (role != 'student') {
        Get.snackbar("Notice", "Only students can initiate a trio chat.");
        return;
      }

      final parentSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'parent')
          .limit(1)
          .get();

      final tutorSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'tutor')
          .limit(1)
          .get();

      if (parentSnapshot.docs.isEmpty || tutorSnapshot.docs.isEmpty) {
        Get.snackbar(
          "Error",
          "Need at least 1 parent and 1 tutor to create a trio room.",
        );
        return;
      }

      final parentData = parentSnapshot.docs.first.data();
      final tutorData = tutorSnapshot.docs.first.data();
      final parentId = parentSnapshot.docs.first.id;
      final tutorId = tutorSnapshot.docs.first.id;

      final existingRoom = await _firestore
          .collection('rooms')
          .where('type', isEqualTo: 'trio')
          .where('memberIds', arrayContains: userId)
          .get();

      final isDuplicate = existingRoom.docs.any((doc) {
        final memberIds = List<String>.from(doc['memberIds']);
        return memberIds.contains(parentId) && memberIds.contains(tutorId);
      });

      if (isDuplicate) {
        Get.snackbar(
          "Info",
          "Trio room already exists for this student, tutor, and parent.",
        );
        print('⚠️ [DEBUG] Trio room already exists.');
        return;
      }

      final roles = [role, parentData['role'], tutorData['role']];
      if (!roles.contains('student') ||
          !roles.contains('tutor') ||
          !roles.contains('parent') ||
          roles.toSet().length != 3) {
        Get.snackbar(
          "Error",
          "Invalid room composition. Trio must have 1 tutor, 1 parent, 1 student.",
        );
        return;
      }

      final roomData = {
        'type': 'trio',
        'members': [
          {
            'id': userId,
            'name': userData['name'] ?? userData['email'] ?? 'Student',
            'role': role,
            'photoUrl': userData['photoUrl'] ?? '',
          },
          {
            'id': parentId,
            'name': parentData['name'] ?? parentData['email'] ?? 'Parent',
            'role': parentData['role'] ?? 'parent',
            'photoUrl': parentData['photoUrl'] ?? '',
          },
          {
            'id': tutorId,
            'name': tutorData['name'] ?? tutorData['email'] ?? 'Tutor',
            'role': tutorData['role'] ?? 'tutor',
            'photoUrl': tutorData['photoUrl'] ?? '',
          },
        ],
        'memberIds': [userId, parentId, tutorId],
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('rooms').add(roomData);

      print('✅ [DEBUG] Trio room created successfully!');
      Get.snackbar("Success", "Trio room created successfully!");
    } catch (e, stack) {
      print('❌ [ERROR] Failed to create trio room: $e');
      print(stack);
      Get.snackbar("Error", e.toString());
    }
  }
}
