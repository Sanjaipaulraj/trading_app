import 'package:flutter/material.dart';

class ConditonTitleSection extends StatelessWidget {
  const ConditonTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 60, width: 100),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'TC UP',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'TT UP',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'NEO UP',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'HWO UP',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
