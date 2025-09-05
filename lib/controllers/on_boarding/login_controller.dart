import 'package:entrance_tricks/utils/storages/base.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/models/session.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void login() async {
    if (formKey.currentState!.validate()) {
      _setLoading(true);

      try {
        final phone = '09${phoneController.text}';
        final password = passwordController.text;

        final response = await UserService().loginUser(phone, password);

        BaseSessionController().login(
          Session(jwt: response.jwt, user: response.user),
        );
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

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
