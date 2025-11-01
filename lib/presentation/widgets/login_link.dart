// TODO Implement this library.
import 'package:edtech_chat/core/constants/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.grey[600], fontSize: 15),
        ),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ColorTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}