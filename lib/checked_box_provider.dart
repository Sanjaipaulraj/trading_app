import 'package:flutter/material.dart';

class CheckedBox extends ChangeNotifier {
  bool isLongTcChecked = false;
  bool isLongTtChecked = false;
  bool isLongNeoChecked = false;
  bool isLongHwoChecked = false;
  bool isShortTcChecked = false;
  bool isShortTtChecked = false;
  bool isShortNeoChecked = false;
  bool isShortHwoChecked = false;

  bool get isLongAllChecked => isLongTcChecked && isLongTtChecked && isLongNeoChecked && isLongHwoChecked;

  bool get isShortAllChecked => isShortTcChecked && isShortTtChecked && isShortNeoChecked && isShortHwoChecked;

  void changeValue(String field) {
    switch (field) {
      case 'LongTcChecked':
        isLongTcChecked = !isLongTcChecked;
        break;
      case 'LongTtChecked':
        isLongTtChecked = !isLongTtChecked;
        break;
      case 'LongNeoChecked':
        isLongNeoChecked = !isLongNeoChecked;
        break;
      case 'LongHwoChecked':
        isLongHwoChecked = !isLongHwoChecked;
        break;
      case 'ShortTcChecked':
        isShortTcChecked = !isShortTcChecked;
        break;
      case 'ShortTtChecked':
        isShortTtChecked = !isShortTtChecked;
        break;
      case 'ShortNeoChecked':
        isShortNeoChecked = !isShortNeoChecked;
        break;
      case 'ShortHwoChecked':
        isShortHwoChecked = !isShortHwoChecked;
        break;
    }
    notifyListeners();
  }
}
