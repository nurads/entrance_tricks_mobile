import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';

class VerifyPhoneController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _canResend = false;
  bool get canResend => _canResend;

  int _resendTimer = 60;
  int get resendTimer => _resendTimer;

  Timer? _timer;

  String phoneNumber = '';

  @override
  void onInit() {
    super.onInit();
    phoneNumber = Get.arguments?['phone'] ?? '';
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;
    update();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        update();
      } else {
        _canResend = true;
        timer.cancel();
        update();
      }
    });
  }

  void verifyOTP() async {
    if (formKey.currentState!.validate()) {
      _setLoading(true);

      try {
        // Simulate API call
        await Future.delayed(Duration(seconds: 2));

        // For demo purposes, accept any 6-digit OTP
        if (otpController.text.length == 6) {
          Get.snackbar(
            'Success',
            'Phone verified successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate to home
          Get.offAllNamed(VIEWS.home.path);
        } else {
          Get.snackbar(
            'Error',
            'Invalid OTP. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to verify OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        _setLoading(false);
      }
    }
  }

  void resendOTP() async {
    if (!_canResend) return;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      Get.snackbar(
        'OTP Sent',
        'A new OTP has been sent to $phoneNumber',
        snackPosition: SnackPosition.BOTTOM,
      );

      _startResendTimer();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    update();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
