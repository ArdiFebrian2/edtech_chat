// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/constants/color_theme.dart';

class LoadingRoomState extends StatelessWidget {
  const LoadingRoomState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading rooms...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}