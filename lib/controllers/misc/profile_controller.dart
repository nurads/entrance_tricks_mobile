import 'package:get/get.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool isUpdating = false;
  bool hasChangeOnEditProfile = false;

  final AuthService _authService = Get.find<AuthService>();

  final phoneEditController = TextEditingController();
  final nameEditController = TextEditingController();

  final CoreService _coreService = Get.find<CoreService>();

  late StreamSubscription<InternetStatus> _internetStatusSubscription;

  String get userName => _userName;

  String get userClass => _userClass;

  String _userName = '';
  String _userPhone = '';
  String _userClass = '';
  String get userPhone => _userPhone;

  String _profileImageUrl =
      'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face';
  String get profileImageUrl => _profileImageUrl;

  List<Grade> _availableGrades = [];
  List<Grade> get availableGrades => _availableGrades;

  Grade? _selectedGrade;
  Grade? get selectedGrade => _selectedGrade;

  Grade? _currentGrade;
  Grade? get currentGrade => _currentGrade;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadGrades();
    _internetStatusSubscription = InternetConnection().onStatusChange.listen((
      event,
    ) {
      if (event == InternetStatus.connected) {
        loadUserData();
      }
    });
  }

  @override
  void onClose() {
    _internetStatusSubscription.cancel();
    phoneEditController.dispose();
    nameEditController.dispose();
    super.onClose();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    update();

    if (_coreService.hasInternet) {
      try {
        final user = await UserService().getUser();

        await AuthService().saveUser(user);
        _userName = "${user.firstName} ${user.lastName ?? ''}".trim();
        _userClass = user.grade.name;
        _userPhone = user.phoneNumber;
        _selectedGrade = user.grade;
      } catch (e) {
        logger.e(e);
        Get.snackbar('Error', 'Failed to load user data');
      } finally {
        _isLoading = false;
        update();
      }
    } else {
      _userName =
          "${_authService.user.value?.firstName ?? ''} ${_authService.user.value?.lastName ?? ''}"
              .trim();

      _userClass = _authService.user.value?.grade.name ?? '';
      _userPhone = _authService.user.value?.phoneNumber ?? '';
      _selectedGrade = _authService.user.value?.grade;
      update();
    }

    phoneEditController.text = _userPhone;
    nameEditController.text = _userName;
    _currentGrade = _authService.user.value?.grade;

    _isLoading = false;
    update();
  }

  Future<void> loadGrades() async {
    try {
      final gradeService = Get.find<GradeService>();
      _availableGrades = await gradeService.getGrades();
      _selectedGrade = _authService.user.value?.grade;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load grades');
    }
  }

  void updateUserName(String name) {
    if (name.trim() != _userName) {
      hasChangeOnEditProfile = true;
    }
    update();
  }

  void updateUserPhone(String phone) {
    if (phone.trim() != _userPhone) {
      hasChangeOnEditProfile = true;
    }
    update();
  }

  void updateSelectedGrade(int? grade) {
    _selectedGrade = _availableGrades.firstWhere(
      (element) => element.id == grade,
    );
    logger.i('Changed grade to ${_selectedGrade?.name}');
    if (_selectedGrade != _authService.user.value?.grade) {
      hasChangeOnEditProfile = true;
    }

    update();
  }

  void updateUserOnSave() async {
    if (isUpdating) return;
    isUpdating = true;
    update();
    if (_coreService.hasInternet) {
      try {
        final user = await UserService().updateUser(
          phoneNumber: phoneEditController.text.trim(),
          name: nameEditController.text.trim(),
          grade: _selectedGrade?.id ?? 0,
        );
        await AuthService().saveUser(user);
        _userName = "${user.firstName} ${user.lastName ?? ''}".trim();
        _userClass = user.grade.name;
        _userPhone = user.phoneNumber;
        _selectedGrade = user.grade;
      } catch (e) {
        logger.e(e);
        Get.snackbar('Error', 'Failed to update user');
      }
    } else {
      Get.snackbar('Error', 'No internet connection');
    }
    nameEditController.text = _userName;
    phoneEditController.text = _userPhone;

    _selectedGrade = _authService.user.value?.grade;

    logger.i('Updated user to ${_authService.user.value?.grade.name}');
    isUpdating = false;
    update();
  }

  void navigateToEditProfile() {
    Get.toNamed('/edit-profile');
  }

  void openSupport() {
    // TODO: Navigate to support page
    Get.snackbar('Info', 'Support page will be implemented');
  }

  void openAppInfo() {
    // TODO: Navigate to app info page
    Get.snackbar('Info', 'App information page will be implemented');
  }

  void logout() {
    // Navigate to login and clear navigation stack
    Get.offAllNamed(VIEWS.login.path);
    // Logout from the auth service
    AuthService().logout();
  }
}
