import 'package:get/get.dart';

class NewsController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _news = [];
  List<Map<String, dynamic>> get news => _news;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  void loadNews() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      _news = [
        {
          'id': 1,
          'title': 'New Physics Chapter Added',
          'excerpt': 'We have added a new chapter on Quantum Mechanics to help you prepare better.',
          'date': '2024-01-15',
        },
        {
          'id': 2,
          'title': 'Mock Test Results Available',
          'excerpt': 'Results for the last mock test are now available. Check your performance.',
          'date': '2024-01-12',
        },
        {
          'id': 3,
          'title': 'Scholarship Announcement',
          'excerpt': 'New scholarship program launched for top performers in entrance exams.',
          'date': '2024-01-10',
        },
        {
          'id': 4,
          'title': 'App Update v2.1.0',
          'excerpt': 'New features added including dark mode and better video player.',
          'date': '2024-01-08',
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void readNews(int newsId) {
    // Navigate to news detail page
    Get.snackbar('Info', 'News detail page will be implemented');
  }
}
