import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../Providers/providers.dart';
import '../api_methods/api_methods.dart';
import '../models/models.dart';

class AutomationScreen extends StatefulWidget {
  final List<SearchFieldListItem<String>> symbols;
  const AutomationScreen({super.key, required this.symbols});

  @override
  State<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends State<AutomationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(209, 238, 250, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Method 1",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<ValueProvider>(
                          builder: (context, drop, child) {
                            return SizedBox(
                              width: 135,
                              height: 35,
                              child: SearchField<String>(
                                suggestions: widget.symbols,
                                suggestionState: Suggestion.hidden,
                                selectedValue: widget.symbols.any((e) => e.searchKey == drop.amSelectedItem?.searchKey)
                                    ? drop.amSelectedItem
                                    : null,
                                searchInputDecoration: SearchInputDecoration(
                                  hintText: "Symbols",
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.black, width: 1),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color.fromRGBO(33, 52, 72, 1), width: 1.5),
                                  ),
                                ),
                                maxSuggestionsInViewPort: 6,
                                onSearchTextChanged: (searchText) {
                                  if (searchText.isEmpty) {
                                    return List<SearchFieldListItem<String>>.from(widget.symbols);
                                  }
                                  context.read<ValueProvider>().amClearSelectedValue();
                                  // context.read<CheckedBoxProvider>().clearState();

                                  final query = searchText.toUpperCase();
                                  return widget.symbols.where((s) {
                                    final key = s.searchKey.toUpperCase();
                                    final value = (s.value ?? '').toUpperCase();
                                    return key.contains(query) || value.contains(query);
                                  }).toList();
                                },
                                onSuggestionTap: (SearchFieldListItem<String> item) {
                                  context.read<ValueProvider>().setAMSelectedItem(item, context);
                                },
                                onSubmit: (item) async {
                                  Provider.of<ValueProvider>(
                                    context,
                                    listen: false,
                                  ).setAMSelectedItem(SearchFieldListItem(item), context);
                                  final data = CurrentAutomationModel(
                                    symbol: drop.amSelectedValue ?? "",
                                    volume: drop.amVolume,
                                    isEnabled: true,
                                    action: ActionType.add,
                                    method: "AM",
                                  );
                                  await automaticTrading(context, data);
                                },
                              ),
                            );
                          },
                        ),
                        Consumer<ValueProvider>(
                          builder: (context, drop, child) {
                            return SizedBox(
                              height: 35,
                              width: 65,
                              child: TextFormField(
                                // controller: drop.am1VolumeController,
                                controller: drop.amVolumeController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (newValue) {
                                  final parsedValue = double.tryParse(newValue);
                                  if (parsedValue != null) {
                                    // drop.setAMVolume('AM1', parsedValue);
                                    drop.setAMVolume('AM', parsedValue);
                                  }
                                },
                                onFieldSubmitted: (value) async {
                                  final data = CurrentAutomationModel(
                                    symbol: drop.amSelectedValue ?? "",
                                    volume: drop.amVolume,
                                    isEnabled: true,
                                    action: ActionType.add,
                                    method: "AM",
                                  );
                                  await automaticTrading(context, data);
                                },
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 6),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.black),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color.fromRGBO(33, 52, 72, 1), width: 1.5),
                                  ),
                                ),

                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 70),
                        Consumer<ValueProvider>(
                          builder: (context, autoLive, child) {
                            return TextButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size(75, 40),
                                backgroundColor: Color.fromRGBO(44, 187, 104, 1),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
                              ),
                              // onPressed: () => Provider.of<CheckedBoxProvider>(
                              //   context,
                              //   listen: false,
                              // ).changeValue('Add', 'AM1', 'AM1Checked', context),
                              onPressed: () async {
                                final data = CurrentAutomationModel(
                                  symbol: autoLive.amSelectedValue ?? "",
                                  volume: autoLive.amVolume,
                                  isEnabled: true,
                                  action: ActionType.add,
                                  method: "AM",
                                );
                                await automaticTrading(context, data);
                                autoLive.addLiveTrade(data);
                              },
                              child: Text('Add', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<ValueProvider>(
                    builder: (context, autoLive, child) {
                      if (autoLive.liveAutomaticTrade.isEmpty) {
                        return Text("No items found");
                      } else {
                        return SingleChildScrollView(
                          child: SizedBox(
                            height: 450,
                            child: Consumer<ValueProvider>(
                              builder: (context, autoLive, child) {
                                return ListView.builder(
                                  itemCount: autoLive.liveAutomaticTrade.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          color: Colors.grey,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Text('Symbol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                              SizedBox(
                                                width: 135,
                                                height: 35,
                                                child: Text(
                                                  autoLive.liveAutomaticTrade[index].symbol,
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              // Text('Lot'),
                                              SizedBox(
                                                width: 65,
                                                height: 35,
                                                child: Text(
                                                  autoLive.liveAutomaticTrade[index].volume.toString(),
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                  maximumSize: Size(70, 40),
                                                  backgroundColor: Color.fromRGBO(96, 70, 238, 1),
                                                  foregroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadiusGeometry.circular(5),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final data = CurrentAutomationModel(
                                                    symbol: autoLive.amSelectedValue ?? "",
                                                    volume: autoLive.amVolume,
                                                    isEnabled: true,
                                                    action: ActionType.close,
                                                    method: "AM",
                                                  );
                                                  await automaticTrading(context, data);
                                                },
                                                child: Text(
                                                  'Close',
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              IconButton(
                                                style: ElevatedButton.styleFrom(
                                                  maximumSize: Size(75, 40),
                                                  backgroundColor: Color.fromRGBO(240, 29, 29, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadiusGeometry.circular(5),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final data = CurrentAutomationModel(
                                                    symbol: autoLive.amSelectedValue ?? "",
                                                    volume: autoLive.amVolume,
                                                    isEnabled: false,
                                                    action: ActionType.disable,
                                                    method: "AM",
                                                  );
                                                  await automaticTrading(context, data);
                                                  autoLive.removeLiveTrade(data.symbol);
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
