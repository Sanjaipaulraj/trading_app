import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MytokenProvider extends ChangeNotifier {
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
    notifyListeners();
  }
}
