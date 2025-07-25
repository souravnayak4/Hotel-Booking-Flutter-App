import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotelbooking/app/core/services/shared_pref_service.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/database.dart';
import 'package:hotelbooking/app/core/services/network_service.dart';
import 'package:hotelbooking/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:random_string/random_string.dart';

class SignupController extends ChangeNotifier {
  final SharedPrefServiceHelper _sharedPrefService = SharedPrefServiceHelper();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  bool isLoading = false;

  SignupController(AuthRepositoryImpl read);

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return "Please fill all fields";
    }

    bool hasInternet = await NetworkServiceHelper.hasInternetConnection();
    if (!hasInternet) {
      return "No Internet Connection";
    }

    try {
      isLoading = true;
      notifyListeners();

      String id = randomAlphaNumeric(10);

      Map<String, dynamic> userInfoMap = {
        "Name": name,
        "Email": email,
        "Id": id,
      };

      // Save locally
      await _sharedPrefService.saveUserName(name);
      await _sharedPrefService.saveUserEmail(email);
      await _sharedPrefService.saveUserId(id);

      // Save in database
      await _databaseMethods.addUserInfo(userInfoMap, id);

      isLoading = false;
      notifyListeners();
      return null; // success
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.code == "weak-password") {
        return "Password provided is too weak";
      } else if (e.code == "email-already-in-use") {
        return "Account already exists";
      } else {
        return "Registration failed: ${e.message}";
      }
    }
  }
}
