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
      padding: EdgeInsets.only(
        bottom: 8,
        left: isMyMessage ? 60 : 16,
        right: isMyMessage ? 16 : 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMyMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMyMessage)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[300],
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ),
          Flexible(child: _buildMessageBubble(context)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    final timestamp = message.createdAt ?? DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: isMyMessage
            ? LinearGradient(
                colors: [Colors.blue[500]!, Colors.blue[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isMyMessage
            ? null
            : isDark
            ? Colors.grey[850]
            : Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMyMessage ? 18 : 4),
          bottomRight: Radius.circular(isMyMessage ? 4 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: isMyMessage
                ? Colors.blue.withOpacity(0.25)
                : Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: isMyMessage
            ? null
            : Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                width: 1,
              ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blue[900]!.withOpacity(0.3)
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.authorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.blue[300] : Colors.blue[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                RoleBadge(role: message.authorRole),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Text(
            message.text,
            style: TextStyle(
              fontSize: 15,
              color: isMyMessage
                  ? Colors.white
                  : isDark
                  ? Colors.grey[100]
                  : Colors.grey[900],
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 13,
                color: isMyMessage
                    ? Colors.white.withOpacity(0.75)
                    : isDark
                    ? Colors.grey[500]
                    : Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isMyMessage
                      ? Colors.white.withOpacity(0.75)
                      : isDark
                      ? Colors.grey[500]
                      : Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final time = DateFormat('HH:mm').format(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mnt lalu';
    } else if (difference.inHours < 24) {
      return time;
    } else if (difference.inDays == 1) {
      return 'Kemarin, $time';
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEEE', 'id_ID').format(timestamp)}, $time';
    } else {
      return '${DateFormat('dd MMM', 'id_ID').format(timestamp)}, $time';
    }
  }
}
