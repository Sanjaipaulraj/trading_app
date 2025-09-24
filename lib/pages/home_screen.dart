import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/sections/automatic_closing_section.dart';
import 'package:trading_app/sections/conditon_title_section.dart';
import 'package:trading_app/sections/long_button_section.dart';
import 'package:trading_app/sections/short_button_section.dart';
import 'package:trading_app/sections/status_section.dart';
import 'package:trading_app/token_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

const List<String> list = <String>['AAPL', 'GOOGL', 'MSFT', 'DJIA', 'SPX'];
typedef MenuEntry = DropdownMenuEntry<String>;

class HomeScreenState extends State<HomeScreen> {
  String token = '';
  static final List<MenuEntry> menuEntries = List.unmodifiable(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = list.first;
  late TextEditingController _tokenController;
  final FocusNode _symbolFocusNode = FocusNode();
  final FocusNode _longButtonFocusNode = FocusNode();
  final FocusNode _shortButtonFocusNode = FocusNode();
  final FocusNode _closeButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController();
    // Initialize token from Provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? fetchedToken = await Provider.of<Mytoken>(context, listen: false).getToken();
      setState(() {
        token = fetchedToken ?? ''; // Safely handle null token
      });
    });
  }

  @override
  void dispose() {
    _symbolFocusNode.dispose();
    _longButtonFocusNode.dispose();
    _shortButtonFocusNode.dispose();
    _closeButtonFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openPosition(String type) async {
    final token = Provider.of<Mytoken>(context, listen: false).token;
    if (token == null) {
      toastification.show(
        backgroundColor: Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: const Text('Token is empty!'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }

    Dio dio = Dio();
    final direction = type;
    final symbol = dropdownValue;
    final data = json.encode({'symbol': symbol, 'direction': direction});
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
    final token = Provider.of<Mytoken>(context, listen: false).token;
    if (token == null) {
      toastification.show(
        backgroundColor: Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: const Text('Token is empty!'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }

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
      appBar: AppBar(
        actions: <Widget>[
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
                          String enteredToken = _tokenController.text;
                          Provider.of<Mytoken>(context, listen: false).setToken(enteredToken);
                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.settings)),
          ),
        ],
        leading: GestureDetector(
          onTap: () => showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Menu Dialog',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: Icon(Icons.menu),
        ),
        title: Text('Auditplus'),
      ),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: DropdownMenu<String>(
                              width: 130,
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
                      Container(
                        height: 55,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      Consumer<Mytoken>(
                        builder: (context, myToken, child) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(100, 55),
                              backgroundColor: Colors.lightBlueAccent,
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
                              final token = Provider.of<Mytoken>(listen: false, context).token;
                              if (token != null) {
                                Actions.invoke(context, CloseIntent());
                                toastification.show(
                                  backgroundColor: Color.fromRGBO(199, 226, 201, 1),
                                  context: context,
                                  title: const Text('Closed!'),
                                  description: const Text('Closed successfully'),
                                  type: ToastificationType.success,
                                  alignment: Alignment.center,
                                  autoCloseDuration: const Duration(seconds: 2),
                                );
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
                            child: Text('Close'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ConditonTitleSection(), LongButtonSection(), ShortButtonSection()],
                  ),
                ),
                Divider(),
                StatusScreen(),
                Divider(),
                AutomaticClosingSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
