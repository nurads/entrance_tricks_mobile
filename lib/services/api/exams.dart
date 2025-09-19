import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:entrance_tricks/services/api/exceptions.dart';
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
}
