// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auditplus_fx/pages/automation_screen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:toastification/toastification.dart';
import 'package:auditplus_fx/drawer_widget.dart';
import 'package:auditplus_fx/intent.dart';

import '../Providers/providers.dart';
import '../api_methods/api_methods.dart';
import '../sections/sections.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

late List<String> list;

class HomeScreenState extends State<HomeScreen> {
  List<String> list = [];
  List<SearchFieldListItem<String>> symbols = [];
  bool isLoading = true;
  // late Future _initFuture;

  late TextEditingController _tokenController;
  late FocusNode _symbolFocusNode;
  final FocusNode _longButtonFocusNode = FocusNode();
  final FocusNode _shortButtonFocusNode = FocusNode();
  final FocusNode _closeButtonFocusNode = FocusNode();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _symbolFocusNode = FocusNode();
    _tokenController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp(context);
    });
    // _initFuture = _initializeApp(context);
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

    list = await getList(context);

    symbols = list.map((el) {
      return SearchFieldListItem<String>(el, value: el.toString());
    }).toList();

    context.read<CheckedBoxProvider>().loadForM3Values(context);

    if (list.isNotEmpty) {}

    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
        if (!mounted) return;
        liveUpdation(context);
      });
    }
  }

  @override
  void dispose() {
    _symbolFocusNode.dispose();
    _longButtonFocusNode.dispose();
    _shortButtonFocusNode.dispose();
    _closeButtonFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
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
            backgroundColor: Color.fromRGBO(209, 238, 250, 1),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                Center(
                  child: Text("Token getting...", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        //  Case 2: Error (optional)
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Color.fromRGBO(209, 238, 250, 1),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        //Case 3: If the value provider loading - show CircularprogressIndicator
        if (context.watch<ValueProvider>().isLoading) {
          return CircularProgressIndicator();
        }

        //  Case 4: Token missing — show input screen
        final token = myTokenProvider.token;
        if (token == null || token.isEmpty) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(209, 238, 250, 1),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  const Text('Enter the token', style: TextStyle(fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Token'),
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        side: BorderSide(color: Colors.black, width: 1.2),
                      ),
                      backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                    ),
                    onPressed: () {
                      myTokenProvider.setToken(_tokenController.text);
                      setState(() {});
                    },
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        }

        //  Case 5: Everything ready → show your main UI
        return Scaffold(
          backgroundColor: const Color.fromRGBO(209, 238, 250, 1),
          drawer: Drawer(
            backgroundColor: const Color.fromRGBO(209, 238, 250, 1),
            width: MediaQuery.of(context).size.width * 0.6,
            child: DrawerWidget(),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
            actions: <Widget>[
              Consumer<ValueProvider>(
                builder: (context, auto, child) {
                  return TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: auto.isAutomaticEnabled
                          ? Color.fromRGBO(44, 187, 104, 1)
                          : Color.fromRGBO(189, 232, 245, 1),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color.fromRGBO(27, 29, 29, 1), width: 2),
                      ),
                    ),
                    onPressed: () => auto.setAutomaticEnable(),
                    child: Text('AUTO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  );
                },
              ),
              GestureDetector(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Container(
                      color: Color.fromRGBO(189, 232, 245, 1),
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Token',
                            ),
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
            title: Text('Auditplus Fx', style: TextStyle(color: Colors.white)),
          ),
          body: Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.keyL, LogicalKeyboardKey.control): const LongIntent(
                method: 'method1',
                actionType: "ORDER_TYPE_BUY",
              ),
              LogicalKeySet(LogicalKeyboardKey.keyS, LogicalKeyboardKey.control): const ShortIntent(
                method: 'method1',
                actionType: "ORDER_TYPE_SELL",
              ),
              LogicalKeySet(LogicalKeyboardKey.keyC, LogicalKeyboardKey.control): CloseIntent(
                actionType: "POSITION_CLOSE_ID",
              ),
            },
            child: Consumer<ValueProvider>(
              builder: (context, auto, child) {
                return Actions(
                  actions: {
                    LongIntent: CallbackAction<LongIntent>(
                      onInvoke: (intent) {
                        openPosition(intent.method, 'ORDER_TYPE_BUY', null, context);
                        return null;
                      },
                    ),
                    ShortIntent: CallbackAction<ShortIntent>(
                      onInvoke: (intent) {
                        openPosition(intent.method, 'ORDER_TYPE_SELL', null, context);
                        return null;
                      },
                    ),
                    CloseIntent: CallbackAction<CloseIntent>(
                      onInvoke: (intent) {
                        onClosePosition(context, intent.actionType);
                        return null;
                      },
                    ),
                  },
                  child: auto.isAutomaticEnabled
                      ? AutomationScreen(symbols: symbols)
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: double.infinity),
                                decoration: BoxDecoration(color: Color.fromRGBO(84, 119, 146, 1)),
                                padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Consumer<ValueProvider>(
                                      builder: (context, drop, child) {
                                        return SizedBox(
                                          width: 150,
                                          height: 35,
                                          child: SearchField<String>(
                                            focusNode: _symbolFocusNode,
                                            suggestions: symbols,
                                            suggestionState: Suggestion.hidden,
                                            selectedValue: drop.selectedItem,
                                            searchInputDecoration: SearchInputDecoration(
                                              hintText: "Symbols",
                                              filled: true,
                                              fillColor: Colors.white,
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color.fromRGBO(33, 52, 72, 1),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            maxSuggestionsInViewPort: 6,
                                            onSearchTextChanged: (searchText) {
                                              if (searchText.isEmpty) {
                                                return List<SearchFieldListItem<String>>.from(symbols);
                                              }
                                              context.read<ValueProvider>().clearSelectedValue();
                                              context.read<CheckedBoxProvider>().clearState();

                                              final query = searchText.toUpperCase();
                                              return symbols.where((s) {
                                                final key = s.searchKey.toUpperCase();
                                                final value = (s.value ?? '').toUpperCase();
                                                return key.contains(query) || value.contains(query);
                                              }).toList();
                                            },
                                            onSuggestionTap: (SearchFieldListItem<String> item) {
                                              _symbolFocusNode.unfocus();

                                              context.read<ValueProvider>().setSelectedItem(item, context);
                                              context.read<CheckedBoxProvider>().loadForSymbol(item.value!);
                                            },
                                            onSubmit: (item) {
                                              Provider.of<ValueProvider>(
                                                context,
                                                listen: false,
                                              ).setSelectedItem(SearchFieldListItem(item), context);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    Consumer<ValueProvider>(
                                      builder: (context, drop, child) {
                                        return SizedBox(
                                          height: 35,
                                          width: 90,
                                          child: TextFormField(
                                            controller: drop.volumeController,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            onChanged: (newValue) {
                                              final parsedValue = double.tryParse(newValue);
                                              if (parsedValue != null) {
                                                drop.setVolume(parsedValue);
                                              }
                                            },
                                            textAlignVertical: TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 6),

                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(color: Colors.grey),
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color.fromRGBO(33, 52, 72, 1),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),

                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Consumer<MytokenProvider>(
                                      builder: (context, myToken, child) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(100, 22),
                                            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: BorderSide(color: Color.fromRGBO(27, 29, 29, 1), width: 2),
                                            ),
                                            foregroundColor: Colors.white,
                                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            final token = Provider.of<MytokenProvider>(listen: false, context).token;
                                            if (token != null) {
                                              var symbol = context.read<ValueProvider>().selectedValue;
                                              Actions.invoke(context, CloseIntent(actionType: "POSITION_CLOSE_ID"));
                                              if (symbol == null) {
                                                toastification.show(
                                                  backgroundColor: Color.fromRGBO(235, 225, 171, 1),
                                                  context: context,
                                                  title: const Text('Symbol!'),
                                                  description: const Text('Select a symbol'),
                                                  type: ToastificationType.info,
                                                  alignment: Alignment.center,
                                                  autoCloseDuration: const Duration(seconds: 1),
                                                );
                                              }
                                            } else {
                                              toastification.show(
                                                backgroundColor: Color.fromRGBO(242, 186, 185, 1),
                                                context: context,
                                                title: const Text('Error!'),
                                                description: const Text('Your token is empty'),
                                                type: ToastificationType.error,
                                                alignment: Alignment.center,
                                                autoCloseDuration: const Duration(seconds: 1),
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
                              Method1Section(),
                              DottedLine(lineThickness: 1.5, dashColor: Color.fromRGBO(33, 52, 72, 1)),
                              Method2Section(),
                              DottedLine(lineThickness: 1.5, dashColor: Color.fromRGBO(33, 52, 72, 1)),
                            ],
                          ),
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
