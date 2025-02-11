import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isFavCardExpanded = true;

  bool get isFavCardExpanded => _isFavCardExpanded;

  void toggleExpended() {
    _isFavCardExpanded = !_isFavCardExpanded;
    print("from app proivider");
    notifyListeners();
  }
}
