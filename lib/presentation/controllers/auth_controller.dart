import 'dart:ui';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../presentation/views/room_list_view.dart';
import '../../presentation/views/login_view.dart'; // pastikan ada halaman login

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var isLoggedIn = false.obs;
  var userRole = ''.obs;
  var isLoading = false.obs;

  // ---------------------- REGISTER ----------------------
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
    } on FirebaseAuthException catch (e) {
      String message = switch (e.code) {
        'email-already-in-use' => "Email already registered.",
        'weak-password' => "Password too weak.",
        'invalid-email' => "Invalid email format.",
        _ => "Something went wrong",
      };

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

  // ---------------------- LOGIN ----------------------
  Future<void> handleLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password must be filled.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }

    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final userDoc = await _db.collection('users').doc(uid).get();

        if (userDoc.exists) {
          userRole.value = userDoc.data()?['role'] ?? '';
        }

        isLoggedIn.value = true;

        Get.offAll(() => RoomListView());
      }
    } on FirebaseAuthException catch (e) {
      String message = switch (e.code) {
        'user-not-found' => "No user found with that email.",
        'wrong-password' => "Incorrect password.",
        'invalid-email' => "Invalid email format.",
        _ => "Login failed",
      };

      Get.snackbar(
        "Login Error",
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
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------- LOGOUT ----------------------
  Future<void> logout() async {
    try {
      await _auth.signOut();

      isLoggedIn.value = false;
      userRole.value = '';

      Get.offAll(() => LoginView()); // arahkan ke halaman login
      Get.snackbar(
        "Logout Berhasil",
        "Kamu telah keluar dari akun.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      Get.snackbar(
        "Logout Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  String get uid => _auth.currentUser?.uid ?? '';
}
