import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weddingcheck/views/auth/loginscreen.dart';
import 'package:weddingcheck/views/splashscreen.dart';

class UiProvider extends ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  late SharedPreferences storage;

  // Method to check and uncheck remember me
  // we need to do it using Provider state management
  toggleCheck() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  // When login is successful, then we will true the value to remember our login session
  setRememberMe() {
    _rememberMe = true;

    // we store the value in secure storage to be remembered
    storage.setBool("rememberMe", _rememberMe);
    notifyListeners();
  }

  logout(context) {
    // set rememberme value to false
    _rememberMe = false;
    storage.setBool("rememberMe", _rememberMe);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Splash(),
      ),
    );
    notifyListeners();
  }

  initStorage() async {
    storage = await SharedPreferences.getInstance();
    // get the value of remember me
    _rememberMe = storage.getBool("rememberMe") ?? false;
  }
}
