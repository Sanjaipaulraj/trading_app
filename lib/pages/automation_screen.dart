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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: 15),
                  Container(
                    constraints: BoxConstraints(maxWidth: double.infinity),
                    decoration: BoxDecoration(border: BoxBorder.all()),
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Method 1",
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Consumer<ValueProvider>(
                          builder: (context, drop, child) {
                            return SizedBox(
                              height: 35,
                              width: 90,
                              child: TextFormField(
                                controller: drop.am1VolumeController,
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
                        Consumer<CheckedBoxProvider>(
                          builder: (context, checkedBox, child) {
                            return Checkbox(
                              value: checkedBox.isAM1Checked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  checkedBox.changeValue("AM1", 'AM1Checked', context);
                                });
                              },
                              activeColor: Colors.green,
                              checkColor: Colors.white,
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
                  SizedBox(height: 15),
                  Container(
                    constraints: BoxConstraints(maxWidth: double.infinity),
                    decoration: BoxDecoration(border: BoxBorder.all()),
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Method 2",
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Consumer<ValueProvider>(
                          builder: (context, drop, child) {
                            return SizedBox(
                              height: 35,
                              width: 90,
                              child: TextFormField(
                                controller: drop.am2VolumeController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (newValue) {
                                  final parsedValue = double.tryParse(newValue);
                                  if (parsedValue != null) {
                                    drop.setAMVolume('AM2', parsedValue);
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
                        Consumer<CheckedBoxProvider>(
                          builder: (context, checkedBox, child) {
                            return Checkbox(
                              value: checkedBox.isAM2Checked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  checkedBox.changeValue("AM2", 'AM2Checked', context);
                                });
                              },
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       mainAxisSize: MainAxisSize.min,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  //           child: Text(
                  //             'TC',
                  //             textAlign: TextAlign.end,
                  //             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  //           child: Text(
                  //             'Sig.Cr.TT',
                  //             textAlign: TextAlign.end,
                  //             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     Consumer2<MytokenProvider, CheckedBoxProvider>(
                  //       builder: (context, myToken, checkedBox, child) {
                  //         return Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             _buildCheckboxColumn('long', 'LongGretTcChecked', checkedBox),
                  //             _buildCheckboxRow('long', 'LongSigCrTtChecked', checkedBox),
                  //           ],
                  //         );
                  //       },
                  //     ),
                  //     Consumer2<MytokenProvider, CheckedBoxProvider>(
                  //       builder: (context, myToken, checkedBox, child) {
                  //         return Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             _buildCheckboxColumn('short', 'ShortGretTcChecked', checkedBox),
                  //             _buildCheckboxRow('short', 'ShortSigCrTtChecked', checkedBox),
                  //           ],
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // AutomaticClosingSection(method: 'method3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
