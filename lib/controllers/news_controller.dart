import 'package:get/get.dart';
import 'package:entrance_tricks/views/news/news_detail_page.dart';

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

  Future<void> loadNews() async {
    _isLoading = true;
    update();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      _news = [
        {
          'id': 1,
          'title': 'Grade 12 Entrance Exam Result Announcement day',
          'category': 'Education',
          'timeAgo': '3 min ago',
          'imageUrl': 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&h=200&fit=crop',
          'content': 'Freshman Tricks has launched a feature that provides students with detailed information about the department they will be joining next, the university they will attend, and the freshman courses available to them. This service will continue to offer guidance and updates until official results are released, helping new students prepare and plan ahead for their academic journey. Here is the links "@freshman_tricks"',
        },
        {
          'id': 2,
          'title': 'Freshman Tricks now provides info on your next department, university, and freshman courses until results are out.',
          'category': 'Education',
          'timeAgo': '1 hour ago',
          'imageUrl': 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&h=200&fit=crop',
          'content': 'Freshman Tricks has launched a feature that provides students with detailed information about the department they will be joining next, the university they will attend, and the freshman courses available to them. This service will continue to offer guidance and updates until official results are released, helping new students prepare and plan ahead for their academic journey. Here is the links "@freshman_tricks"',
        },
        {
          'id': 3,
          'title': 'New Physics Chapter: Quantum Mechanics',
          'category': 'Education',
          'timeAgo': '2 hours ago',
          'imageUrl': 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&h=200&fit=crop',
          'content': 'We have added comprehensive study materials for Quantum Mechanics including videos, notes, and practice questions.',
        },
        {
          'id': 4,
          'title': 'Scholarship Program 2024',
          'category': 'Education',
          'timeAgo': '1 day ago',
          'imageUrl': 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&h=200&fit=crop',
          'content': 'Applications are now open for our merit-based scholarship program. Top performers will receive up to 100% fee waiver.',
        },
        {
          'id': 5,
          'title': 'App Update: Dark Mode Available',
          'category': 'Technology',
          'timeAgo': '2 days ago',
          'imageUrl': 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&h=200&fit=crop',
          'content': 'The latest app update includes dark mode, improved video player, and better offline support.',
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void openNewsDetail(int newsId) {
    final news = _news.firstWhere((n) => n['id'] == newsId);
    Get.to(() => NewsDetailPage(news: news));
  }

  void refreshNews() {
    loadNews();
  }
}
