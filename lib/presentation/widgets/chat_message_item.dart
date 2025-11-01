import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message_entity.dart';
import '../widgets/role_badge.dart';

class ChatMessageItem extends StatelessWidget {
  final MessageEntity message;

  const ChatMessageItem({required this.message, super.key});

  bool get isMyMessage {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return message.authorId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMyMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[_buildAvatar(), const SizedBox(width: 8)],
          Flexible(child: _buildMessageBubble(context)),
          if (isMyMessage) ...[const SizedBox(width: 8), _buildAvatar()],
        ],
      ),
    );
  }

  /// 🔹 Avatar pengguna
  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[300],
      backgroundImage: (message.authorPhoto.isNotEmpty)
          ? NetworkImage(message.authorPhoto)
          : null,
      child: (message.authorPhoto.isEmpty)
          ? Icon(Icons.person, color: Colors.grey[600], size: 20)
          : null,
    );
  }

  /// 🔹 Bubble pesan
  Widget _buildMessageBubble(BuildContext context) {
    final timestamp = _getMessageTimestamp(message);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMyMessage
            ? Colors.green[600]
            : Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMyMessage ? 16 : 4),
          bottomRight: Radius.circular(isMyMessage ? 4 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isMyMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.authorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(width: 6),
                RoleBadge(role: message.authorRole),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Text(
            message.text,
            style: TextStyle(
              fontSize: 15,
              color: isMyMessage ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(timestamp),
            style: TextStyle(
              fontSize: 11,
              color: isMyMessage ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Pastikan timestamp selalu DateTime
  DateTime _getMessageTimestamp(MessageEntity message) {
    final createdAt = message.createdAt;
    return createdAt;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final time = DateFormat('HH:mm').format(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now • $time';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago • $time';
    } else if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEE').format(timestamp)} • $time';
    } else {
      return '${DateFormat('dd/MM').format(timestamp)} • $time';
    }
  }
}
