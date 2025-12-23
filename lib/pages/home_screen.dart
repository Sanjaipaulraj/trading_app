import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/models/close_request_model.dart';
import 'package:trading_app/models/open_request_model.dart';
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

class HomeScreenState extends State<HomeScreen> {
  List<ResponseModel> list = [];
  List<SearchFieldListItem<String>> symbols = [];
  bool isLoading = true;

  late TextEditingController _tokenController;
  late FocusNode _symbolFocusNode;
  final FocusNode _longButtonFocusNode = FocusNode();
  final FocusNode _shortButtonFocusNode = FocusNode();
  final FocusNode _closeButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _symbolFocusNode = FocusNode();
    _tokenController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp(context);
    });
  }

  Future<void> _initializeApp(BuildContext context) async {
    final provider = Provider.of<MytokenProvider>(context, listen: false);

    while (provider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final token = provider.token;

    if (token == null || token.isEmpty) {
      return;
    }

    list = await _getList();

    symbols = list.map((ResponseModel el) {
      return SearchFieldListItem<String>(
        //  search will be performed on this value
        el.name ?? "",
        // value to set in input on click, defaults to searchKey (optional)
        value: el.name.toString(),
      );
    }).toList();

    if (list.isNotEmpty) {}
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
    final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
    final volume = Provider.of<ValueProvider>(context, listen: false).volume;
    final reversal = Provider.of<CheckedBoxProvider>(context, listen: false).isReversalPlusChecked;
    final signal = Provider.of<CheckedBoxProvider>(context, listen: false).isSignalExitChecked;
    final tc = Provider.of<CheckedBoxProvider>(context, listen: false).isTcChangeChecked;
    final data = OpenRequestModel(
      actionType: actionType,
      symbol: symbol,
      volume: volume,
      takeProfit: takeProfit,
      reversalPlus: reversal,
      signalExit: signal,
      tcChange: tc,
    );
    try {
      final _ = await dio.post(
        'http://13.201.225.85/trade/open',
        data: jsonEncode(data),
        options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      );

      // ✅ Only 2xx responses reach here
      toastification.show(
        backgroundColor: const Color.fromARGB(55, 172, 221, 159),
        title: const Text('Success!'),
        description: const Text('Send successfully'),
        type: ToastificationType.success,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 409) {
        toastification.show(
          backgroundColor: const Color.fromARGB(255, 240, 230, 174),
          title: Text('${e.response?.data}'),
          description: Text(e.response!.data),
          type: ToastificationType.warning,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else if (statusCode == 401) {
        toastification.show(
          backgroundColor: const Color.fromARGB(255, 242, 186, 185),
          title: Text('${e.response?.data}'),
          description: const Text('Token not Valid'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        toastification.show(
          backgroundColor: const Color.fromARGB(255, 242, 186, 185),
          title: const Text('Error!'),
          description: Text('Status code: $statusCode\n${e.message}'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      toastification.show(
        backgroundColor: const Color.fromRGBO(255, 242, 186, 185),
        title: const Text('Unexpected Error!'),
        description: Text(e.toString()),
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
        'http://13.201.225.85/trade/list',
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
          autoCloseDuration: const Duration(seconds: 1),
        );
        return parsedList;
      } else if (response.statusCode == 500) {
        toastification.show(
          backgroundColor: const Color.fromRGBO(199, 226, 201, 1),
          title: const Text('Server Error!'),
          description: Text('Response : ${response.data}'),
          type: ToastificationType.success,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 1),
        );
        return [];
      } else {
        // ignore: use_build_context_synchronously
        Provider.of<MytokenProvider>(context, listen: false).clearToken();
        toastification.show(
          backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
          title: const Text('Error!'),
          description: Text('Status code: ${response.statusCode}'),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 1),
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
        // ignore: use_build_context_synchronously
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
    final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
    String description = "Manual Close";
    final data = CloseRequestModel(actionType: actionType, symbol: symbol, description: description);
    final closeResponse = await dio.post(
      'http://13.201.225.85/trade/close',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      data: jsonEncode(data),
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
      } else if (closeResponse.statusCode == 409) {
        toastification.show(
          backgroundColor: Color.fromRGBO(199, 226, 201, 1),
          title: const Text('INFO!'),
          description: Text(closeResponse.data),
          type: ToastificationType.warning,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else if (closeResponse.statusCode == 400) {
        toastification.show(
          backgroundColor: Color.fromRGBO(199, 226, 201, 1),
          title: const Text('Error!'),
          description: Text(closeResponse.data),
          type: ToastificationType.error,
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else if (closeResponse.statusCode == 401) {
        toastification.show(
          backgroundColor: const Color.fromRGBO(199, 226, 201, 1),
          title: Text('${closeResponse.data}'),
          description: const Text('Token not Valid'),
          type: ToastificationType.error,
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
                      for (var l in symbols)
                        ListTile(
                          title: Text(l.value ?? 'Data Not found'),
                          onTap: () {
                            Provider.of<ValueProvider>(context, listen: false).setSelectedValue(l.value ?? "");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.value} clicked')));
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
                                    width: 150,
                                    child: SearchField<String>(
                                      focusNode: _symbolFocusNode,
                                      suggestions: symbols,
                                      suggestionState: Suggestion.hidden,
                                      selectedValue: drop.selectedItem,
                                      searchInputDecoration: SearchInputDecoration(
                                        hintText: 'Symbols',
                                        border: OutlineInputBorder(),
                                      ),
                                      maxSuggestionsInViewPort: 6,
                                      onSearchTextChanged: (searchText) {
                                        if (searchText.isEmpty) {
                                          return List<SearchFieldListItem<String>>.from(symbols);
                                        }

                                        final query = searchText.toUpperCase();
                                        return symbols.where((s) {
                                          final key = s.searchKey.toUpperCase();
                                          final value = (s.value ?? '').toUpperCase();
                                          return key.contains(query) || value.contains(query);
                                        }).toList();
                                      },
                                      onSuggestionTap: (SearchFieldListItem<String> item) {
                                        _symbolFocusNode.unfocus();

                                        context.read<ValueProvider>().setSelectedItem(item);
                                        context.read<CheckedBoxProvider>().loadForSymbol(item.value!);
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
                                    Provider.of<CheckedBoxProvider>(context, listen: false).clearState();
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
