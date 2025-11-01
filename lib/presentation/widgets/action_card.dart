import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onPressed;
  final Color color;

  const ActionCard({
    required this.title,
    required this.buttonText,
    required this.onPressed,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: color.withOpacity(0.1),
      child: ListTile(
        title: Text(title),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ),
    );
  }
}
