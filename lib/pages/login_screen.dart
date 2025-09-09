import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:trading_app/pages/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginIntent extends Intent {
  const LoginIntent();
}

class LoginPageState extends State<LoginPage> {
  final _passKeyController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final password = _passKeyController.text;
    Dio dio = Dio();

    if (password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter token';
      });
      return;
    }

    try {
      final data = json.encode({'password': password});
      final response = await dio.post(
        'https://example.com/api/login',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: data,
      );
      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid password';
          });
        }
      }
    } catch (error) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to authenticate. Please try again later.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: CallbackShortcuts(
        bindings: {const SingleActivator(LogicalKeyboardKey.enter): () => _login()},
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  autofocus: true,
                  controller: _passKeyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading ? CircularProgressIndicator() : ElevatedButton(onPressed: _login, child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
