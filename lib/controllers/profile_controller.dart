import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';

class ProfileController extends GetxController {
  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void loadUserProfile() async {
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      _user = {
        'name': 'John Doe',
        'phone': '+95 9123456789',
        'totalExams': 15,
        'averageScore': 85,
        'videosWatched': 142,
      };
      
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
    }
  }

  void editProfile() {
    Get.snackbar('Info', 'Edit profile feature will be implemented');
  }

  void openSettings() {
    Get.snackbar('Info', 'Settings page will be implemented');
  }

  void openSupport() {
    Get.snackbar('Info', 'Support page will be implemented');
  }

  void openAbout() {
    Get.snackbar('Info', 'About page will be implemented');
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(VIEWS.login.path);
              Get.snackbar(
                'Success',
                'Logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
