import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MytokenProvider extends ChangeNotifier {
  String? token;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  MytokenProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    _isLoading = false;
    notifyListeners();
  }

  void setToken(String tok) async {
    token = tok;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tok);
    notifyListeners();
  }

  void clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = null;
    notifyListeners();
  }
}
