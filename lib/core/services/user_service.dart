// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final UserService instance = UserService._();
  UserService._();

  final Map<String, String> _cache = {};

  Future<String> getUserName(String userId) async {
    if (userId.isEmpty) return 'Unknown';

    if (_cache.containsKey(userId)) {
      return _cache[userId]!;
    }

    try {
      print("Fetching name for UID: $userId");
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final name = data?['name']?.toString() ?? 'Unknown';
        _cache[userId] = name;
        return name;
      } else {
        _cache[userId] = 'Unknown';
        return 'Unknown';
      }
    } catch (e) {
      _cache[userId] = 'Unknown';
      return 'Unknown';
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
