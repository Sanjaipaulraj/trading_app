import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'api_methods/api_methods.dart';
import 'models/models.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late List<String> list;
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  late FocusNode _menuSymbolFocusNode;
  String menuSelectedValue = "ALL";
  SearchFieldListItem<String>? menuSelectedItem;
  List<SearchFieldListItem<String>> symbols = [];
  List<ActiveSymbolModel> liveSymbols = [];
  List<TradeHistoryModel> tradeHistory = [];
  String? startDate;
  String? endDate;
  SearchFieldListItem<String> get allItem => symbols.first;
  @override
  void initState() {
    super.initState();

    _menuSymbolFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp(context);
    });
  }

  Future<void> _initializeApp(BuildContext context) async {
    list = await getList(context);

    symbols = [
      SearchFieldListItem<String>("ALL", value: "ALL"),
      ...list.map((el) => SearchFieldListItem<String>(el, value: el)),
    ];

    final now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // print(formattedDate);

    setState(() {
      menuSelectedItem = symbols.first; // "ALL"
      menuSelectedValue = "ALL";
      fromDateController.text = formattedDate;
      toDateController.text = formattedDate;
    });
  }

  Future<void> pickDate({required bool isFromDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      // initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      // lastDate: DateTime(2035),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formatted =
          '${pickedDate.day.toString().padLeft(2, '0')}-'
          '${pickedDate.month.toString().padLeft(2, '0')}-'
          '${pickedDate.year}';

      final apiFormat = DateFormat('yyyy-MM-dd').format(pickedDate);

      if (isFromDate) {
        startDate = apiFormat;
        setState(() {
          fromDateController.text = formatted;
        });
      } else {
        endDate = apiFormat;
        setState(() {
          toDateController.text = formatted;
        });
      }

      // notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 1.5)),
          ),
          child: Text(
            'Symbol Settings',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromRGBO(24, 55, 69, 1), fontSize: 24),
          ),
        ),
        ExpansionTile(
          onExpansionChanged: (value) async {
            if (!value) return;

            final data = await fetchTradeHistory();

            if (!mounted) return;

            setState(() {
              tradeHistory = data;
            });
          },

          leading: const Icon(Icons.history),
          title: const Text('Today History'),
          children: [
            for (var l in tradeHistory)
              ListTile(
                title: Text(l.symbol),
                trailing: Text(
                  l.profit.toStringAsFixed(2),
                  style: TextStyle(
                    color: (l.profit > 0) ? Colors.green : Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.symbol} clicked')));
                },
              ),
          ],
        ),
        ExpansionTile(
          onExpansionChanged: (value) async {
            if (!value) return; // only load when expanded

            final data = await fetchLiveSymbols();

            if (!mounted) return;

            setState(() {
              liveSymbols = data;
            });
          },
          leading: const Icon(Icons.check_circle, color: Colors.green),
          title: const Text('Live Symbol'),
          children: [
            for (var l in liveSymbols)
              ListTile(
                title: Text(l.symbol),
                trailing: Text(
                  l.profit.toStringAsFixed(2),
                  style: TextStyle(
                    color: (l.profit > 0) ? Colors.green : Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  SearchFieldListItem<String> val = SearchFieldListItem<String>(l.symbol, value: l.symbol);
                  Provider.of<ValueProvider>(context, listen: false).setSelectedItem(val, context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.symbol} clicked')));
                  Navigator.pop(context);
                },
              ),
          ],
        ),
        ExpansionTile(
          maintainState: true,
          leading: const Icon(Icons.article),
          title: const Text('Report'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: SearchField<String>(
                      focusNode: _menuSymbolFocusNode,
                      suggestions: symbols,
                      suggestionState: Suggestion.hidden,
                      selectedValue: menuSelectedItem,
                      searchInputDecoration: SearchInputDecoration(hintText: 'Symbols', border: OutlineInputBorder()),
                      maxSuggestionsInViewPort: 4,
                      onSearchTextChanged: (searchText) {
                        if (searchText.isEmpty) {
                          return List<SearchFieldListItem<String>>.from(symbols);
                        }

                        setState(() {
                          menuSelectedItem = allItem; // ✅ SAME INSTANCE
                          menuSelectedValue = "ALL";
                        });

                        final query = searchText.toUpperCase();
                        return symbols.where((s) {
                          final key = s.searchKey.toUpperCase();
                          final value = (s.value ?? '').toUpperCase();
                          return key.contains(query) || value.contains(query);
                        }).toList();
                      },
                      onSuggestionTap: (SearchFieldListItem<String> item) {
                        _menuSymbolFocusNode.unfocus();

                        setState(() {
                          menuSelectedItem = item; // ✅ already in symbols
                          menuSelectedValue = item.searchKey;
                        });
                      },
                      onSubmit: (item) {
                        final found = symbols.firstWhere((s) => s.searchKey == item, orElse: () => allItem);

                        setState(() {
                          menuSelectedItem = found;
                          menuSelectedValue = found.searchKey;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  dateField(
                    label: 'From Date *',
                    controller: fromDateController,
                    onTap: () {
                      pickDate(isFromDate: true);
                    },
                  ),
                  const SizedBox(height: 10),
                  dateField(
                    label: 'To Date *',
                    controller: toDateController,
                    onTap: () {
                      pickDate(isFromDate: false);
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[700], foregroundColor: Colors.white),
                    onPressed: () => getReport(context, menuSelectedValue, startDate!, endDate!),
                    child: Text('Get Report', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget dateField({required String label, required TextEditingController controller, required VoidCallback onTap}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      InkWell(
        onTap: onTap,
        child: TextFormField(
          controller: controller,
          enabled: false,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today, size: 18),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ),
    ],
  );
}
