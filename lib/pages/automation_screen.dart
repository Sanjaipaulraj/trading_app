import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../Providers/providers.dart';

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
                              width: 150,
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
                                onSubmit: (item) {
                                  Provider.of<ValueProvider>(
                                    context,
                                    listen: false,
                                  ).setAMSelectedItem(SearchFieldListItem(item), context);
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
                                // controller: drop.am1VolumeController,
                                controller: drop.amVolumeController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (newValue) {
                                  final parsedValue = double.tryParse(newValue);
                                  if (parsedValue != null) {
                                    drop.setAMVolume('AM1', parsedValue);
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
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size(75, 40),
                            backgroundColor: Color.fromRGBO(44, 187, 104, 1),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
                          ),
                          onPressed: () => Provider.of<CheckedBoxProvider>(
                            context,
                            listen: false,
                          ).changeValue('Add', 'AM1', 'AM1Checked', context),
                          child: Text('Add', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        // Consumer<ValueProvider>(
                        //   builder: (context,autoLive,child) {
                        //     return SizedBox(
                        //       height: 500,
                        //       child: ListView.builder(
                        //         itemCount: 1,
                        //         itemBuilder: (context, index) {
                        //           return Column(
                        //             children: [
                        //               Container(
                        //                 padding: const EdgeInsets.all(5),
                        //                 color: Colors.grey,
                        //                 child: Row(
                        //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //                   crossAxisAlignment: CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text('Symbol'),
                        //                     Text('Lot'),
                        //                     TextButton(onPressed: () {}, child: Text('Close')),
                        //                     IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   }
                        // ),
                        // Consumer<CheckedBoxProvider>(
                        //   builder: (context, checkedBox, child) {
                        //     return Checkbox(
                        //       value: checkedBox.isAM1Checked,
                        //       onChanged: (bool? newValue) {
                        //         setState(() {
                        //           checkedBox.changeValue("AM1", 'AM1Checked', context);
                        //         });
                        //       },
                        //       activeColor: Colors.green,
                        //       checkColor: Colors.white,
                        //     );
                        //   },
                        // ),
                      ],
                    ),
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
