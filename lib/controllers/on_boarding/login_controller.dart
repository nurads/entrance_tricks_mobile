import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/services/api/device.dart';

class LoginController extends GetxController {
  final authService = Get.find<AuthService>();
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void login() async {
    if (formKey.currentState!.validate()) {
      _setLoading(true);

      try {
        final phone = '9${phoneController.text}';
        final password = passwordController.text;

        final response = await UserService().loginUser(phone, password);

        authService.saveAuthToken(response.tokens);
        authService.saveUser(response.user);

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await DeviceService().registerDevice();

        Get.offAllNamed(VIEWS.home.path);
      } on DioException catch (e) {
        Get.snackbar(
          'Login Failed',
          e.message ?? 'Failed to login',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } on ApiException catch (e) {
        Get.snackbar(
          'Login Failed',
          e.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Login Failed',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
    passwordController.dispose();
    super.onClose();
  }
}
