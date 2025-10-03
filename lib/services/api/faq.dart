import 'package:entrance_tricks/services/api/api.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/services/api/exceptions.dart';
import 'package:entrance_tricks/utils/utils.dart';

class FAQApiService {
  final apiClient = ApiClient();

  Future<List<FAQ>> getFAQs() async {
    final response = await apiClient.get('/app/faqs', authenticated: false);
    logger.d(response.data);
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => FAQ.fromJson(e)).toList();
    }
    throw ApiException(response.data['detail'] ?? 'Failed to get FAQs');
  }
}
