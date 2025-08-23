import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/main_navigation_controller.dart';
import 'package:entrance_tricks/views/home_dashboard.dart';
import 'package:entrance_tricks/views/subject_page.dart';
import 'package:entrance_tricks/views/exam_page.dart';
import 'package:entrance_tricks/views/news_page.dart';
import 'package:entrance_tricks/views/profile_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainNavigationController());

    final List<Widget> pages = [
      HomeDashboard(),
      SubjectPage(),
      ExamPage(),
      NewsPage(),
      ProfilePage(),
    ];

    return GetBuilder<MainNavigationController>(
      builder: (controller) => Scaffold(
        body: IndexedStack(index: controller.currentIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Subjects'),
            BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Exam'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
