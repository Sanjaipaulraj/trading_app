// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/sections/automatic_closing_section.dart';
import 'package:trading_app/sections/conditon_title_section.dart';
import 'package:trading_app/sections/long_button_section.dart';
import 'package:trading_app/sections/short_button_section.dart';
import 'package:trading_app/sections/status_section.dart';
import 'package:trading_app/Providers/token_provider.dart';

import '../api_methods/api_methods.dart';

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

    list = await getList(context);

    symbols = list.map((el) {
      return SearchFieldListItem<String>(
        //  search will be performed on this value
        el,
        // value to set in input on click, defaults to searchKey (optional)
        value: el.toString(),
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

        //Case 3: If the value provider loading - show CircularprogressIndicator
        if (context.watch<ValueProvider>().isLoading) {
          return CircularProgressIndicator();
        }

        //  Case 4: Token missing — show input screen
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
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color.fromRGBO(101, 101, 255, 1)),
                  child: Text('Symbol Settings', style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                Consumer<ValueProvider>(
                  builder: (context, symbList, child) {
                    final lis = symbList.tradeHistory;
                    return ExpansionTile(
                      onExpansionChanged: (value) async {
                        final symbolList = await fetchTradeHistory();
                        // print(symbolList);
                        Provider.of<ValueProvider>(context, listen: false).updateFetchHistory(symbolList);
                      },
                      leading: const Icon(Icons.history),
                      title: const Text('Today History'),
                      children: [
                        for (var l in lis)
                          ListTile(
                            title: Text(l.symbol),
                            trailing: Text(
                              l.profit.toString(),
                              style: TextStyle(
                                color: (l.profit > 0) ? Colors.green : Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              // SearchFieldListItem<String> val = SearchFieldListItem<String>(l.symbol, value: l.symbol);
                              // Provider.of<ValueProvider>(context, listen: false).setSelectedItem(val, context);
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('${l.symbol} clicked')));
                              // Navigator.pop(context);
                            },
                          ),
                      ],
                    );
                  },
                ),
                Consumer<ValueProvider>(
                  builder: (context, symbList, child) {
                    final lis = symbList.liveSymbols;
                    return ExpansionTile(
                      onExpansionChanged: (value) async {
                        final symbolList = await fetchLiveSymbols();
                        // print(symbolList);
                        Provider.of<ValueProvider>(context, listen: false).updateFetchSymbols(symbolList);
                      },
                      leading: const Icon(Icons.check_circle),
                      title: const Text('Live Symbol'),
                      children: [
                        for (var l in lis)
                          ListTile(
                            title: Text(l.symbol),
                            trailing: Text(
                              l.profit.toString(),
                              style: TextStyle(
                                color: (l.profit > 0) ? Colors.green : Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              SearchFieldListItem<String> val = SearchFieldListItem<String>(l.symbol, value: l.symbol);
                              Provider.of<ValueProvider>(context, listen: false).setSelectedItem(val, context);
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('${l.symbol} clicked')));
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    );
                  },
                ),
                ExpansionTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Report'),
                  children: [
                    ListTile(
                      title: const Text('Report Option 1'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Report Option 2'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
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
                    // _openPosition('ORDER_TYPE_BUY', null);
                    openPosition('ORDER_TYPE_BUY', null, context);
                    return null;
                  },
                ),
                ShortIntent: CallbackAction<ShortIntent>(
                  onInvoke: (intent) {
                    // _openPosition('ORDER_TYPE_SELL', null);
                    openPosition('ORDER_TYPE_SELL', null, context);
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
                            ],
                          ),
                          Consumer<ValueProvider>(
                            builder: (context, drop, child) {
                              return Container(
                                height: 55,
                                width: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: const Color.fromRGBO(128, 128, 128, 1), width: 2.0),
                                ),
                                child: TextFormField(
                                  controller: drop.volumeController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (newValue) {
                                    final parsedValue = double.tryParse(newValue);
                                    if (parsedValue != null) {
                                      drop.setVolume(parsedValue);
                                    }
                                  },
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
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
                                    var symbol = context.read<ValueProvider>().selectedValue;
                                    Actions.invoke(context, CloseIntent(actionType: "POSITIONS_CLOSE_SYMBOL"));
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
