import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';

class NavigationDrawerController extends GetxController {
  bool _isDrawerOpen = false;
  bool get isDrawerOpen => _isDrawerOpen;

  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    update();
  }

  void closeDrawer() {
    _isDrawerOpen = false;
    update();
  }

  void openDrawer() {
    _isDrawerOpen = true;
    update();
  }

  // Navigation methods for drawer items
  void navigateToFAQ() {
    Get.snackbar('Info', 'FAQ page will be implemented');
    closeDrawer();
  }

  void navigateToSupport() {
    Get.snackbar('Info', 'Support page will be implemented');
    closeDrawer();
  }

  void navigateToAbout() {
    Get.snackbar('Info', 'About page will be implemented');
    closeDrawer();
  }

  void navigateToContactUs() {
    Get.snackbar('Info', 'Contact Us page will be implemented');
    closeDrawer();
  }

  void logout() {
    // Navigate to login and clear navigation stack
    Get.offAllNamed(VIEWS.login.path);
  }
}
