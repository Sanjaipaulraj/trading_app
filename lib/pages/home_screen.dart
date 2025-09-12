import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

const List<String> list = <String>['AAPL', 'GOOGL', 'MSFT', 'DJIA', 'SPX'];
typedef MenuEntry = DropdownMenuEntry<String>;

class LongIntent extends Intent {
  const LongIntent();
}

class ShortIntent extends Intent {
  const ShortIntent();
}

class CloseIntent extends Intent {
  const CloseIntent();
}

class HomeScreenState extends State<HomeScreen> {
  String token = '';
  static final List<MenuEntry> menuEntries = List.unmodifiable(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = list.first;
  late TextEditingController _volumeController;
  late TextEditingController _tokenController;
  final FocusNode _volumeFocusNode = FocusNode();
  final FocusNode _longButtonFocusNode = FocusNode();
  final FocusNode _shortButtonFocusNode = FocusNode();
  final FocusNode _closeButtonFocusNode = FocusNode();

  Future<void> _changeToken(String tok) async {
    if (tok.isEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tok);
    setState(() {
      token = tok; // Update the state and rebuild the widget
    });
    toastification.show(
      backgroundColor: Color.fromRGBO(199, 226, 201, 1),
      title: const Text('Success!'),
      description: const Text('Token Changed successfully'),
      type: ToastificationType.success, // Optional: success, info, warning, error
      alignment: Alignment.center, // Optional: customize position
      autoCloseDuration: const Duration(seconds: 2), // Optional: duration
    );
  }

  Future<void> _getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController();
    _tokenController = TextEditingController();
    _getToken();
  }

  void reset() {
    _volumeController.clear();
    setState(() {});
  }

  Future<void> _openPosition(String type) async {
    Dio dio = Dio();
    final direction = type;
    final symbol = dropdownValue;
    final lot = num.parse(_volumeController.text);
    final data = json.encode({'symbol': symbol, 'lot': lot, 'direction': direction});
    final openResponse = await dio.post(
      'http://192.168.1.60:8001/trade/open',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      data: data,
    );
    try {
      if (openResponse.statusCode == 200) {
        toastification.show(
          backgroundColor: Color.fromRGBO(199, 226, 201, 1),
          title: const Text('Success!'),
          description: const Text('Send successfuly'),
          type: ToastificationType.success,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        toastification.show(
          backgroundColor: Color.fromRGBO(242, 186, 185, 1),
          title: const Text('Error!'),
          description: Text('Status code : ${openResponse.statusCode}'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      toastification.show(
        backgroundColor: Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: Text('Error occurs : $e'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _onClosePosition() async {
    Dio dio = Dio();
    final closeResponse = await dio.post(
      'http://192.168.1.60:8001/trade/close',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
    );
    try {
      if (closeResponse.statusCode == 200) {
        toastification.show(
          backgroundColor: Color.fromRGBO(199, 226, 201, 1),
          title: const Text('Success!'),
          description: const Text('Send successfully'),
          type: ToastificationType.success,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        toastification.show(
          backgroundColor: Color.fromRGBO(242, 186, 185, 1),
          title: const Text('Error!'),
          description: Text('Status code : ${closeResponse.statusCode}'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      toastification.show(
        backgroundColor: Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: Text('Error occurs : $e'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trading app')),
      body: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.keyL, LogicalKeyboardKey.control): const LongIntent(),
          LogicalKeySet(LogicalKeyboardKey.keyS, LogicalKeyboardKey.control): const ShortIntent(),
          LogicalKeySet(LogicalKeyboardKey.keyC, LogicalKeyboardKey.control): const CloseIntent(),
        },
        child: Actions(
          actions: {
            LongIntent: CallbackAction<LongIntent>(
              onInvoke: (intent) {
                _openPosition('buy');
                return null;
              },
            ),
            ShortIntent: CallbackAction<ShortIntent>(
              onInvoke: (intent) {
                _openPosition('sell');
                return null;
              },
            ),
            CloseIntent: CallbackAction<CloseIntent>(
              onInvoke: (intent) {
                _onClosePosition();
                return null;
              },
            ),
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Enter the token'),
                          const SizedBox(height: 15),
                          TextField(
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            controller: _tokenController,
                            decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Token'),
                          ),
                          TextButton(
                            onPressed: () {
                              _changeToken(_tokenController.text);
                              Navigator.pop(context);
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Change token",
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 16),
                    ),
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      'Symbol',
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      child: DropdownMenu<String>(
                        width: 250,
                        initialSelection: list.first,
                        onSelected: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        dropdownMenuEntries: menuEntries,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      "Volume",
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(width: 30),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: Focus(
                        focusNode: _volumeFocusNode,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          controller: _volumeController,
                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Qty'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 20.0, bottom: 8.0),
                child: Row(
                  spacing: 20,
                  children: [
                    Focus(
                      autofocus: true,
                      child: Builder(
                        builder: (context) => ElevatedButton(
                          focusNode: _longButtonFocusNode,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(170, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                            elevation: 8.0,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.lightGreen,
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          onPressed: () {
                            if (token.isNotEmpty) {
                              Actions.invoke(context, const LongIntent());
                              toastification.show(
                                backgroundColor: Color.fromRGBO(199, 226, 201, 1),
                                context: context,
                                title: const Text('Success!'),
                                description: const Text('Your value submited successfully'),
                                type: ToastificationType.success,
                                alignment: Alignment.center,
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                              reset();
                            } else {
                              toastification.show(
                                backgroundColor: Color.fromRGBO(242, 186, 185, 1),
                                context: context,
                                title: const Text('Error!'),
                                description: const Text('Your token is empty'),
                                type: ToastificationType.error,
                                alignment: Alignment.center,
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                            }
                          },
                          child: Text('Long'),
                        ),
                      ),
                    ),
                    Focus(
                      autofocus: true,
                      child: Builder(
                        builder: (context) => ElevatedButton(
                          focusNode: _shortButtonFocusNode,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(170, 60),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                            elevation: 8.0,
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          onPressed: () {
                            if (token.isNotEmpty) {
                              Actions.invoke(context, const ShortIntent());
                              toastification.show(
                                backgroundColor: Color.fromRGBO(199, 226, 201, 1),
                                context: context,
                                title: const Text('Success!'),
                                description: const Text('Your value submited successfully'),
                                type: ToastificationType.success,
                                alignment: Alignment.center,
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                              reset();
                            } else {
                              toastification.show(
                                backgroundColor: Color.fromRGBO(242, 186, 185, 1),
                                context: context,
                                title: const Text('Error!'),
                                description: const Text('Your token is empty'),
                                type: ToastificationType.error,
                                alignment: Alignment.center,
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                            }
                          },
                          child: Text('Short'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 40),
                child: Row(
                  children: [
                    Focus(
                      autofocus: true,
                      child: Builder(
                        builder: (context) => ElevatedButton(
                          focusNode: _closeButtonFocusNode,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(30),
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                            elevation: 0,
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(167, 205, 248, 1),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          onPressed: () {
                            if (token.isNotEmpty) {
                              Actions.invoke(context, CloseIntent());
                              reset();
                            } else {
                              reset();
                            }
                          },
                          child: Text('Close'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
