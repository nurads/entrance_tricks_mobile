import 'package:entrance_tricks/utils/storages/storages.dart';
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
  User? _user;
  User? get user => _user;
  String get fullName => "${_user?.firstName} ${_user?.lastName ?? ''}";

  late StreamSubscription<InternetStatus> _internetStatusSubscription;

  List<Grade> _availableGrades = [];
  List<Grade> get availableGrades => _availableGrades;

  Grade? _selectedGrade;
  Grade? get selectedGrade => _selectedGrade;

  Grade? _currentGrade;
  Grade? get currentGrade => _currentGrade;

  bool _isDeletingAccount = false;
  bool get isDeletingAccount => _isDeletingAccount;

  final TextEditingController _deleteConfirmationController =
      TextEditingController();

  @override
  void onInit() async {
    super.onInit();

    loadUserData();

    loadGrades();

    _user = await HiveUserStorage().getUser();

    _authService.listenUser((event) {
      _user = event;
      update();
    });

    _internetStatusSubscription = InternetConnection().onStatusChange.listen((
      event,
    ) {
      if (event == InternetStatus.connected) {
        loadUserData();
        loadGrades();
      }
    });
  }

  @override
  void onClose() {
    _internetStatusSubscription.cancel();
    phoneEditController.dispose();
    nameEditController.dispose();
    _deleteConfirmationController.dispose();
    super.onClose();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    update();

    try {
      final user_ = await UserService().getUser();

      await AuthService().saveUser(user_);
    } catch (e) {
      logger.e(e);
    } finally {
      _isLoading = false;
      update();
    }
    phoneEditController.text = user?.phoneNumber ?? '';
    nameEditController.text = fullName;

    _currentGrade = user?.grade;

    _isLoading = false;
    update();
  }

  Future<void> loadGrades() async {
    try {
      final gradeService = Get.find<GradeService>();
      _availableGrades = await gradeService.getGrades();
      _selectedGrade = user?.grade;
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  void updateUserName(String name) {
    if (name.trim() != fullName) {
      hasChangeOnEditProfile = true;
    }
    update();
  }

  void updateUserPhone(String phone) {
    if (phone.trim() != user?.phoneNumber) {
      hasChangeOnEditProfile = true;
    }
    update();
  }

  void updateSelectedGrade(int? grade) {
    _selectedGrade = _availableGrades.firstWhere(
      (element) => element.id == grade,
    );
    logger.i('Changed grade to ${_selectedGrade?.name}');
    if (_selectedGrade != user?.grade) {
      hasChangeOnEditProfile = true;
    }

    update();
  }

  void updateUserOnSave() async {
    if (isUpdating) return;
    isUpdating = true;
    update();
    try {
      final user_ = await UserService().updateUser(
        phoneNumber: phoneEditController.text.trim(),
        name: nameEditController.text.trim(),
        grade: _selectedGrade?.id ?? 0,
      );
      await AuthService().saveUser(user_);
      hasChangeOnEditProfile = false;
    } catch (e) {
      logger.e(e);
      AppSnackbar.showError('Error', 'Failed to update user');
    } finally {
      _selectedGrade = user?.grade;
      _isLoading = false;

      phoneEditController.text = user?.phoneNumber ?? '';
      nameEditController.text = fullName;
      update();
      Get.back();
    }
  }

  void navigateToEditProfile() {
    Get.toNamed('/edit-profile');
  }

  void openSupport() {
    Get.toNamed(VIEWS.support.path);
  }

  void openAppInfo() {
    AppSnackbar.showInfo('Info', 'App information page will be implemented');
  }

  void logout() {
    // Navigate to login and clear navigation stack
    Get.offAllNamed(VIEWS.login.path);
    // Logout from the auth service
    AuthService().logout();
  }

  void showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'This action will permanently delete:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            _buildDeleteWarningItem('• Your profile and personal information'),
            _buildDeleteWarningItem('• All your exam progress and scores'),
            _buildDeleteWarningItem('• Downloaded content and notes'),
            _buildDeleteWarningItem('• Account settings and preferences'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red[600], size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone!',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: _isDeletingAccount
                ? null
                : () => _confirmDeleteAccount(),
            child: _isDeletingAccount
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red[600]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteWarningItem(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
    );
  }

  void _confirmDeleteAccount() {
    Get.back(); // Close the first dialog

    Get.dialog(
      GetBuilder<ProfileController>(
        builder: (controller) {
          return AlertDialog(
            title: Text(
              'Final Confirmation',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red[600],
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Type "DELETE" to confirm account deletion:',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _deleteConfirmationController,
                  decoration: InputDecoration(
                    hintText: 'Type DELETE here',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[600]!),
                    ),
                  ),
                  onChanged: (value) => update(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _deleteConfirmationController.clear();
                  Get.back();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed:
                    _deleteConfirmationController.text.trim() == 'DELETE' &&
                        !_isDeletingAccount
                    ? () => _deleteAccount()
                    : null,
                child: _isDeletingAccount
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Delete Forever',
                        style: TextStyle(
                          color:
                              _deleteConfirmationController.text.trim() ==
                                  'DELETE'
                              ? Colors.red[600]
                              : Colors.grey[400],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteAccount() async {
    if (_isDeletingAccount) return;

    _isDeletingAccount = true;
    update();

    try {
      // Call the delete user API
      await UserService().deleteUser();

      // Clear all local data
      await _clearAllLocalData();

      Get.back(); // Close the confirmation dialog

      // Show success message
      AppSnackbar.showSuccess(
        'Account Deleted',
        'Your account has been permanently deleted',
        duration: Duration(seconds: 3),
      );

      // Navigate to login and clear all routes
      Get.offAllNamed(VIEWS.login.path);
    } catch (e) {
      logger.e('Error deleting account: $e');

      Get.back(); // Close the confirmation dialog

      AppSnackbar.showError(
        'Error',
        'Failed to delete account: ${e.toString()}',
        duration: Duration(seconds: 5),
      );
    } finally {
      _deleteConfirmationController.clear();
      _isDeletingAccount = false;
      update();
    }
  }

  Future<void> _clearAllLocalData() async {
    try {
      // Clear authentication data
      await _authService.logout();

      await HiveSubjectsStorage().clear();
      await HiveChaptersStorage().clear();
      await HiveAuthStorage().clear();
      await HiveUserStorage().clear();
      await HiveExamStorage().clear();
      await HiveQuizzesStorage().clear();
      await HiveNoteStorage().clear();
      await HiveVideoStorage().clear();

      // Clear any other local storage if available
      // You might want to add more clearing logic here based on your app's needs

      logger.i('All local data cleared after account deletion');
    } catch (e) {
      logger.e('Error clearing local data: $e');
    }
  }
}
