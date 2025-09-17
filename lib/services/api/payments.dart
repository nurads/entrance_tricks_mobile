import 'package:get/get.dart';
import 'api.dart';
import 'exceptions.dart';
import '../../utils/utils.dart';
import '../../models/models.dart';

class PaymentService extends GetxController {
  final ApiClient apiClient = ApiClient();

  // Get all payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await apiClient.get(
        '/app/payment-methods/',
        authenticated: false,
      );

      logger.d(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        final paymentMethods = data
            .map((json) => PaymentMethod.fromJson(json))
            .toList();
        return paymentMethods;
      }

      throw ApiException('Failed to load payment methods');
    } catch (e) {
      logger.e('Error getting payment methods: $e');
      throw ApiException('Failed to load payment methods');
    }
  }

  // Create a payment
  Future<Payment> createPayment(PaymentCreateRequest paymentRequest) async {
    try {
      final response = await apiClient.post(
        'app/payments/',
        data: paymentRequest.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final payment = Payment.fromJson(response.data);
        return payment;
      }

      throw ApiException(
        response.data['error']?['message'] ?? 'Failed to create payment',
      );
    } catch (e) {
      logger.e('Error creating payment: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Failed to create payment');
    }
  }

  // Get user's payments
  Future<List<Payment>> getUserPayments() async {
    try {
      final response = await apiClient.get(
        '/app/payments/',
        authenticated: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        final payments = data.map((json) => Payment.fromJson(json)).toList();
        return payments;
      }

      logger.e(response.data);

      throw ApiException('Failed to load payments');
    } catch (e) {
      logger.e('Error getting user payments: $e');
      throw ApiException('Failed to load payments');
    }
  }

  // Upload receipt image
  Future<String> uploadReceipt(String imagePath) async {
    try {
      final response = await apiClient.uploadFile(
        '/upload',
        filePath: imagePath,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        if (data.isNotEmpty) {
          final fileId = data[0]['id'].toString();
          return fileId;
        }
      }

      throw ApiException('Failed to upload receipt');
    } catch (e) {
      logger.e('Error uploading receipt: $e');
      throw ApiException('Failed to upload receipt');
    }
  }

  // Get all available packages
  Future<List<Package>> getPackages() async {
    try {
      final response = await apiClient.get(
        '/app/packages/',
        authenticated: false,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final packages = data.map((json) => Package.fromJson(json)).toList();
        return packages;
      }

      logger.e(response.data);

      throw ApiException('Failed to load packages');
    } catch (e) {
      logger.e('Error getting packages: $e');
      throw ApiException('Failed to load packages');
    }
  }
}
