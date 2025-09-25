import 'package:get/get.dart';
import 'package:entrance_tricks/views/news/news_detail_page.dart';
import 'package:entrance_tricks/services/services.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:entrance_tricks/utils/utils.dart';

class NewsController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<News> _news = [];
  List<News> get news => _news;
  List<News> _allNews = [];
  News? featuredNews;
  int selectedCategoryIndex = 0;
  List<String> categories = [];

  setSelectedCategoryIndex(int index) {
    selectedCategoryIndex = index;
    update();
  }

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
      _allNews = _news;
      featuredNews = _allNews.first;
      categories = _allNews.map((e) => e.category).toSet().toList();
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

  void changeCategory(int index) {
    selectedCategoryIndex = index;
    final category = categories[index];
    _news = _allNews.where((n) => n.category == category).toList();
    update();
  }

  void refreshNews() {
    loadNews();
  }
}
