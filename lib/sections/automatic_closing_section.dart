import 'package:flutter/material.dart';

class AutomaticClosingSection extends StatefulWidget {
  const AutomaticClosingSection({super.key});

  @override
  State<AutomaticClosingSection> createState() => _AutomaticClosingSectionState();
}

class _AutomaticClosingSectionState extends State<AutomaticClosingSection> {
  bool _isRevChecked = false;
  bool _isSignalChecked = false;
  bool _isTcChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.start,
            'Automatic Closing',
            style: TextStyle(color: Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              SizedBox(
                width: 100,
                child: Text('Reversal plus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: Checkbox(
                  value: _isRevChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isRevChecked = newValue!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              SizedBox(
                width: 100,
                child: Text('Signal East', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: Checkbox(
                  value: _isSignalChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isSignalChecked = newValue!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              SizedBox(
                width: 100,
                child: Text('Tc change', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: Checkbox(
                  value: _isTcChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isTcChecked = newValue!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
