import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/pages/home_screen.dart';
import 'package:trading_app/token_provider.dart';

void main() {
  runApp(
    ToastificationWrapper(
      child: ChangeNotifierProvider(create: (context) => Mytoken(), child: MainApp()),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: HomeScreen()));
  }
}
