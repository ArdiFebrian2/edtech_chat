import 'package:flutter/material.dart';

class RoleBadge extends StatelessWidget {
  final String role;
  const RoleBadge({required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (role) {
      case 'tutor':
        color = Colors.orange;
        break;
      case 'parent':
        color = Colors.blue;
        break;
      default:
        color = Colors.green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(role, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}
