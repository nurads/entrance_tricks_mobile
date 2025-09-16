import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:entrance_tricks/controllers/main_navigation_controller.dart';
import 'package:entrance_tricks/views/home/home_dashboard.dart';
import 'package:entrance_tricks/views/exam/exam_page.dart';
import 'package:entrance_tricks/views/news/news_page.dart';
import 'package:entrance_tricks/views/common/profile_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainNavigationController());

    final List<Widget> pages = [
      HomeDashboard(),
      ExamPage(),
      NewsPage(),
      ProfilePage(),
    ];

    return GetBuilder<MainNavigationController>(
      builder: (controller) => Scaffold(
        body: IndexedStack(index: controller.currentIndex, children: pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    context: context,
                    controller: controller,
                    index: 0,
                    icon: Icons.home_rounded,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  _buildNavItem(
                    context: context,
                    controller: controller,
                    index: 1,
                    icon: Icons.quiz_rounded,
                    activeIcon: Icons.quiz_rounded,
                    label: 'Exams',
                  ),
                  _buildNavItem(
                    context: context,
                    controller: controller,
                    index: 2,
                    icon: Icons.newspaper_rounded,
                    activeIcon: Icons.newspaper_rounded,
                    label: 'News',
                  ),
                  _buildNavItem(
                    context: context,
                    controller: controller,
                    index: 3,
                    icon: Icons.person_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required MainNavigationController controller,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = controller.currentIndex == index;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color onSurfaceVariant = Theme.of(
      context,
    ).colorScheme.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? surfaceColor : onSurfaceVariant,
                  size: 22,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: isSelected ? primaryColor : onSurfaceVariant,
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
