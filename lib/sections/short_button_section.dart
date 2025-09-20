import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/token_provider.dart';

class ShortButtonSection extends StatefulWidget {
  final String token;
  const ShortButtonSection({super.key, required this.token});

  @override
  State<ShortButtonSection> createState() => _ShortButtonSectionState();
}

class _ShortButtonSectionState extends State<ShortButtonSection> {
  late String tok;

  @override
  void initState() {
    tok = widget.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Mytoken>(
      builder: (context, myToken, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
          ],
        );
      },
    );
  }
}
