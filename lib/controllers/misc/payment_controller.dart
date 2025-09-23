import 'dart:io';
import 'package:entrance_tricks/utils/device/device.dart';
import 'package:entrance_tricks/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/utils/utils.dart';

class PaymentController extends GetxController {
  final PaymentService _paymentService = PaymentService();
  final ImagePicker _picker = ImagePicker();

  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxList<Payment> userPayments = <Payment>[].obs;
  final RxList<Package> packages = <Package>[].obs;
  final Rx<PaymentMethod?> selectedPaymentMethod = Rx<PaymentMethod?>(null);
  final Rx<File?> selectedReceiptImage = Rx<File?>(null);

  bool isLoading = false;
  bool isLoadingPayments = false;
  bool isCreatingPayment = false;

  @override
  void onInit() {
    super.onInit();

    loadAll();
  }

  Future<void> loadAll() async {
    await Future.wait([
      loadPaymentMethods(),
      loadUserPayments(),
      loadPackages(),
    ]);

    update();
  }

  void changeSelectedPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
    update();
  }

  // Load available payment methods
  Future<void> loadPaymentMethods() async {
    try {
      isLoading = true;
      update();
      final paymentMethods_ = await _paymentService.getPaymentMethods();
      paymentMethods.value = paymentMethods_;
    } catch (e) {
      logger.e(e);
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to load payment methods',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  // Load user's payment history
  Future<void> loadUserPayments() async {
    try {
      isLoadingPayments = true;
      update();
      final device = await UserDevice.getDeviceInfo();
      final userPayments_ = await _paymentService.getUserPayments(device.id);
      userPayments.value = userPayments_;
    } catch (e) {
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to load payment history',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingPayments = false;
      update();
    }
  }

  // Select payment method
  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  // Pick receipt image from gallery
  Future<void> pickReceiptImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        selectedReceiptImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Take receipt photo with camera
  Future<void> takeReceiptPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        selectedReceiptImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Load available packages
  Future<void> loadPackages() async {
    try {
      isLoading = true;
      update();
      final device = await UserDevice.getDeviceInfo();
      final packages_ = await _paymentService.getPackages(device.id);
      logger.d(packages_);
      packages.value = packages_;
    } catch (e) {
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to load packages',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  // Create payment
  Future<bool> createPayment(int packageId, int amount) async {
    isCreatingPayment = true;
    update();

    if (selectedPaymentMethod.value == null) {
      Get.snackbar(
        'Error',
        'Please select a payment method',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedReceiptImage.value == null) {
      Get.snackbar(
        'Error',
        'Please upload a receipt image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isCreatingPayment = true;
      update();
      final device = await UserDevice.getDeviceInfo();
      await _paymentService.uploadReceipt(
        file: selectedReceiptImage.value!,
        package: packageId,
        paymentMethod: selectedPaymentMethod.value!.id,
        amount: amount,
        device: device.id,
      );

      Get.snackbar(
        'Success',
        'Payment submitted successfully! It will be reviewed by admin!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // Reset form
      selectedPaymentMethod.value = null;
      selectedReceiptImage.value = null;

      // Refresh user payments
      loadUserPayments();

      Get.offAllNamed(VIEWS.home.path);
      return true;
    } catch (e) {
      logger.e(e);
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to create payment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isCreatingPayment = false;
      update();
    }
  }

  // Clear selected items
  void clearSelection() {
    selectedPaymentMethod.value = null;
    selectedReceiptImage.value = null;
  }

  // Get payment status color
  Color getPaymentStatusColor(bool isCompleted) {
    if (isCompleted) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  // Get payment status icon
  IconData getPaymentStatusIcon(bool isCompleted) {
    if (isCompleted) {
      return Icons.check_circle;
    } else {
      return Icons.pending;
    }
  }
}
