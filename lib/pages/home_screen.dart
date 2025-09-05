import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

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
  static final List<MenuEntry> menuEntries = List.unmodifiable(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  late String token;
  String dropdownValue = list.first;
  late TextEditingController _volumeController;
  final FocusNode _symbolFocusNode = FocusNode();
  final FocusNode _volumeFocusNode = FocusNode();
  final FocusNode _longButtonFocusNode = FocusNode();
  final FocusNode _shortButtonFocusNode = FocusNode();
  final FocusNode _closeButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController();
    token = widget.token;
  }

  @override
  void dispose() {
    _symbolFocusNode.dispose();
    _volumeFocusNode.dispose();
    _longButtonFocusNode.dispose();
    _shortButtonFocusNode.dispose();
    _closeButtonFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openPosition(String type) async {
    Dio dio = Dio();
    final direction = type;
    final lot = num.parse(_volumeController.text);
    final data = json.encode({'symbol': dropdownValue, 'lot': lot, 'direction': direction});
    final openResponse = await dio.post(
      'http://192.168.1.60:8001/trade/open',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      data: data,
    );
    try {
      if (openResponse.statusCode == 200) {
        print(openResponse.data);
      } else {
        print(openResponse.statusCode);
      }
    } catch (_) {
      print('Network Error');
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
        print(closeResponse.data);
      } else {
        print(closeResponse.statusCode);
      }
    } catch (_) {
      print('Network Error');
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;

      if (key == LogicalKeyboardKey.arrowRight && _longButtonFocusNode.hasFocus) {
        _shortButtonFocusNode.requestFocus();
      } else if (key == LogicalKeyboardKey.arrowLeft && _shortButtonFocusNode.hasFocus) {
        _longButtonFocusNode.requestFocus();
      } else if (key == LogicalKeyboardKey.arrowUp && _closeButtonFocusNode.hasFocus) {
        _longButtonFocusNode.requestFocus();
      } else if (key == (LogicalKeyboardKey.control) && _longButtonFocusNode.hasFocus) {
        _volumeFocusNode.requestFocus();
      } else if (key == LogicalKeyboardKey.arrowDown &&
          (_longButtonFocusNode.hasFocus || _shortButtonFocusNode.hasFocus)) {
        _closeButtonFocusNode.requestFocus();
      } else if (key == LogicalKeyboardKey.arrowDown && _volumeFocusNode.hasFocus) {
        _longButtonFocusNode.requestFocus();
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo app')),
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: _handleKeyEvent,
        child: Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.keyL): const LongIntent(),
            LogicalKeySet(LogicalKeyboardKey.keyS): const ShortIntent(),
            LogicalKeySet(LogicalKeyboardKey.keyC): const CloseIntent(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Symbol'),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 150,
                      child: Focus(
                        focusNode: _symbolFocusNode,
                        child: DropdownMenu<String>(
                          initialSelection: list.first,
                          onSelected: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          dropdownMenuEntries: menuEntries,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Volume"),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 150,
                      child: Focus(
                        focusNode: _volumeFocusNode,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          controller: _volumeController,
                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Quantity'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Focus(
                      autofocus: true,
                      child: Builder(
                        builder: (context) => ElevatedButton(
                          focusNode: _longButtonFocusNode,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(100, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.lightGreen, width: 2),
                            ),
                            elevation: 8.0,
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          onPressed: () {
                            Actions.invoke(context, const LongIntent());
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
                            fixedSize: Size(100, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.red, width: 2),
                            ),
                            elevation: 8.0,
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          onPressed: () {
                            Actions.invoke(context, const ShortIntent());
                          },
                          child: Text('Short'),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Focus(
                        autofocus: true,
                        child: Builder(
                          builder: (context) => ElevatedButton(
                            focusNode: _closeButtonFocusNode,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(90, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(30),
                                side: BorderSide(color: Colors.black, width: 2),
                              ),
                              elevation: 0,
                              foregroundColor: Colors.black,
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                            onPressed: () {
                              Actions.invoke(context, CloseIntent());
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
      ),
    );
  }
}
