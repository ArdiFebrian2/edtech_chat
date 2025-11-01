// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../domain/entities/room_entity.dart';
import '../../core/constants/color_theme.dart';
import '../../core/services/user_service.dart';

class RoomCard extends StatelessWidget {
  final RoomEntity room;
  final int index;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final memberNames = room.members
        .map((m) => (m['name'] ?? m['role'] ?? 'Member').toString())
        .take(3)
        .join(', ');

    final memberCount = room.members.length;
    final cardColor = _getCardColor(index);
    final creatorId = _getCreatorId();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAvatar(cardColor, memberCount),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildContent(creatorId, memberCount, memberNames, cardColor),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Color cardColor, int memberCount) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor.withOpacity(0.8), cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.group_rounded,
            color: Colors.white,
            size: 28,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$memberCount',
                style: TextStyle(
                  color: cardColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String creatorId, int memberCount, String memberNames, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: FutureBuilder<String>(
                future: UserService.instance.getUserName(creatorId),
                builder: (context, snapshot) {
                  String displayText;

                  if (creatorId.isEmpty) {
                    displayText = 'Unknown';
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    displayText = 'Loading...';
                  } else if (snapshot.hasError) {
                    displayText = 'Unknown';
                  } else {
                    displayText = snapshot.data ?? 'Unknown';
                  }

                  return Text(
                    'Room by $displayText',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: ColorTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$memberCount members',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ColorTheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.people_outline,
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                memberNames,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }

  String _getCreatorId() {
    if (room.createdBy != null && room.createdBy.isNotEmpty) {
      return room.createdBy;
    }
    return room.memberIds.isNotEmpty ? room.memberIds.first : '';
  }
}