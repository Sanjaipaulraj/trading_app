import 'package:flutter/material.dart';
import 'package:trading_app/pages/login_screen.dart' deferred as login_screen;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    login_screen.loadLibrary();
    return MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: login_screen.LoginPage()));
  }
}
