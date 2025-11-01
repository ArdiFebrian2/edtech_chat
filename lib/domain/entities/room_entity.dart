// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomEntity {
  final String id;
  final String type; // "trio" | "group" | "private"
  final List<Map<String, dynamic>> members; 
  // members entry example: { "id": "uid123", "role": "student", "name": "Budi" }
  final List<String> memberIds; // convenience list for queries
  final DateTime createdAt;

  RoomEntity({
    required this.id,
    required this.type,
    required this.members,
    required this.memberIds,
    required this.createdAt,
  });

  factory RoomEntity.fromMap(String id, Map<String, dynamic> map) {
    return RoomEntity(
      id: id,
      type: map['type'] ?? 'private',
      members: (map['members'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      memberIds: (map['memberIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : (map['createdAt'] != null
              ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'members': members,
      'memberIds': memberIds,
      'createdAt': createdAt,
    };
  }
}
