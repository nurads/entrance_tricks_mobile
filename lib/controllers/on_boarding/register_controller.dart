import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/utils/utils.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  Grade? _selectedGrade;
  Grade? get selectedGrade => _selectedGrade;
  List<String> streams = ['natural', 'social', 'humanities'];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  bool _allowStreamSelection = false;
  bool get allowStreamSelection => _allowStreamSelection;

  // Grade and Stream properties

  String? _selectedStream;
  String? get selectedStream => _selectedStream;

  // Grade options
  List<Grade> gradeOptions = [];

  // Stream options
  List<String> streamOptions = ['natural', 'social'];

  void setSelectedGrade(Grade? grade) {
    _selectedGrade = grade;
    changeAllowStreamSelection();
    update();
  }

  void setSelectedStream(String? stream) {
    _selectedStream = stream;
    update();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }

  void changeAllowStreamSelection() {
    if (_selectedGrade?.name == 'Grade 9' ||
        _selectedGrade?.name == 'Grade 10') {
      _allowStreamSelection = false;
    } else {
      _allowStreamSelection = true;
    }
    update();
  }

  void loadGrades() async {
    gradeOptions = await GradeService().getGrades();
    gradeOptions.sort((a, b) => a.name.compareTo(b.name));
    update();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    update();
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      _setLoading(true);

      try {
        // Simulate API call
        // await Future.delayed(Duration(seconds: 2));
        final response = await UserService().registerUser(
          nameController.text,
          '09${phoneController.text}',
          passwordController.text,
          selectedGrade?.id.toString() ?? '',
          selectedStream,
        );

        logger.i(response);

        Get.snackbar(
          'Success',
          'Registration successful! Please verify your phone number.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to verify phone page
        Get.toNamed(
          VIEWS.verifyPhone.path,
          arguments: {'phone': '09${phoneController.text}'},
        );
      } on DioException catch (e) {
        Get.snackbar(
          'Registration Failed',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } on ApiException catch (e) {
        Get.snackbar(
          'Registration Failed',
          e.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        logger.e(e.toString());
        Get.snackbar(
          'Error',
          'Registration failed. Please try again.',
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
  void onInit() {
    super.onInit();
    loadGrades();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
