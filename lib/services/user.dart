import 'package:get/get.dart';
import '../services/api/api.dart';
import '../services/api/exceptions.dart';
import '../utils/utils.dart';

import '../models/user.dart';

class UserService extends GetxController {
  final ApiClient apiClient = ApiClient();

  Future<Response<User>> getUser() async {
    final response = await apiClient.get('/auth/me');
    return response.data;
  }

  Future<Response<User>> updateUser(User user) async {
    final response = await apiClient.put('/auth/me', data: user.toJson());
    return response.data;
  }

  Future<Response<User>> deleteUser() async {
    final response = await apiClient.delete('/auth/me');
    return response.data;
  }

  Future<RegisterResponse> registerUser(
    String name,
    String phone,
    String password,
    String grade,
    String? stream,
  ) async {
    final response = await apiClient.post(
      '/auth/register',
      data: {
        'name': name,
        'phoneNumber': phone,
        'password': password,
        'grade': grade,
        'stream': stream,
      },
    );

    if (response.statusCode == 200) {
      logger.i(response.data);
      return RegisterResponse.fromJson(response.data);
    }
    logger.e(response.data);
    throw ApiException(response.data['error']['message']);
  }

  Future<AuthResponse> loginUser(String phone, String password) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {'phoneNumber': phone, 'password': password},
    );
    if (response.statusCode == 200) {
      // apiClient.setTokens(
      //   response.data['access_token'],
      //   response.data['refresh_token'],
      // );
      logger.i(response.data);

      return AuthResponse.fromJson(response.data);
    }

    logger.e(response.data);

    throw ApiException(response.data['error']['message']);

    // return AuthResponse.fromJson(response.data);
  }

  Future<VerifyPhoneResponse> verifyPhone(String phone, String otp) async {
    final response = await apiClient.post(
      '/auth/verify-otp',
      data: {'phoneNumber': phone, 'otp': otp},
    );
    // return VerifyPhoneResponse.fromJson(response.data);
    if (response.statusCode == 200) {
      // apiClient.setTokens(response.data['jwt'], response.data['jwt']);
      logger.i(response.data);
      return VerifyPhoneResponse.fromJson(response.data);
    }
    logger.e(response.data);
    throw ApiException(response.data['error']['message']);
  }
}
