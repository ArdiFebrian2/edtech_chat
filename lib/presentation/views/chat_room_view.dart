import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import '../../core/constants/color_theme.dart';
import '../controllers/chat_controller.dart';

class ChatRoomView extends StatelessWidget {
  final String roomId;
  ChatRoomView({required this.roomId, super.key});

  final ChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.listenToMessages(roomId);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorTheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.group, color: ColorTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chat Room',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${controller.messages.length} messages',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Menu options
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start the conversation!',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }
        return DashChat(
  currentUser: ChatUser(
    id: controller.currentUserId,
 firstName: controller.currentUserName.value,

  ),
  messages: controller.messages
      .map(
        (m) => ChatMessage(
          text: m.text,
          user: ChatUser(
            id: m.authorId,
            firstName: m.authorName, // 🔹 tampilkan nama pengirim
          ),
          createdAt: m.createdAt,
        ),
      )
      .toList()
      .reversed
      .toList(),
  onSend: (ChatMessage message) async {
    if (message.text.trim().isEmpty) return;

    await controller.sendMessage(
      roomId,
      controller.currentUserId,
      message.text,
      controller.currentUserName.value,);
          },
          messageOptions: MessageOptions(
            currentUserContainerColor: ColorTheme.primary,
            containerColor: Colors.white,
            textColor: Colors.black87,
            currentUserTextColor: Colors.white,
            showTime: true,
            showOtherUsersAvatar: true,
            showCurrentUserAvatar: false,
            borderRadius: 16,
            messagePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            maxWidth: MediaQuery.of(context).size.width * 0.75,
            messageDecorationBuilder: (message, previousMessage, nextMessage) {
              return BoxDecoration(
                color: message.user.id == "me"
                    ? ColorTheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              );
            },
          ),
          inputOptions: InputOptions(
            alwaysShowSend: true,
            cursorStyle: const CursorStyle(color: ColorTheme.primary),
            inputDecoration: InputDecoration(
              hintText: 'Type a message...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: ColorTheme.primary,
                  width: 2,
                ),
              ),
            ),
            inputTextStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            sendButtonBuilder: (onSend) => Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: ColorTheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: onSend,
              ),
            ),
            inputToolbarPadding: const EdgeInsets.all(12),
            inputToolbarMargin: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
            ),
          ),
          messageListOptions: MessageListOptions(
            separatorFrequency: SeparatorFrequency.days,
            dateSeparatorBuilder: (date) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatDate(date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
