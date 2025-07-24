import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/auth/domain/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;

  bool isLoading = false;

  AuthProvider(this.authRepository);

  Future<String?> signup(String name, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await authRepository.signup(name, email, password);
      isLoading = false;
      notifyListeners();
      return null; // Success
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await authRepository.login(email, password);
      isLoading = false;
      notifyListeners();
      return null; // Success
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
