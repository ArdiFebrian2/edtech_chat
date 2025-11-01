import 'package:edtech_chat/core/constants/color_theme.dart';
import 'package:edtech_chat/data/datasources/local_isar_service.dart';
import 'package:edtech_chat/presentation/controllers/auth_controller.dart';
import 'package:edtech_chat/presentation/views/room_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/views/login_view.dart';
import 'presentation/views/register_view.dart';
import 'presentation/views/chat_room_view.dart';
import 'presentation/controllers/chat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await LocalIsarService.init();

  await Firebase.initializeApp();
  Get.put(ChatController());
  Get.put(AuthController());
  runApp(const EdtechChatApp());
}

class EdtechChatApp extends StatelessWidget {
  const EdtechChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EdTech Chat',
      theme: ThemeData(
         textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/signup', page: () => RegisterView()),
        GetPage(name: '/chat_list', page: () => RoomListView()),
        GetPage(name: '/chat_room', page: () => ChatRoomView(roomId: '',)),
      ],
    );
  }
}
