import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'dart:convert';

import 'package:trading_app/pages/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final username = _usernameController.text;
    final password = _passwordController.text;
    Dio dio = Dio();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter both username and password';
      });
      return;
    }

    try {
      final data = json.encode({'username': username, 'password': password});
      final response = await dio.post(
        'https://example.com/api/login',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: data,
      );
      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(token: '1')));
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid username or password';
          });
        }
      }
    } catch (error) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(token: '1234')));
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  autofocus: true,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: TextField(
                  autofocus: true,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
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
