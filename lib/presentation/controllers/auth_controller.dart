import 'dart:ui';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var isLoggedIn = false.obs;
  var userRole = ''.obs;

  Future<void> register(String email, String password, String role) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCred.user?.uid;
      if (userId == null)
        throw Exception("User ID not found after registration");
      final String name = email.split('@').first;
      await _db.collection('users').doc(userId).set({
        'uid': userId,
        'email': email,
        'role': role,
        'name': name,
        'photoUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Account created successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";
      if (e.code == 'email-already-in-use')
        message = "Email already registered.";
      if (e.code == 'weak-password') message = "Password too weak.";
      if (e.code == 'invalid-email') message = "Invalid email format.";

      Get.snackbar(
        "Registration Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final userDoc = await _db.collection('users').doc(uid).get();

        if (userDoc.exists) {
          userRole.value = userDoc.data()?['role'] ?? '';
        } else {
          userRole.value = '';
        }

        isLoggedIn.value = true;

        Get.snackbar(
          "Welcome Back",
          "Login successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2196F3),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found')
        message = "No user found with that email.";
      if (e.code == 'wrong-password') message = "Incorrect password.";
      if (e.code == 'invalid-email') message = "Invalid email format.";

      Get.snackbar(
        "Login Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      Get.snackbar(
        "⚠️ Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }
  String get uid => _auth.currentUser?.uid ?? '';
}
