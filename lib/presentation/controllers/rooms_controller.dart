import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Map<String, dynamic>> rooms = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchRooms();
    super.onInit();
  }

  void fetchRooms() {
    _firestore.collection('rooms').snapshots().listen((snapshot) {
      rooms.value = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
