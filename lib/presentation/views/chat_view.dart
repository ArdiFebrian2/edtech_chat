import 'package:edtech_chat/core/constants/color_theme.dart';
import 'package:edtech_chat/presentation/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chat_action_buttons.dart';
import '../widgets/empty_chat_state.dart';

class ChatView extends StatefulWidget {
  final String roomId;
  const ChatView({required this.roomId, super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController chatController = Get.put(ChatController());
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatController.listenToMessages(widget.roomId);
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Chat Room",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
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
            ChatActionButtons(roomId: widget.roomId),

            // Input Field
            ChatInputField(
              roomId: widget.roomId,
              messageController: messageController,
              chatController: chatController,
              onMessageSent: _scrollToBottom,
            ),
          ],
        ),
      ),
    );
  }
}
