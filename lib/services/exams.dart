import 'package:get/get.dart';
import '../services/api/api.dart';
import '../models/exam.dart';

class ExamService extends GetxController {
  final ApiClient apiClient = ApiClient();

  Future<Response<Exam>> getExams() async {
    final response = await apiClient.get('/exams');
    return response.data;
  }
}
