// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/constants/color_theme.dart';

class EmptyRoomState extends StatelessWidget {
  final VoidCallback onCreateRoom;

  const EmptyRoomState({super.key, required this.onCreateRoom});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/listroom.png'),
          const SizedBox(height: 24),
          Text(
            'No chat rooms yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Create a new room to start chatting with your team',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
