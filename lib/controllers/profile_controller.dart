import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';

class ProfileController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;

  String _userName = 'Eden Eden';
  String get userName => _userName;

  String _userClass = 'Grade 12';
  String get userClass => _userClass;

  String _userPhone = '0901010101';
  String get userPhone => _userPhone;

  String _profileImageUrl = 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face';
  String get profileImageUrl => _profileImageUrl;

  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      _user = {
        'name': _userName,
        'class': _userClass,
        'phone': _userPhone,
        'totalExams': 15,
        'averageScore': 78,
        'videosWatched': 45,
      };
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    update();
  }

  void updateUserName(String name) {
    _userName = name;
    _user['name'] = name;
    update();
  }

  void updateUserClass(String userClass) {
    _userClass = userClass;
    _user['class'] = userClass;
    update();
  }

  void updateUserPhone(String phone) {
    _userPhone = phone;
    _user['phone'] = phone;
    update();
  }

  void editProfile() {
    toggleEditMode();
  }

  void openSettings() {
    // TODO: Navigate to settings page
    Get.snackbar('Info', 'Settings page will be implemented');
  }

  void openSupport() {
    // TODO: Navigate to support page
    Get.snackbar('Info', 'Support page will be implemented');
  }

  void openAbout() {
    // TODO: Navigate to about page
    Get.snackbar('Info', 'About page will be implemented');
  }

  void logout() {
    // Navigate to login and clear navigation stack
    Get.offAllNamed(VIEWS.login.path);
  }
}
