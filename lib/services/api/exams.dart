import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'api.dart';
import '../../models/exam.dart';
import '../../models/question.dart';

class ExamService extends GetxService {
  final ApiClient apiClient = ApiClient();

  Future<List<Exam>> getAvailableExams(
    String deviceId, {
    String? examType,
    String? excludeExamType,
    int? subjectId,
    int? chapterId,
    int? gradeId,
    bool onlyUnlocked = false,
  }) async {
    final queryParams = <String, dynamic>{};

    if (examType != null) {
      queryParams['exam_type'] = examType;
    }

    if (excludeExamType != null) {
      queryParams['exclude_exam_type'] = excludeExamType;
    }

    if (subjectId != null) {
      queryParams['subject'] = subjectId;
    }
    if (chapterId != null) {
      queryParams['chapter'] = chapterId;
    }
    if (gradeId != null) {
      queryParams['grade'] = gradeId;
    }
    if (onlyUnlocked) {
      queryParams['only_unlocked'] = true;
    }

    final response = await apiClient.get(
      '/app/exams/?device=$deviceId',
      queryParameters: queryParams,
      authenticated: true,
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((e) => Exam.fromJson(e)).toList();
    } else {
      throw ApiException(response.data['detail'] ?? 'Failed to fetch exams');
    }
  }

  Future<List<Question>> getQuestions(String deviceId, int examId) async {
    final response = await apiClient.get(
      '/app/questions/',
      authenticated: true,
      queryParameters: {'device': deviceId, 'exam': examId},
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Question.fromJson(e)).toList();
    } else {
      throw ApiException(
        response.data['detail'] ?? 'Failed to fetch questions',
      );
    }
  }
}
