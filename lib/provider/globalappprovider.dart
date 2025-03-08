import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String? _selectedValue;

  bool _isFavCardExpanded = true;

  bool get isFavCardExpanded => _isFavCardExpanded;

  String? get selectedValue => _selectedValue;

  void toggleExpended() {
    _isFavCardExpanded = !_isFavCardExpanded;
    print("from app proivider");
    notifyListeners();
  }

  void setSelectedValue(String? newValue) {
    _selectedValue = newValue;
    notifyListeners();
  }
}
