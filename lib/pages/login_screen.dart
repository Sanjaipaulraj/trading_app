// import 'package:flutter/material.dart';
// import 'package:trading_app/pages/trade.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String password = "654321";
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 250,
//           child: TextField(
//             keyboardType: TextInputType.text,
//             controller: _controller,
//             autofocus: true,
//             // obscureText: true, //hides the text
//             decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
//             onSubmitted: (String value) async {
//               if (value != password) {
//                 await showDialog<void>(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text('Incorrect Password!'),
//                       content: Text('"$value",is not a recognize password.'),
//                       actions: <Widget>[
//                         TextButton(
//                           autofocus: true,
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text('OK'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               } else {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => TradeScreen()));
//               }
//             },
//           ),
//         ),
//         SizedBox(height: 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           //   children: [ElevatedButton(onPressed: () => TradeScreen(), child: Text("Submit"))],
//         ),
//       ],
//     );
//   }
// }

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
        Uri.parse('https:/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);
        // final token = responseData['token'];

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(token: '1')));
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
