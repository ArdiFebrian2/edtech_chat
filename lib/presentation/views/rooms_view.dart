import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rooms_controller.dart';
import 'chat_view.dart';

class RoomsView extends StatelessWidget {
  final RoomsController roomsController = Get.put(RoomsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rooms"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.add),
        onPressed: () {
          // Contoh: Tambah room dummy (mock)
          Get.snackbar("Info", "Create new room (mock)");
        },
      ),
      body: Obx(() {
        if (roomsController.rooms.isEmpty) {
          return const Center(child: Text("No rooms yet"));
        }
        return ListView.builder(
          itemCount: roomsController.rooms.length,
          itemBuilder: (context, index) {
            final room = roomsController.rooms[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.chat_bubble)),
              title: Text(room['id'] ?? 'Unknown Room'),
              subtitle: Text(room['type'] ?? 'trio'),
              onTap: () {
                Get.to(() => ChatView(roomId: room['id']));
              },
            );
          },
        );
      }),
    );
  }
}
