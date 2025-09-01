import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter both username and password';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://example.com/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);
        // final token = responseData['token'];
        // final id = responseData['id'];

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(token: '10')));
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
