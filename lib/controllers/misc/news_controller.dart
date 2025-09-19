import 'package:get/get.dart';
import 'package:entrance_tricks/views/news/news_detail_page.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';
import 'package:entrance_tricks/utils/utils.dart';

class NewsController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<News> _news = [];
  List<News> get news => _news;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
    _isLoading = true;
    update();

    try {
      _news = await NewsService().getNews();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news');
      logger.e(e);
    } finally {
      _isLoading = false;
      update();
    }
  }

  void openNewsDetail(int newsId) {
    final news = _news.firstWhere((n) => n.id == newsId);
    Get.to(() => NewsDetailPage(news: news));
  }

  void refreshNews() {
    loadNews();
  }
}
