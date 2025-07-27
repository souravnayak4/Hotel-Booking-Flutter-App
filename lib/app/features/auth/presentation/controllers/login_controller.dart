import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotelbooking/app/features/auth/domain/auth_repository.dart';

class LoginController with ChangeNotifier {
  final AuthRepository authRepository;

  bool isLoading = false;
  String? errorMessage;

  LoginController(this.authRepository);

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await authRepository.login(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Please enter a valid email address.';
      } else {
        errorMessage = 'Login failed: ${e.message ?? e.code}';
      }
    } catch (e) {
      errorMessage = 'Something went wrong. Please check your connection.';
    }

    isLoading = false;
    notifyListeners();
  }
}
