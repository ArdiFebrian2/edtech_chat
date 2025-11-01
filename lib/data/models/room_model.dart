class RoomModel {
  final String id;
  final String type;
  final List<String> members;

  RoomModel({required this.id, required this.type, required this.members});

  Map<String, dynamic> toMap() {
    return {'type': type, 'members': members};
  }

  factory RoomModel.fromMap(Map<String, dynamic> map, String id) {
    return RoomModel(id: id, type: map['type'], members: List<String>.from(map['members']));
  }
}
