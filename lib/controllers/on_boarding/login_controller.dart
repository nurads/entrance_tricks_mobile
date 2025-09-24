import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/services/api/device.dart';
import 'package:entrance_tricks/utils/utils.dart';

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

        BaseApiClient.setTokens(response.tokens.access, response.tokens.refresh);
        
        final user = await UserService().getUser();

        await authService.saveAuthToken(response.tokens);
        await authService.saveUser(user);

        await DeviceService().registerDevice();

        AppSnackbar.showSuccess('Success', 'Login successful!');
        Get.offAllNamed(VIEWS.home.path);
      } on DioException catch (e) {
        AppSnackbar.showError('Login Failed', e.message ?? 'Failed to login');
      } on ApiException catch (e) {
        AppSnackbar.showError('Login Failed', e.message);
      } catch (e) {
        AppSnackbar.showError('Login Failed', e.toString());
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
