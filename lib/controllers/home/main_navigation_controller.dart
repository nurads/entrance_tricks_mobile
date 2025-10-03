import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (index >= 0 && index < 4) { // Only 4 tabs: Home, Exams, News, My Profile
      _currentIndex = index;
      update();
    }
  }
}
