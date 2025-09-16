import 'package:get/get.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'api.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';

class SubjectsService extends GetxController {
  final ApiClient apiClient = ApiClient();

  Future<List<Subject>> getSubjects(int gradeId) async {
    try {
      final response = await apiClient.get(
        '/app/subjects?grade=$gradeId',
        authenticated: false,
      );
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Subject.fromJson(e)).toList();
      } else {
        throw ApiException('Failed to get subjects');
      }
    } catch (e) {
      logger.e(e);
      throw ApiException(e.toString());
    }
  }

  Future<Subject> getSubject(int subjectId) async {
    try {
      final response = await apiClient.get('/app/subjects/$subjectId');
      if (response.statusCode == 200) {
        return Subject.fromJson(response.data['data']);
      } else {
        throw ApiException('Failed to get subject');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
