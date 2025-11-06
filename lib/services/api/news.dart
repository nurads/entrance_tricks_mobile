import 'package:vector_academy/models/models.dart';
import 'api.dart';

class NewsService {
  final _apiClient = ApiClient();

  Future<List<News>> getNews() async {
    final response = await _apiClient.get('/app/news', authenticated: false);
    return (response.data as List).map((e) => News.fromJson(e)).toList();
  }

  Future<News?> getNewsById(int newsId) async {
    try {
      final allNews = await getNews();
      return allNews.firstWhere((news) => news.id == newsId);
    } catch (e) {
      return null;
    }
  }
}
