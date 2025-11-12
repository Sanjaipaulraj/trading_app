import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/models/close_response_model.dart';
import 'package:trading_app/models/open_response_model.dart';
import 'package:trading_app/models/response_model.dart';
import 'package:trading_app/sections/automatic_closing_section.dart';
import 'package:trading_app/sections/conditon_title_section.dart';
import 'package:trading_app/sections/long_button_section.dart';
import 'package:trading_app/sections/short_button_section.dart';
import 'package:trading_app/sections/status_section.dart';
import 'package:trading_app/Providers/token_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

late List<ResponseModel> list;
typedef MenuEntry = DropdownMenuEntry<String>;

class HomeScreenState extends State<HomeScreen> {
  List<ResponseModel> list = [];
  bool isLoading = true;

  late TextEditingController _tokenController;
  final FocusNode _symbolFocusNode = FocusNode();
  final FocusNode _longButtonFocusNode = FocusNode();
  final FocusNode _shortButtonFocusNode = FocusNode();
  final FocusNode _closeButtonFocusNode = FocusNode();

  Future<void> _initializeApp(BuildContext context) async {
    _tokenController = TextEditingController();
    final provider = Provider.of<MytokenProvider>(context, listen: false);

    while (provider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final token = provider.token;

    if (token == null || token.isEmpty) {
      return;
    }

    list = await _getList();

    if (list.isNotEmpty) {
      Provider.of<ValueProvider>(context, listen: false).setDropdown(list.first.name ?? '');
    }
  }

  @override
  void dispose() {
    _symbolFocusNode.dispose();
    _longButtonFocusNode.dispose();
    _shortButtonFocusNode.dispose();
    _closeButtonFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openPosition(String actionType, num? takeProfit) async {
    final token = Provider.of<MytokenProvider>(context, listen: false).token;
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
    final symbol = Provider.of<ValueProvider>(context, listen: false).dropdown;
    final volume = Provider.of<ValueProvider>(context, listen: false).volume;
    var data = OpenPositionModel(actionType: actionType, symbol: symbol, volume: volume as num, takeProfit: takeProfit);
    final openResponse = await dio.post(
      'http://localhost: 3001/trade/open',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      data: jsonEncode(data),
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

  Future<List<ResponseModel>> _getList() async {
    final token = Provider.of<MytokenProvider>(context, listen: false).token;
    Dio dio = Dio(
      BaseOptions(connectTimeout: const Duration(seconds: 120), receiveTimeout: const Duration(seconds: 120)),
    );

    try {
      final response = await dio.get(
        'http://localhost:3001/trade/list',
        options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final parsedList = data.map((e) => ResponseModel.fromJson(e)).toList();

        toastification.show(
          backgroundColor: const Color.fromRGBO(199, 226, 201, 1),
          title: const Text('Success!'),
          description: const Text('List fetched successfully.'),
          type: ToastificationType.success,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
        return parsedList;
      } else {
        Provider.of<MytokenProvider>(context, listen: false).clearToken();
        toastification.show(
          backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
          title: const Text('Error!'),
          description: Text('Status code: ${response.statusCode}'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
        return [];
      }
    } on DioException catch (e) {
      //  Handle Dio-specific timeout cases
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        toastification.show(
          backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
          title: const Text('Timeout!'),
          description: const Text('Request timed out. Please try again later.'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        Provider.of<MytokenProvider>(context, listen: false).clearToken();
        toastification.show(
          backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
          title: const Text('Error!'),
          description: Text('Error: ${e.message}'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
      return [];
    } catch (e) {
      //  Catch unexpected errors
      toastification.show(
        backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: Text('Unexpected error: $e'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
      return [];
    }
  }

  Future<void> _onClosePosition(String actionType) async {
    final token = Provider.of<MytokenProvider>(context, listen: false).token;
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
    final symbol = Provider.of<ValueProvider>(context, listen: false).dropdown;
    final data = ClosePositionModel(actionType: actionType, symbol: symbol);
    final closeResponse = await dio.post(
      'http://localhost:3001/trade/close',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      data: jsonEncode(data),
    );
    try {
      if (closeResponse.statusCode == 200) {
        print(closeResponse.data);
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
    return FutureBuilder(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        final myTokenProvider = Provider.of<MytokenProvider>(context);

        //  Case 1: Still waiting (either token or list)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                Center(child: Text("Token getting...")),
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        //  Case 2: Error (optional)
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
        }

        //  Case 3: Token missing — show input screen
        final token = myTokenProvider.token;
        if (token == null || token.isEmpty) {
          return Scaffold(
            body: Container(
              color: const Color.fromRGBO(206, 194, 235, 1),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  const Text('Enter the token'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Token'),
                  ),
                  TextButton(
                    onPressed: () {
                      myTokenProvider.setToken(_tokenController.text);
                      setState(() {});
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        }

        final List<MenuEntry> menuEntries = list
            .map<MenuEntry>((ResponseModel item) => MenuEntry(value: item.name ?? "", label: item.name ?? ""))
            .toList();

        //  Case 5: Everything ready → show your main UI
        return Scaffold(
          backgroundColor: Color.fromRGBO(230, 230, 250, 1),
          drawer: Drawer(
            backgroundColor: const Color.fromRGBO(230, 230, 250, 1),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 8),
                  child: const Text('Symbol Status', style: TextStyle(color: Colors.black, fontSize: 22)),
                ),
                const Divider(color: Color.fromRGBO(79, 79, 79, 1)),
                const SizedBox(height: 6),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (var l in list)
                        ListTile(
                          title: Text(l.name ?? 'Data Not found'),
                          trailing: Text(
                            l.status ?? 'Data Not found',
                            style: TextStyle(
                              fontSize: 16,
                              color: l.status == 'live' ? Colors.green : Colors.grey.shade400,
                            ),
                          ),
                          onTap: () {
                            Provider.of<ValueProvider>(context, listen: false).setDropdown(l.name as String);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.name} clicked')));
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(101, 101, 255, 1),
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
                              Provider.of<MytokenProvider>(context, listen: false).setToken(enteredToken);
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
            title: Text('Auditplus Fx'),
          ),
          body: Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.keyL, LogicalKeyboardKey.control): const LongIntent(
                actionType: "ORDER_TYPE_BUY",
              ),
              LogicalKeySet(LogicalKeyboardKey.keyS, LogicalKeyboardKey.control): const ShortIntent(
                actionType: "ORDER_TYPE_SELL",
              ),
              LogicalKeySet(LogicalKeyboardKey.keyC, LogicalKeyboardKey.control): CloseIntent(
                actionType: "POSITIONS_CLOSE_SYMBOL",
              ),
            },
            child: Actions(
              actions: {
                LongIntent: CallbackAction<LongIntent>(
                  onInvoke: (intent) {
                    _openPosition('ORDER_TYPE_BUY', null);
                    return null;
                  },
                ),
                ShortIntent: CallbackAction<ShortIntent>(
                  onInvoke: (intent) {
                    _openPosition('ORDER_TYPE_SELL', null);
                    return null;
                  },
                ),
                CloseIntent: CallbackAction<CloseIntent>(
                  onInvoke: (intent) {
                    _onClosePosition(intent.actionType);
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
                              Consumer<ValueProvider>(
                                builder: (context, drop, child) {
                                  return SizedBox(
                                    child: DropdownMenu<String>(
                                      width: 150,
                                      initialSelection: drop.dropdown,
                                      dropdownMenuEntries: menuEntries,
                                      onSelected: (String? value) {
                                        setState(() {
                                          Provider.of<ValueProvider>(context, listen: false).setDropdown(value ?? '');
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Container(
                            height: 55,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: Provider.of<ValueProvider>(context, listen: false).volume.toString(),
                              onChanged: (newValue) {
                                final parsedValue = double.tryParse(newValue);
                                if (parsedValue != null) {
                                  Provider.of<ValueProvider>(context, listen: false).setVolume(parsedValue);
                                }
                              },
                              decoration: InputDecoration(border: OutlineInputBorder()),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          Consumer<MytokenProvider>(
                            builder: (context, myToken, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(100, 55),
                                  backgroundColor: Color.fromRGBO(101, 101, 255, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Color.fromRGBO(27, 29, 29, 1), width: 2),
                                  ),
                                  elevation: 8.0,
                                  foregroundColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                ),
                                onPressed: () {
                                  final token = Provider.of<MytokenProvider>(listen: false, context).token;
                                  if (token != null) {
                                    Actions.invoke(context, CloseIntent(actionType: "POSITIONS_CLOSE_SYMBOL"));
                                    toastification.show(
                                      backgroundColor: Color.fromRGBO(180, 231, 240, 1),
                                      context: context,
                                      title: const Text('Closed!'),
                                      description: const Text('Closed successfully'),
                                      type: ToastificationType.info,
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
      },
    );
  }
}
