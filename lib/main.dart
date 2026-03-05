import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:auditplus_fx/Providers/checked_box_provider.dart';
import 'package:auditplus_fx/Providers/value_provider.dart';
import 'package:auditplus_fx/pages/home_screen.dart';
import 'package:auditplus_fx/Providers/token_provider.dart';

void main() {
  runApp(
    ToastificationWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MytokenProvider()),
          ChangeNotifierProvider(create: (context) => CheckedBoxProvider()),
          ChangeNotifierProvider(create: (context) => ValueProvider(context)),
        ],
        child: MainApp(),
      ),
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
