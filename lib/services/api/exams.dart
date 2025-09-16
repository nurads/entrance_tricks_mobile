import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'api.dart';
import '../../models/exam.dart';

class ExamService extends GetxService {
  final ApiClient apiClient = ApiClient();

  Future<List<Exam>> getAvailableExams({
    String? examType,
    int? subjectId,
  }) async {
    final queryParams = <String, dynamic>{};

    if (examType != null) {
      queryParams['exam_type'] = examType;
    }

    if (subjectId != null) {
      queryParams['subject_id'] = subjectId;
    }

    final response = await apiClient.get(
      '/app/exams/',
      queryParameters: queryParams,
      authenticated: true,
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((e) => Exam.fromJson(e)).toList();
    } else {
      throw ApiException(response.data['message'] ?? 'Failed to fetch exams');
    }
  }

  Future<Exam> getExamDetails(int examId) async {
    final response = await apiClient.get(
      '/exams/$examId/details',
      authenticated: true,
    );

    if (response.statusCode == 200) {
      return Exam.fromJson(response.data['data']);
    } else if (response.statusCode == 403) {
      throw ApiException('You do not have access to this exam');
    } else if (response.statusCode == 404) {
      throw ApiException('Exam not found');
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to fetch exam details',
      );
    }
  }
}
