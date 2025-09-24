import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text('Catcher', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.lightGreen),
                  height: 40,
                  width: 40,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text('HWO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8.0)),
                  height: 40,
                  width: 40,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text('Divergence', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(8.0)),
                  height: 40,
                  width: 40,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text('Reversal plus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8.0)),
                  height: 40,
                  width: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
