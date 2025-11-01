import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/role_controller.dart';
import 'rooms_view.dart';

class RoleSelectView extends StatelessWidget {
  final AuthController authController = Get.find();
  final RoleController roleController = Get.put(RoleController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Role")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password")),
            const SizedBox(height: 10),
            Obx(() => Column(
              children: ["Tutor", "Parent", "Student"].map((role) {
                return RadioListTile<String>(
                  title: Text(role),
                  value: role.toLowerCase(),
                  groupValue: roleController.selectedRole.value,
                  onChanged: (val) => roleController.selectRole(val!),
                );
              }).toList(),
            )),
            ElevatedButton(
              onPressed: () async {
                await authController.register(
                  emailController.text,
                  passwordController.text,
                  roleController.selectedRole.value,
                );
                Get.off(() => RoomsView());
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
