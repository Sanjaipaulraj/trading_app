import 'package:flutter/material.dart';

class ConditonTitleSection extends StatelessWidget {
  const ConditonTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 60, width: 100),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Catcher',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Tracer',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'NEO Cloud',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Confirmation',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'HyperWave',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
