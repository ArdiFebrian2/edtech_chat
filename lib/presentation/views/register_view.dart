import 'package:edtech_chat/core/constants/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'room_list_view.dart';
import '../widgets/register_header.dart';
import '../widgets/register_form_fields.dart';
import '../widgets/role_selection_section.dart';
import '../widgets/register_button.dart';
import '../widgets/login_link.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController authController = Get.find();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedRole = 'student';
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    usernameC.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await authController.register(
        emailC.text.trim(),
        passC.text,
        selectedRole,
      );
      Get.snackbar(
        "Registration Successful",
        "Your account has been created. Please log in.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: ColorTheme.primary,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      );
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        "Registration Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const RegisterHeader(),
                  const SizedBox(height: 40),
                  RegisterFormFields(
                    emailController: emailC,
                    usernameController: usernameC,
                    passwordController: passC,
                    isPasswordVisible: _isPasswordVisible,
                    onPasswordVisibilityToggle: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                  const SizedBox(height: 16),
                  RoleSelectionSection(
                    selectedRole: selectedRole,
                    onRoleSelected: (role) {
                      setState(() => selectedRole = role);
                    },
                  ),
                  const SizedBox(height: 24),
                  RegisterButton(
                    isLoading: _isLoading,
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 24),
                  const LoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
