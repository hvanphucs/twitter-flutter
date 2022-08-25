import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool isBusy = true;
  int pageIndex = 0;
  int get getPageIndex {
    return pageIndex;
  }

  set setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }
}
