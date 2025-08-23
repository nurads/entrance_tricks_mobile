import 'package:dio/dio.dart';

class BaseApiClient {
  final String baseUrl = 'http://192.168.1.100:8000';
  final Dio dio = Dio();

  Future<Response> get(String path) async {
    final response = await dio.get(path);
    return response;
  }
}

class ApiClient extends BaseApiClient {
  ApiClient() {
    dio.options.baseUrl = baseUrl;
  }
}
