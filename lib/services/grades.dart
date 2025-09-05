import 'package:get/get.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import '../services/api/api.dart';
import '../models/grade.dart';

class GradeService extends GetxController {
  final ApiClient apiClient = ApiClient();

  Future<List<Grade>> getGrades() async {
    final response = await apiClient.get('/grades', authenticated: false);
    if (response.statusCode == 200) {
      return (response.data['data'] as List)
          .map((e) => Grade.fromJson(e))
          .toList();
    } else {
      throw ApiException(response.data['message']);
    }
  }
}
