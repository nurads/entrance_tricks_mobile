import 'package:get/get.dart';
import 'api.dart';
import 'exceptions.dart';
import '../../utils/utils.dart';
import '../../models/models.dart';

class PaymentService extends GetxController {
  final ApiClient apiClient = ApiClient();

  // Get all payment methods
  Future<Response<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final response = await apiClient.get(
        'app/payment-methods/',
        authenticated: false,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        final paymentMethods = data
            .map((json) => PaymentMethod.fromJson(json))
            .toList();
        return Response(body: paymentMethods);
      }

      throw ApiException('Failed to load payment methods');
    } catch (e) {
      logger.e('Error getting payment methods: $e');
      throw ApiException('Failed to load payment methods');
    }
  }

  // Create a payment
  Future<Response<Payment>> createPayment(
    PaymentCreateRequest paymentRequest,
  ) async {
    try {
      final response = await apiClient.post(
        'app/payments/',
        data: {'data': paymentRequest.toJson()},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final payment = Payment.fromJson(response.data);
        return Response(body: payment);
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
  Future<Response<List<Payment>>> getUserPayments() async {
    try {
      final response = await apiClient.get('/payments', authenticated: true);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final payments = data.map((json) => Payment.fromJson(json)).toList();
        return Response(body: payments);
      }

      logger.e(response.data);

      throw ApiException('Failed to load payments');
    } catch (e) {
      logger.e('Error getting user payments: $e');
      throw ApiException('Failed to load payments');
    }
  }

  // Upload receipt image
  Future<Response<String>> uploadReceipt(String imagePath) async {
    try {
      final response = await apiClient.uploadFile(
        '/upload',
        filePath: imagePath,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        if (data.isNotEmpty) {
          final fileId = data[0]['id'].toString();
          return Response(body: fileId);
        }
      }

      throw ApiException('Failed to upload receipt');
    } catch (e) {
      logger.e('Error uploading receipt: $e');
      throw ApiException('Failed to upload receipt');
    }
  }

  // Get all available packages
  Future<Response<List<Package>>> getPackages() async {
    try {
      final response = await apiClient.get(
        '/packages?filters[is_active][\$eq]=true&populate=subjects',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final packages = data.map((json) => Package.fromJson(json)).toList();
        return Response(body: packages);
      }

      logger.e(response.data);

      throw ApiException('Failed to load packages');
    } catch (e) {
      logger.e('Error getting packages: $e');
      throw ApiException('Failed to load packages');
    }
  }

  // Get subject's package info
  Future<Response<Map<String, dynamic>>> getSubjectPackageInfo(
    int subjectId,
  ) async {
    try {
      final response = await apiClient.get(
        '/subjects/$subjectId?populate=package',
      );

      if (response.statusCode == 200) {
        // Add null safety checks
        final responseData = response.data;
        if (responseData == null) {
          logger.w('Response data is null for subject $subjectId');
          throw ApiException('Invalid response from server');
        }

        final subject = responseData['data'];
        if (subject == null) {
          logger.w('Subject data is null for subject $subjectId');
          throw ApiException('Subject not found');
        }

        final package = subject['package'];

        if (package == null) {
          return Response(
            body: {
              'hasPackage': false,
              'isFree': true,
              'title': subject['title'] ?? '',
            },
          );
        }

        return Response(
          body: {
            'hasPackage': true,
            'isFree': false,
            'packageId': package['id'],
            'packageName': package['name'] ?? '',
            'packagePrice': package['price'] ?? 0,
            'title': subject['title'] ?? '',
          },
        );
      }

      logger.i(response.data);

      throw ApiException('Failed to get subject package info');
    } catch (e) {
      logger.e('Error getting subject package info: $e');
      throw ApiException('Failed to get subject package info');
    }
  }
}
