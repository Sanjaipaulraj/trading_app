import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class HomeScreenState extends State<HomeScreen> {
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = list.first;
  late TextEditingController _volumeController;

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo app')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Symbol'),
                SizedBox(width: 15),
                SizedBox(
                  width: 150,
                  child: DropdownMenu<String>(
                    initialSelection: list.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: menuEntries,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Volume"),
                SizedBox(width: 15),
                SizedBox(
                  width: 150,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    controller: _volumeController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Quantity'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Long')),
                ElevatedButton(onPressed: () {}, child: Text('Short')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
