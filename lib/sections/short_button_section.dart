import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/token_provider.dart';

class ShortButtonSection extends StatefulWidget {
  const ShortButtonSection({super.key});

  @override
  State<ShortButtonSection> createState() => _ShortButtonSectionState();
}

class _ShortButtonSectionState extends State<ShortButtonSection> {
  bool _isTcChecked = false;
  bool _isTtChecked = false;
  bool _isNeoChecked = false;
  bool _isHwoChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Mytoken>(
      builder: (context, myToken, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 55),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black, width: 2),
                ),
                elevation: 8.0,
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () {
                final token = Provider.of<Mytoken>(context, listen: false).token;
                if (token != null) {
                  Actions.invoke(context, const ShortIntent());
                  toastification.show(
                    backgroundColor: Color.fromRGBO(199, 226, 201, 1),
                    context: context,
                    title: const Text('Success!'),
                    description: const Text('Your value submited successfully'),
                    type: ToastificationType.success,
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
              child: Text('Short'),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: _isTcChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isTcChecked = newValue!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: _isTtChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isTtChecked = newValue!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: _isNeoChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isNeoChecked = newValue!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: _isHwoChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isHwoChecked = newValue!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
