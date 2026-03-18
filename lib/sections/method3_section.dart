import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auditplus_fx/Providers/providers.dart';
import 'package:searchfield/searchfield.dart';

// import '../api_methods/api_methods.dart';

class Method3Section extends StatefulWidget {
  final List<SearchFieldListItem<String>> symbols;
  const Method3Section({super.key, required this.symbols});

  @override
  State<Method3Section> createState() => _Method3SectionState();
}

class _Method3SectionState extends State<Method3Section> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Method 3",
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            constraints: BoxConstraints(maxWidth: double.infinity),
            decoration: BoxDecoration(border: BoxBorder.all()),
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<ValueProvider>(
                  builder: (context, drop, child) {
                    return SizedBox(
                      width: 150,
                      height: 35,
                      child: SearchField<String>(
                        suggestions: widget.symbols,
                        suggestionState: Suggestion.hidden,
                        selectedValue: widget.symbols.any((e) => e.searchKey == drop.m3SelectedItem?.searchKey)
                            ? drop.m3SelectedItem
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
                          context.read<ValueProvider>().m3ClearSelectedValue();
                          // context.read<CheckedBoxProvider>().clearState();

                          final query = searchText.toUpperCase();
                          return widget.symbols.where((s) {
                            final key = s.searchKey.toUpperCase();
                            final value = (s.value ?? '').toUpperCase();
                            return key.contains(query) || value.contains(query);
                          }).toList();
                        },
                        onSuggestionTap: (SearchFieldListItem<String> item) {
                          context.read<ValueProvider>().setM3SelectedItem(item, context);
                        },
                        onSubmit: (item) {
                          Provider.of<ValueProvider>(
                            context,
                            listen: false,
                          ).setM3SelectedItem(SearchFieldListItem(item), context);
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
                        controller: drop.m3VolumeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (newValue) {
                          final parsedValue = double.tryParse(newValue);
                          if (parsedValue != null) {
                            drop.setM3Volume(parsedValue);
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
                      value: checkedBox.isM3Checked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          checkedBox.changeValue('method3', 'M3Checked', context);
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
    );
  }

  // Widget _buildCheckboxRow(String method, String checkboxField, CheckedBoxProvider checkedBox) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       if (method == 'long')
  //         Icon(Icons.arrow_upward_rounded, color: Colors.green, size: 18)
  //       else
  //         Icon(Icons.arrow_downward_rounded, color: Colors.red, size: 18),
  //       Checkbox(
  //         value: _getCheckboxValue(checkboxField, checkedBox),
  //         onChanged: (bool? newValue) {
  //           setState(() {
  //             checkedBox.changeValue('method3', checkboxField, context);
  //           });
  //         },
  //         activeColor: method == 'long' ? Colors.green : Colors.red,
  //         checkColor: Colors.white,
  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //         visualDensity: VisualDensity.comfortable,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildCheckboxColumn(String method, String checkboxField, CheckedBoxProvider checkedBox) {
  //   return Column(
  //     children: [
  //       Checkbox(
  //         value: _getCheckboxValue(checkboxField, checkedBox),
  //         onChanged: (bool? newValue) {
  //           setState(() {
  //             checkedBox.changeValue('method3', checkboxField, context);
  //           });
  //         },
  //         activeColor: Colors.green,
  //         checkColor: Colors.white,
  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //         visualDensity: VisualDensity.compact,
  //       ),
  //       if (method == 'long')
  //         Text("> TT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
  //       else
  //         Text("< TT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
  //     ],
  //   );
  // }

  // bool _getCheckboxValue(String checkboxField, CheckedBoxProvider checkedBox) {
  //   switch (checkboxField) {
  //     case 'LongGretTcChecked':
  //       return checkedBox.isLongGretTcChecked;
  //     case 'LongSigCrTtChecked':
  //       return checkedBox.isLongSigCrTtChecked;
  //     case 'ShortGretTcChecked':
  //       return checkedBox.isShortGretTcChecked;
  //     case 'ShortSigCrTtChecked':
  //       return checkedBox.isShortSigCrTtChecked;
  //     default:
  //       return false;
  //   }
  // }
}
