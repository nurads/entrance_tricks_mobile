import 'package:get/get.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import '../services/api/api.dart';

import '../models/models.dart';
import '../services/session.dart';

class SubjectsService extends GetxController {
  final ApiClient apiClient = ApiClient();

  Future<List<Subject>> getSubjects() async {
    final response = await apiClient.get(
      '/subjects?grade=${session?.user.grade.id}',
      authenticated: false,
    );
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Subject.fromJson(e)).toList();
    } else {
      throw ApiException(response.data['message']);
    }
  }

  Future<Subject> getSubject(int subjectId) async {
    final response = await apiClient.get('/subjects/$subjectId');
    if (response.statusCode == 200) {
      return Subject.fromJson(response.data);
    } else {
      throw ApiException(response.data['message']);
    }
  }
}
