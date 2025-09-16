import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../services/api/exceptions.dart';
import '../utils/utils.dart';

class PaymentController extends GetxController {
  final PaymentService _paymentService = PaymentService();
  final ImagePicker _picker = ImagePicker();

  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxList<Payment> userPayments = <Payment>[].obs;
  final RxList<Package> packages = <Package>[].obs;
  final Rx<PaymentMethod?> selectedPaymentMethod = Rx<PaymentMethod?>(null);
  final Rx<File?> selectedReceiptImage = Rx<File?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingPayments = false.obs;
  final RxBool isCreatingPayment = false.obs;
  final RxBool isUploadingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
    loadUserPayments();
    loadPackages();
  }

  // Load available payment methods
  Future<void> loadPaymentMethods() async {
    try {
      isLoading.value = true;
      final response = await _paymentService.getPaymentMethods();
      paymentMethods.value = response.body ?? [];
    } catch (e) {
      logger.e(e);
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to load payment methods',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load user's payment history
  Future<void> loadUserPayments() async {
    try {
      isLoadingPayments.value = true;
      final response = await _paymentService.getUserPayments();
      userPayments.value = response.body ?? [];
    } catch (e) {
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to load payment history',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingPayments.value = false;
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
      isLoading.value = true;
      final response = await _paymentService.getPackages();
      packages.value = response.body ?? [];
    } catch (e) {
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to load packages',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create payment
  Future<bool> createPayment(int packageId, int amount) async {
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
      isCreatingPayment.value = true;

      // First upload the receipt image
      final uploadResponse = await _paymentService.uploadReceipt(
        selectedReceiptImage.value!.path,
      );

      if (uploadResponse.body == null) {
        throw ApiException('Failed to upload receipt');
      }

      // Create payment request
      final paymentRequest = PaymentCreateRequest(
        package: packageId,
        paymentMethod: selectedPaymentMethod.value!.id,
        amount: amount,
        receipt: int.parse(uploadResponse.body!),
      );

      // Create the payment
      final response = await _paymentService.createPayment(paymentRequest);

      if (response.body != null) {
        Get.snackbar(
          'Success',
          'Payment submitted successfully! It will be reviewed by admin.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Reset form
        selectedPaymentMethod.value = null;
        selectedReceiptImage.value = null;

        // Refresh user payments
        loadUserPayments();

        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e is ApiException ? e.message : 'Failed to create payment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isCreatingPayment.value = false;
    }
  }

  // Get subject package info
  Future<Map<String, dynamic>?> getSubjectPackageInfo(int subjectId) async {
    try {
      final response = await _paymentService.getSubjectPackageInfo(subjectId);
      return response.body;
    } catch (e) {
      return null;
    }
  }

  // Clear selected items
  void clearSelection() {
    selectedPaymentMethod.value = null;
    selectedReceiptImage.value = null;
  }
}
