import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void login() async {
    if (formKey.currentState!.validate()) {
      _setLoading(true);

      try {
        // Simulate API call
        await Future.delayed(Duration(seconds: 2));

        // Navigate to verify phone page
        Get.toNamed(
          VIEWS.verifyPhone.path,
          arguments: {'phone': '09${phoneController.text}'},
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to send OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        _setLoading(false);
      }
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    update();
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
