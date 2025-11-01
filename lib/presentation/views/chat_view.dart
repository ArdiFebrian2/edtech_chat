import 'package:edtech_chat/core/constants/color_theme.dart' show ColorTheme;
import 'package:edtech_chat/presentation/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chat_action_buttons.dart';
import '../widgets/empty_chat_state.dart';

class ChatView extends StatelessWidget {
  final String roomId;
  ChatView({required this.roomId, super.key});

  final ChatController chatController = Get.put(ChatController());
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    chatController.listenToMessages(roomId);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Chat Room",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: ColorTheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: Obx(() {
                if (chatController.messages.isEmpty) {
                  return const EmptyChatState();
                }
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  reverse: true,
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chatController.messages[index];
                    return ChatMessageItem(message: msg);
                  },
                );
              }),
            ),

            // Action Buttons
            ChatActionButtons(roomId: roomId),

            // Input Field
            ChatInputField(
              roomId: roomId,
              messageController: messageController,
              chatController: chatController,
              onMessageSent: () {
                // Auto scroll to bottom after sending
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
