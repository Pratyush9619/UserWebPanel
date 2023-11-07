import 'package:flutter/material.dart';

class KeyProvider extends ChangeNotifier {
  double totalvalue = 0.0;

  double get getName => totalvalue;

  saveCities(double value) {
    totalvalue = value;
    notifyListeners();
  }
}
