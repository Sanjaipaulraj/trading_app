import 'package:flutter/material.dart';

class CheckedBox extends ChangeNotifier {
  bool isLongTcChecked = false;
  bool isLongTtChecked = false;
  bool isLongNeoChecked = false;
  bool isLongHwoChecked = false;
  bool isLongConfChecked = false;
  bool isShortTcChecked = false;
  bool isShortTtChecked = false;
  bool isShortNeoChecked = false;
  bool isShortHwoChecked = false;
  bool isShortConfChecked = false;

  bool get isLongAllChecked =>
      isLongTcChecked && isLongTtChecked && isLongNeoChecked && isLongHwoChecked && isLongConfChecked;

  bool get isShortAllChecked =>
      isShortTcChecked && isShortTtChecked && isShortNeoChecked && isShortHwoChecked && isShortConfChecked;

  void changeValue(String field) {
    switch (field) {
      case 'LongTcChecked':
        isLongTcChecked = !isLongTcChecked;
        isShortTcChecked = false;
        break;
      case 'LongTtChecked':
        isLongTtChecked = !isLongTtChecked;
        isShortTtChecked = false;
        break;
      case 'LongNeoChecked':
        isLongNeoChecked = !isLongNeoChecked;
        isShortNeoChecked = false;
        break;
      case 'LongHwoChecked':
        isLongHwoChecked = !isLongHwoChecked;
        isShortHwoChecked = false;
        break;
      case 'LongConfChecked':
        isLongConfChecked = !isLongConfChecked;
        isShortConfChecked = false;
        break;
      case 'ShortTcChecked':
        isShortTcChecked = !isShortTcChecked;
        isLongTcChecked = false;
        break;
      case 'ShortTtChecked':
        isShortTtChecked = !isShortTtChecked;
        isLongTtChecked = false;
        break;
      case 'ShortNeoChecked':
        isShortNeoChecked = !isShortNeoChecked;
        isLongNeoChecked = false;
        break;
      case 'ShortHwoChecked':
        isShortHwoChecked = !isShortHwoChecked;
        isLongHwoChecked = false;
        break;
      case 'ShortConfChecked':
        isShortConfChecked = !isShortConfChecked;
        isLongConfChecked = false;
        break;
    }
    notifyListeners();
  }
}
