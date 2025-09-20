import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class Mytoken extends ChangeNotifier {
  String? token;

  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    notifyListeners();
    return token;
  }

  void setToken(String tok) async {
    token = tok;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tok);

    toastification.show(
      backgroundColor: Color.fromRGBO(199, 226, 201, 1),
      title: const Text('Success!'),
      description: const Text('Token Changed successfully'),
      type: ToastificationType.success, // Optional: success, info, warning, error
      alignment: Alignment.center, // Optional: customize position
      autoCloseDuration: const Duration(seconds: 2), // Optional: duration
    );
    notifyListeners();
  }
}
