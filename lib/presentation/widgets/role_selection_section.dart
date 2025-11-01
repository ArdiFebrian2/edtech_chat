// TODO Implement this library.
import 'package:flutter/material.dart';
import 'role_card.dart';

class RoleSelectionSection extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelectionSection({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  static final Map<String, Map<String, dynamic>> roles = {
    'tutor': {
      'icon': Icons.person_outline,
      'title': 'Tutor',
      'description': 'Guide and support students in learning.',
    },
    'parent': {
      'icon': Icons.family_restroom_outlined,
      'title': 'Parent',
      'description': 'Track and support your child’s academic progress.',
    },
    'student': {
      'icon': Icons.person,
      'title': 'Student',
      'description': 'Join classes, learn, and communicate with tutors.',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Select Your Role",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        ...roles.entries.map((entry) {
          return RoleCard(
            roleKey: entry.key,
            icon: entry.value['icon'],
            title: entry.value['title'],
            description: entry.value['description'],
            isSelected: selectedRole == entry.key,
            onTap: () => onRoleSelected(entry.key),
          );
        }).toList(),
      ],
    );
  }
}
